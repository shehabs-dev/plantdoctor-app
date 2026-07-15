import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// ---------------------------------------------------------------------------
// Background message handler — MUST be a top-level function (not a method).
//
// Copy this into your main.dart:
//
//   @pragma('vm:entry-point')
//   Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//     NotificationService.instance.handleBackgroundMessage(message);
//   }
// ---------------------------------------------------------------------------

/// Notification topics used across the app.
///
/// Add new topics here as your app grows — never use raw strings elsewhere.

/// ╔══════════════════════════════════════════════╗
/// ║  NOTIFICATION ICON CONFIG (change once here) ║
/// ╚══════════════════════════════════════════════╝

const String kNotificationIcon = '@mipmap/launcher_icon';

abstract class NotificationTopics {
  /// Every user subscribes to this on login.
  static const String all = 'all_users';

  /// Subscribed when user upgrades to premium.
  static const String premium = 'premium_users';

  /// For users who just registered (e.g. first 7 days).
  static const String newUsers = 'new_users';

  /// For users who haven't opened the app in a while.
  static const String inactive = 'inactive_users';

  /// Internal team / admin notifications.
  static const String admins = 'admins';

  /// Locale-based topic — call with a country code e.g. NotificationTopics.locale('eg')
  static String locale(String countryCode) => 'locale_$countryCode';
}

/// A self-contained, reusable service that wraps Firebase Cloud Messaging (FCM)
/// and flutter_local_notifications into a single public API.
///
/// Uses **topics exclusively** — no individual device tokens.
/// Scales to any number of users with zero extra infrastructure.
///
/// ### Setup (in main.dart):
/// ```dart
/// await NotificationService.instance.initialize();
/// ```
///
/// ### After login:
/// ```dart
/// await NotificationService.instance.subscribeToTopic(NotificationTopics.all);
/// ```
///
/// ### After logout:
/// ```dart
/// await NotificationService.instance.unsubscribeFromAllTopics();
/// ```
class NotificationService {
  // ─── Singleton ─────────────────────────────────────────────────────────────

  NotificationService._();

  /// The shared instance of [NotificationService].
  static final NotificationService instance = NotificationService._();

  // ─── Internal state ────────────────────────────────────────────────────────

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Tracks currently active topics so [unsubscribeFromAllTopics] works
  /// without needing the caller to remember what was subscribed.
  final Set<String> _activeTopics = {};

  /// Set to `true` during development to print logs.
  /// Always set to `false` before releasing to production.
  bool debugLogging = false;

  // ─── Tap stream ────────────────────────────────────────────────────────────

  /// Emits a [NotificationTapPayload] whenever the user taps a notification,
  /// regardless of whether the app was terminated, backgrounded, or foregrounded.
  ///
  /// Listen once at your app root widget:
  /// ```dart
  /// NotificationService.instance.notificationTapStream.listen((payload) {
  ///   // navigate, show dialog, etc.
  /// });
  /// ```
  Stream<NotificationTapPayload> get notificationTapStream =>
      _tapController.stream;

  final StreamController<NotificationTapPayload> _tapController =
      StreamController<NotificationTapPayload>.broadcast();

  // ─── Android notification channel ──────────────────────────────────────────

  static const String _defaultChannelId = 'default_notification_channel';
  static const String _defaultChannelName = 'General Notifications';
  static const String _defaultChannelDescription = 'General app notifications.';

  // ─── Public API ────────────────────────────────────────────────────────────

  /// Initialises FCM and flutter_local_notifications.
  ///
  /// Call once in `main()` after `Firebase.initializeApp()`.
  /// Safe to call multiple times — subsequent calls are no-ops.
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await _requestPermissions();
      await _configureLocalNotifications();
      _configureMessageHandlers();
      await _handleTerminatedAppLaunch();

