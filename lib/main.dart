import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'config/localization/generated/l10n.dart';
import 'config/routes/app_router.dart';
import 'config/di/injection_container.dart' as di;
import 'core/services/notifications/notification_service.dart';
import 'core/theme/builder/app_theme_builder.dart';
import 'features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/chat/presentation/cubit/chat/chat_cubit.dart';
import 'features/network_system/presentation/cubit/connectivity/connectivity_cubit.dart';
import 'features/patch_update/presentation/cubit/patch_cubit.dart';
import 'features/settings/presentation/cubit/cubit/settings_cubit.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService.instance.handleBackgroundMessage(message);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => di.sl<AuthCubit>()),
            BlocProvider(create: (_) => di.sl<ConnectivityCubit>()),
            BlocProvider(create: (_) => di.sl<SettingsCubit>()),
            BlocProvider(create: (_) => di.sl<ChatCubit>()),
            BlocProvider(
              create: (_) => di.sl<PatchCubit>()..checkForNewPatch(),
            ),
          ],
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settings) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                // ── Theme ─────────────────────────────────────────────
                theme: AppThemeBuilder.light(),
                darkTheme: AppThemeBuilder.dark(),
                themeMode: settings.themeMode,
                // ── Locale ────────────────────────────────────────────
                locale: settings.locale,
                localizationsDelegates: [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                routerConfig: AppRouter.router,
              );
            },
          ),
        );
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Load environment variables ─────────────────────────────────────
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(true);

  // ── Firestore Offline Persistence ───────────────────────────────────
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // ── HydratedBloc storage (required for SettingsCubit) ─────────────────
  final storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
  HydratedBloc.storage = storage;

  await di.init();

  NotificationService.instance.debugLogging = false; // false before release
  await NotificationService.instance.initialize();

  runApp(const MyApp());
}