      _initialized = true;
      _log('NotificationService initialised.');
    } catch (e, st) {
      _logError('Failed to initialise NotificationService', e, st);
    }
  }

  /// Subscribes this device to [topic].
  ///
  /// Use the constants in [NotificationTopics] — never raw strings.
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      _activeTopics.add(topic);
      _log('Subscribed to topic: $topic');
    } catch (e, st) {
      _logError('Failed to subscribe to topic "$topic"', e, st);
    }
  }

  /// Unsubscribes this device from [topic].
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      _activeTopics.remove(topic);
      _log('Unsubscribed from topic: $topic');
    } catch (e, st) {
      _logError('Failed to unsubscribe from topic "$topic"', e, st);
    }
  }

  /// Unsubscribes from **all** active topics at once.
  ///
  /// Call this on logout so the device stops receiving notifications.
  Future<void> unsubscribeFromAllTopics() async {
    final topics = Set<String>.from(_activeTopics);
    for (final topic in topics) {
      await unsubscribeFromTopic(topic);
    }
    _log('Unsubscribed from all topics.');
  }

  /// Returns the list of topics this device is currently subscribed to.
  List<String> get activeTopics => List.unmodifiable(_activeTopics);

  /// Displays an immediate local notification with an optional [payload].
  ///
  /// Useful for in-app alerts that don't need to go through Firebase.
  Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
    int id = 0,
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        _defaultChannelId,
        _defaultChannelName,
        channelDescription: _defaultChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: kNotificationIcon, // 👈 IMPORTANT
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      await _localNotifications.show(
        id,
        title,
        body,
        NotificationDetails(android: androidDetails, iOS: iosDetails),
        payload: _serialisePayload(payload),
      );

      _log('Local notification shown — "$title"');
    } catch (e, st) {
      _logError('Failed to show local notification', e, st);
    }
  }

  /// Call this from your top-level background message handler in main.dart.
  void handleBackgroundMessage(RemoteMessage message) {
    _log('Background message received: ${message.messageId}');
  }

  /// Releases resources. Only needed in tests or on full app shutdown.
  void dispose() {
    _tapController.close();
  }

  // ─── Private ───────────────────────────────────────────────────────────────

  Future<void> _requestPermissions() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.requestNotificationsPermission();
    }

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _configureLocalNotifications() async {
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings(kNotificationIcon),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
      onDidReceiveBackgroundNotificationResponse:
          _onBackgroundLocalNotificationTap,
    );

    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _defaultChannelId,
              _defaultChannelName,
              description: _defaultChannelDescription,
              importance: Importance.high,
            ),
          );
    }
  }

  void _configureMessageHandlers() {
    // Foreground: show a local notification ourselves since Firebase
    // suppresses foreground notifications on Android by default.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _log('Foreground message: ${message.messageId}');
      final n = message.notification;
      if (n != null) {
        showNotification(
          title: n.title ?? '',
          body: n.body ?? '',
          payload: message.data,
        );
      }
    });

    // Background → foreground tap.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _log('Opened from background: ${message.messageId}');
      _emitTap(
        NotificationTapPayload(
          source: NotificationSource.background,
          data: message.data,
          remoteMessage: message,
        ),
      );
    });
  }

  Future<void> _handleTerminatedAppLaunch() async {
    try {
      final initial = await _messaging.getInitialMessage();
      if (initial != null) {
        Future.microtask(
          () => _emitTap(
            NotificationTapPayload(
              source: NotificationSource.terminated,
              data: initial.data,
              remoteMessage: initial,
            ),
          ),
        );
      }

      final details = await _localNotifications
          .getNotificationAppLaunchDetails();
      if (details != null && details.didNotificationLaunchApp) {
        Future.microtask(
          () => _emitTap(
            NotificationTapPayload(
              source: NotificationSource.terminated,
              data: _deserialisePayload(details.notificationResponse?.payload),
            ),
          ),
        );
      }
    } catch (e, st) {
      _logError('Error handling terminated-app launch', e, st);
    }
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    _emitTap(
      NotificationTapPayload(
        source: NotificationSource.foreground,
        data: _deserialisePayload(response.payload),
      ),
    );
  }

  void _emitTap(NotificationTapPayload payload) {
    if (!_tapController.isClosed) _tapController.add(payload);
  }

  String? _serialisePayload(Map<String, dynamic>? payload) {
    if (payload == null || payload.isEmpty) return null;
    return payload.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}',
        )
        .join('&');
  }

  Map<String, dynamic> _deserialisePayload(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    return Map.fromEntries(
      raw.split('&').map((part) {
        final kv = part.split('=');
        if (kv.length != 2) return MapEntry(part, '');
        return MapEntry(Uri.decodeComponent(kv[0]), Uri.decodeComponent(kv[1]));
      }),
    );
  }

  void _log(String message) {
    if (debugLogging) print('[NotificationService] $message');
  }

  void _logError(String message, Object error, StackTrace st) {
    print('[NotificationService] ERROR — $message\n$error\n$st');
  }
}

// ---------------------------------------------------------------------------
// Top-level background tap handler — must NOT be inside any class.
// ---------------------------------------------------------------------------

@pragma('vm:entry-point')
void _onBackgroundLocalNotificationTap(NotificationResponse response) {
  print('[NotificationService] Background local tap: ${response.payload}');
}

// ---------------------------------------------------------------------------
// Data classes
// ---------------------------------------------------------------------------

/// Where a notification tap originated.
enum NotificationSource { terminated, background, foreground }

/// Data emitted on [NotificationService.notificationTapStream].
class NotificationTapPayload {
  const NotificationTapPayload({
    required this.source,
    this.data = const {},
    this.remoteMessage,
  });

  final NotificationSource source;
  final Map<String, dynamic> data;
  final RemoteMessage? remoteMessage;

  @override
  String toString() => 'NotificationTapPayload(source: $source, data: $data)';
}
