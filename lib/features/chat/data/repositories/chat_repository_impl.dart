import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/location/location_service.dart';
import '../../../network_system/domain/repositories/network_info.dart';
import '../../domain/entities/auto_report_entity.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/auto_report_local_data_source.dart';
import '../datasources/auto_report_remote_data_source.dart';
import '../datasources/chat_local_data_source.dart';
import '../datasources/chat_remote_data_source.dart';
import '../datasources/cloudinary_data_source.dart';
import '../datasources/rag_data_source.dart';
import '../datasources/tflite_data_source.dart';
import '../models/auto_report_model.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;
  final ChatLocalDataSource _localDataSource;
  final AutoReportRemoteDataSource _reportRemoteDataSource;
  final AutoReportLocalDataSource _reportLocalDataSource;
  final TFLiteDataSource _tfliteDataSource;
  final CloudinaryDataSource _cloudinaryDataSource;
  final RagDataSource _ragDataSource;
  final NetworkInfo _networkInfo;
  final LocationService _locationService;

  ChatRepositoryImpl({
    required ChatRemoteDataSource remoteDataSource,
    required ChatLocalDataSource localDataSource,
    required AutoReportRemoteDataSource reportRemoteDataSource,
    required AutoReportLocalDataSource reportLocalDataSource,
    required TFLiteDataSource tfliteDataSource,
    required CloudinaryDataSource cloudinaryDataSource,
    required RagDataSource ragDataSource,
    required NetworkInfo networkInfo,
    required LocationService locationService,
  }) : _networkInfo = networkInfo,
       _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _reportRemoteDataSource = reportRemoteDataSource,
       _reportLocalDataSource = reportLocalDataSource,
       _tfliteDataSource = tfliteDataSource,
       _cloudinaryDataSource = cloudinaryDataSource,
       _ragDataSource = ragDataSource,
       _locationService = locationService;

  String? _activePreloadUserId;
  Future<Map<String, List<MessageModel>>>? _activePreloadMessagesFuture;

  // ─── Chat ────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> preload(String userId) async {
    if (_activePreloadUserId == userId &&
        _activePreloadMessagesFuture != null) {
      await _activePreloadMessagesFuture;
      return right(null);
    }

    try {
      _activePreloadUserId = userId;
      _activePreloadMessagesFuture = _preloadMessagesPhase(userId);
      final messagesByChatId = await _activePreloadMessagesFuture!;

      if (messagesByChatId.isNotEmpty) {
        unawaited(_preloadImagesPhase(messagesByChatId));
      }

      return right(null);
    } on CacheException {
      return left(CacheFailure());
    } on OfflineException {
      return right(null);
    } catch (_) {
      return right(null);
    } finally {
      _activePreloadMessagesFuture = null;
      if (_activePreloadUserId == userId) {
        _activePreloadUserId = null;
      }
    }
  }

  Future<Map<String, List<MessageModel>>> _preloadMessagesPhase(
    String userId,
  ) async {
    final isOnline = await _networkInfo.isConnected;
    if (!isOnline) return {};

    final remoteChats = await _remoteDataSource.getChats(
      userId,
      limit: 10,
      source: Source.serverAndCache,
    );

    if (remoteChats.isEmpty) return {};

    final messagesByChatId = <String, List<MessageModel>>{};
    for (final chat in remoteChats) {
      try {
        await _localDataSource.saveChat(chat);
        final messages = await _remoteDataSource.getMessages(
          chat.id,
          limit: 20,
          source: Source.serverAndCache,
        );
        // Reconstruct classification cards before caching so getCachedMessages
        // returns the correct composite format and the UI never shows a plain-text
        // assistant message as a flicker before _fetchMessages corrects it.
        final remoteById = {for (final m in messages) m.id: m};
        final withCards = _reconstructAssistantCards(messages, remoteById, {});
        await _localDataSource.saveMessages(withCards);
        messagesByChatId[chat.id] = withCards;
      } catch (_) {
        continue;
      }
    }

    return messagesByChatId;
  }

  Future<void> _preloadImagesPhase(
    Map<String, List<MessageModel>> messagesByChatId,
  ) async {
    if (!await _networkInfo.isConnected) return;

    for (final entry in messagesByChatId.entries) {
      try {
        final withAssets = await _cacheUserImagesIfNeeded(entry.value);
        await _localDataSource.saveMessages(withAssets);
      } catch (_) {
        continue;
      }
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> createChat(ChatEntity chat) async {
    try {
      final model = ChatModel.fromEntity(chat);
      await _localDataSource.saveChat(model); // Hive — unchanged

      // Online: register RAG session only — RAG backend writes Firestore + timestamps.
      await _ragDataSource.startChat(chatId: chat.id, title: chat.title);

      final syncedModel = ChatModel.fromEntity(
        ChatEntity(
          id: chat.id,
          userId: chat.userId,
          title: chat.title,
          createdAt: chat.createdAt,
          updatedAt: chat.updatedAt,
          isSynced: true,
        ),
      );
      await _localDataSource.saveChat(syncedModel);

      // isSynced = RAG session registered (Firestore chat/messages owned by RAG).
      return right(chat.copyWith(isSynced: true));
    } on ServerException {
      return right(chat.copyWith(isSynced: false));
    } on OfflineException {
      return right(chat.copyWith(isSynced: false));
    } on CacheException {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> getCachedChats(
    String userId,
  ) async {
    try {
      final allLocal = await _localDataSource.getAllChats();

      // CRITICAL BUG FIX: Filter by userId to prevent account leakage
      final userChats = allLocal
          .where((chat) => chat.userId == userId)
          .toList();

      // Ensure they are sorted by date
      userChats.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      return right(userChats);
    } catch (_) {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> clearCache() async {
    try {
      await _localDataSource.clearAll();
      return right(unit);
    } catch (_) {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> getChats(
    String userId, {
    int? limit,
  }) async {
    try {
      final isOnline = await _networkInfo.isConnected;

      // When offline, return Hive directly — do NOT touch Firestore's SDK cache.
      //
      // Why: Firestore's local query cache only reflects what was last fetched
      // from the server. If a new chat was created while online (RAG writes it
      // to Firestore) but getChats was not refreshed before going offline, the
      // SDK cache still holds the old query result — without the new chat.
      // Writing that stale result back to Hive via saveChats() would corrupt
      // the correct local state and cause the new chat to disappear.
      //
      // Hive is always authoritative offline: every chat is saved to Hive on
      // creation (createChat saves to Hive before calling RAG), so Hive is
      // never behind Firestore from the client's perspective.
      if (!isOnline) {
        final allLocal = await _localDataSource.getAllChats();
        final userChats = allLocal
            .where((chat) => chat.userId == userId)
            .toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        return right(userChats);
      }

      // Online path — behaviour unchanged from before.
      final remoteChats = await _remoteDataSource.getChats(
        userId,
        limit: limit,
        source: Source.serverAndCache,
      );
      final pendingChats = await _localDataSource.getPendingChats();

      final remoteIds = remoteChats.map((c) => c.id).toSet();

      // Prune local chats that were synced but no longer exist on the server
      // (e.g. deleted from another device or directly in Firestore console).
      // Only runs on a full fetch (limit == null) to avoid pruning on previews.
      if (limit == null) {
        final allLocalChats = await _localDataSource.getAllChats();
        for (final localChat in allLocalChats) {
          if (localChat.isSynced && !remoteIds.contains(localChat.id)) {
            await _localDataSource.deleteChat(localChat.id);
            await _localDataSource.deleteMessagesByChatId(localChat.id);
          }
        }
      }

      final uniquePending = pendingChats
          .where((c) => c.userId == userId && !remoteIds.contains(c.id))
          .toList();

      final allChats = [...remoteChats, ...uniquePending];
      allChats.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      await _localDataSource.saveChats(remoteChats);

      return right(allChats);
    } catch (_) {
      try {
        final allLocal = await _localDataSource.getAllChats();
        final userChats =
            allLocal.where((chat) => chat.userId == userId).toList()
              ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        return right(userChats);
      } catch (_) {
        return left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteChat(String chatId) async {
    try {
      await _remoteDataSource.deleteChat(chatId);
      await _localDataSource.deleteChat(chatId);
      return right(unit);
    } on ServerException {
      return left(ServerFailure());
    } on OfflineException {
      return left(OfflineFailure());
    } on CacheException {
      return left(CacheFailure());
    }
  }

  // ─── Message ─────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(
    MessageEntity message,
  ) async {
    try {
      final model = MessageModel.fromEntity(message);
      await _localDataSource.saveMessage(model);
      return right(message.copyWith(isSynced: false));
    } on CacheException {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getCachedMessages(
    String chatId,
  ) async {
    try {
      final allLocal = await _localDataSource.getAllMessages();
      final chatMessages = allLocal
          .where((m) => m.chatId == chatId)
          .map((m) => m.asInputOnly())
          .toList();
      chatMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return right(chatMessages);
    } catch (_) {
      return left(CacheFailure());
    }
  }

  /// Merges a Firestore (remote) message with its Hive (local) counterpart.
  ///
  /// After the fix, syncPendingMessages pushes the self-contained assistant doc
  /// (label + confidence + composite ragResponse) to Firestore.  Once that sync
  /// completes, remote will have everything and this method just uses remote as-is.
  ///
  /// The reconstruction logic below handles the transition window (between RAG
  /// response and sync completing) where Firestore assistant doc still has only
  /// plain-text ragResponse with null label/confidence.
  ///
  /// Field ownership:
  ///   label / confidence (ASSISTANT) → local Hive first (Firestore may still be
  ///                                    unsynced plain doc); falls back to remote.
  ///   label / confidence (USER)      → remote Firestore is authoritative.
  ///   ragResponse  → remote if it already starts with "label:" (already synced);
  ///                  otherwise reconstruct composite from label + remote plain text;
  ///                  if remote is null (RAG pending) keep local optimistic card.
  ///   localImagePath → device-only; always from local.
  ///   timestamp      → local while !local.isSynced (ordering during in-flight send);
  ///                  remote once synced.
  MessageModel _mergeRemoteWithLocal(MessageModel remote, MessageModel? local) {
    if (local == null) {
      return remote.role == MessageRole.user ? remote.asInputOnly() : remote;
    }

    final String? mergedLabel;
    final double? mergedConfidence;
    if (remote.role == MessageRole.assistant) {
      // Firestore assistant doc may not have label/confidence yet (pre-sync).
      // Local Hive record has them (set by TFLite at classify time).
      mergedLabel = local.label ?? remote.label;
      mergedConfidence = local.confidence ?? remote.confidence;
    } else {
      // User doc: Firestore is authoritative.
      mergedLabel = remote.label ?? local.label;
      mergedConfidence = remote.confidence ?? local.confidence;
    }

    final String? mergedRagResponse;
    if (remote.ragResponse != null) {
      if (remote.ragResponse!.startsWith('label:')) {
        // Already the composite format (post-sync Firestore doc) — use as-is.
        mergedRagResponse = remote.ragResponse;
      } else if (mergedLabel != null) {
        // Transition window: remote has plain text, reconstruct composite.
        final pct = mergedConfidence != null
            ? ' (${(mergedConfidence * 100).toStringAsFixed(1)}%)'
            : '';
        mergedRagResponse =
            'label:$mergedLabel$pct\n\n---\n\n${remote.ragResponse}';
      } else {
        // Text-only message (no classification) — use remote as-is.
        mergedRagResponse = remote.ragResponse;
      }
    } else {
      // RAG has not responded yet — keep local optimistic card.
      mergedRagResponse = local.ragResponse;
    }

    final merged = MessageModel(
      id: remote.id,
      chatId: remote.chatId,
      prompt: remote.prompt,
      imageURL: remote.imageURL,
      localImagePath: local.localImagePath ?? remote.localImagePath,
      label: mergedLabel,
      confidence: mergedConfidence,
      ragResponse: mergedRagResponse,
      role: remote.role,
      timestamp: local.isSynced ? remote.timestamp : local.timestamp,
      // fromFirestoreMap always hardcodes isSynced: true.
      // Preserve local.isSynced so a pending (false) record stays
      // visible to syncPendingMessages until the Firestore write completes.
      isSynced: local.isSynced,
    );

    return merged.role == MessageRole.user ? merged.asInputOnly() : merged;
  }

  /// Edge-case fix: handles reinstall that happened in the narrow window between
  /// RAG responding and syncPendingMessages completing.  In that window, the
  /// Firestore assistant doc still has the RAG backend's partial write (plain
  /// ragResponse, null label/confidence).  We reconstruct the composite card by
  /// sourcing label/confidence from the preceding Firestore USER message, which
  /// always has them (the RAG backend does write them there).
  ///
  /// Once syncPendingMessages has run at least once, the assistant doc is
  /// self-contained and this helper becomes a no-op (label != null → early exit).
  List<MessageModel> _reconstructAssistantCards(
    List<MessageModel> messages,
    Map<String, MessageModel> remoteById,
    Map<String, MessageModel> localById,
  ) {
    if (messages.isEmpty) return messages;

    final result = List<MessageModel>.from(messages);
    String? lastUserLabel;
    double? lastUserConfidence;

    for (int i = 0; i < result.length; i++) {
      final msg = result[i];

      if (msg.role == MessageRole.user) {
        // asInputOnly() has already run on msg, so read label from raw maps.
        // Always reassign (even to null) — a text-only user message must clear
        // the label so the following assistant reply does not inherit a stale one.
        final raw = remoteById[msg.id] ?? localById[msg.id];
        lastUserLabel = raw?.label;
        lastUserConfidence = raw?.confidence;
        continue;
      }

      // Skip if reconstruction is not needed.
      if (msg.label != null) continue; // post-sync: self-contained
      if (msg.ragResponse == null) continue; // RAG still pending
      if (msg.ragResponse!.startsWith('label:')) continue; // already composite

      if (lastUserLabel == null) continue;

      final pct = lastUserConfidence != null
          ? ' (${(lastUserConfidence * 100).toStringAsFixed(1)}%)'
          : '';
      result[i] = MessageModel(
        id: msg.id,
        chatId: msg.chatId,
        prompt: msg.prompt,
        imageURL: msg.imageURL,
        localImagePath: msg.localImagePath,
        label: lastUserLabel,
        confidence: lastUserConfidence,
        ragResponse: 'label:$lastUserLabel$pct\n\n---\n\n${msg.ragResponse}',
        role: msg.role,
        timestamp: msg.timestamp,
        isSynced: msg.isSynced,
      );
    }

    return result;
  }

  Future<MessageModel> _cacheUserImageIfNeeded(MessageModel message) async {
    if (message.role != MessageRole.user) return message;
    final url = message.imageURL;
    if (url == null || url.isEmpty) return message;
    return _remoteDataSource.cacheMessageAssets(message);
  }

  Future<List<MessageModel>> _cacheUserImagesIfNeeded(
    List<MessageModel> messages,
  ) async {
    const batchSize = 4;
    final withAssets = List<MessageModel>.from(messages);

    for (var i = 0; i < messages.length; i += batchSize) {
      final end = i + batchSize > messages.length
          ? messages.length
          : i + batchSize;
      final batch = messages.sublist(i, end);
      final cached = await Future.wait(batch.map(_cacheUserImageIfNeeded));
      for (var j = 0; j < cached.length; j++) {
        withAssets[i + j] = cached[j];
      }
    }

    return withAssets;
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
    String chatId, {
    int? limit,
  }) async {
    try {
      final isOnline = await _networkInfo.isConnected;
      final source = isOnline ? Source.serverAndCache : Source.cache;

      final remoteMessages = await _remoteDataSource.getMessages(
        chatId,
        limit: limit,
        source: source,
      );

      final allLocal = await _localDataSource.getAllMessages();
      final localForChat = allLocal.where((m) => m.chatId == chatId).toList();
      final localById = {for (final m in localForChat) m.id: m};
      final remoteById = {for (final m in remoteMessages) m.id: m};

      final merged = <MessageModel>[];
      for (final id in {...localById.keys, ...remoteById.keys}) {
        final remote = remoteById[id];
        final local = localById[id];

        if (remote != null) {
          merged.add(_mergeRemoteWithLocal(remote, local));
        } else if (local != null) {
          merged.add(
            local.role == MessageRole.user ? local.asInputOnly() : local,
          );
        }
      }

      merged.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      // Reconstruct classification cards for assistant messages that lost their
      // label/confidence (e.g. hot restart — Hive cleared, Firestore assistant
      // doc has plain-text ragResponse only).
      final withCards = _reconstructAssistantCards(
        merged,
        remoteById,
        localById,
      );

      final toSave = isOnline
          ? await _cacheUserImagesIfNeeded(withCards)
          : withCards;
      await _localDataSource.saveMessages(toSave);

      return right(toSave);
    } catch (_) {
      try {
        final allLocal = await _localDataSource.getAllMessages();
        final chatLocal =
            allLocal
                .where((m) => m.chatId == chatId)
                .map((m) => m.asInputOnly())
                .toList()
              ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
        return right(chatLocal);
      } catch (_) {
        return left(CacheFailure());
      }
    }
  }

  // ─── Sync (offline → Firestore, outside RAG) ─────────────────────────────
  //
  // Offline-first: Hive holds truth while offline. On reconnect, push pending
  // chats/messages directly to Firestore with client timestamps.
  // RAG is NOT called here — it only persists when sendToRag runs online.
  //
  // Classification reload after sync:
  // After messages are uploaded (Hive → Firestore), the next call to
  // getMessages() fetches from Firestore and runs _mergeRemoteWithLocal,
  // which enforces remote-wins for label/confidence/ragResponse.
  // This means Hive classification is NEVER merged back into Firestore results.

  @override
  Future<Either<Failure, Unit>> syncPendingMessages() async {
    try {
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) return left(OfflineFailure());

      final pendingChats = await _localDataSource.getPendingChats();
      for (final chat in pendingChats) {
        try {
          await _remoteDataSource.createChat(chat);
          final syncedChat = ChatModel.fromEntity(
            ChatEntity(
              id: chat.id,
              userId: chat.userId,
              title: chat.title,
              createdAt: chat.createdAt,
              updatedAt: chat.updatedAt,
              isSynced: true,
            ),
          );
          await _localDataSource.saveChat(syncedChat);
        } on ServerException {
          continue;
        } on OfflineException {
          break;
        }
      }

      final pendingMessages = await _localDataSource.getAllPendingMessages();

      for (final message in pendingMessages) {
        try {
          String? imageURL;

          if (message.localImagePath != null && message.imageURL == null) {
            final file = File(message.localImagePath!);
            if (await file.exists()) {
              imageURL = await _cloudinaryDataSource.uploadImage(file);
            }
          }

          final messageToSync = imageURL != null
              ? MessageModel.fromEntity(message.copyWith(imageURL: imageURL))
              : message;

          await _remoteDataSource.sendMessage(messageToSync);

          final syncedMessage = MessageModel.fromEntity(
            messageToSync.copyWith(isSynced: true),
          );
          await _localDataSource.saveMessage(syncedMessage);
        } on ServerException {
          continue;
        } on OfflineException {
          break;
        }
      }
      return right(unit);
    } on OfflineException {
      return left(OfflineFailure());
    } catch (_) {
      return left(ServerFailure());
    }
  }

  // ─── Auto Report ──────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Unit>> saveReport(AutoReportEntity report) async {
    try {
      final model = AutoReportModel.fromEntity(report);
      await _reportLocalDataSource.saveReport(model);

      final isOnline = await _networkInfo.isConnected;
      if (isOnline) {
        try {
          var modelToSync = model;

          // ── Resolve governorate if missing (e.g. was offline) ──────
          if (modelToSync.governorate == null) {
            final g = await _locationService.getGovernorate(
              modelToSync.latitude,
              modelToSync.longitude,
            );
            if (g != null) modelToSync = modelToSync.copyWith(governorate: g);
          }

          if (modelToSync.imageURL.isEmpty && modelToSync.imagePath != null) {
            final file = File(modelToSync.imagePath!);
            if (await file.exists()) {
              final uploadedURL = await _cloudinaryDataSource.uploadImage(file);
              modelToSync = modelToSync.copyWith(imageURL: uploadedURL);
            }
          }
          await _reportRemoteDataSource
              .saveReport(modelToSync)
              .timeout(const Duration(seconds: 8));

          final syncedModel = modelToSync.copyWith(isSynced: true);
          await _reportLocalDataSource.saveReport(syncedModel);
        } on ServerException {
          // Stays in Hive for retry
        } on OfflineException {
          // Stays in Hive for retry
        } on TimeoutException {
          // Stays in Hive for retry
        }
      }

      return right(unit);
    } catch (_) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> syncPendingReports() async {
    try {
      // Guard: do nothing if offline — ConnectivityCubit will call us again on reconnect.
      final isOnline = await _networkInfo.isConnected;
      if (!isOnline) return right(unit);

      final pending = await _reportLocalDataSource.getPendingReports();

      for (final report in pending) {
        try {
          var reportToSync = report;

          // ── Resolve governorate if missing (e.g. was offline) ──────
          if (reportToSync.governorate == null) {
            final g = await _locationService.getGovernorate(
              reportToSync.latitude,
              reportToSync.longitude,
            );
            if (g != null) reportToSync = reportToSync.copyWith(governorate: g);
          }

          if (reportToSync.imageURL.isEmpty && reportToSync.imagePath != null) {
            try {
              final file = File(reportToSync.imagePath!);
              if (await file.exists()) {
                final uploadedURL = await _cloudinaryDataSource.uploadImage(
                  file,
                );
                reportToSync = reportToSync.copyWith(imageURL: uploadedURL);
              }
            } catch (_) {
              // Image upload failed (timeout, network, etc.) - skip this report
              // It will retry on next sync when reconnected
              continue;
            }
          }

          if (reportToSync.imageURL.isEmpty) continue;

          await _reportRemoteDataSource.saveReport(reportToSync);

          final syncedReport = reportToSync.copyWith(isSynced: true);
          await _reportLocalDataSource.saveReport(syncedReport);
        } on ServerException {
          continue;
        } on OfflineException {
          continue;
        } catch (_) {
          // Any other error for this report - skip and continue with next
          continue;
        }
      }
      return right(unit);
    } catch (_) {
      return left(ServerFailure());
    }
  }

  // ─── Classification ───────────────────────────────────────────────────────

  @override
  Future<Either<Failure, (String, double)>> classifyImage(File image) async {
    try {
      final results = await _tfliteDataSource.classify(image);
      return right((
        results.first['label'] as String,
        results.first['confidence'] as double,
      ));
    } on ModelException {
      return left(ModelFailure());
    } catch (_) {
      return left(ModelFailure());
    }
  }

  // ─── Storage ──────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, String>> uploadImage(File image) async {
    try {
      final url = await _cloudinaryDataSource.uploadImage(image);
      return right(url);
    } on ServerException {
      return left(ServerFailure());
    } on OfflineException {
      return left(OfflineFailure());
    }
  }

  // ─── RAG ──────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, String>> sendToRag({
    String? prompt,
    String? label,
    double? confidence,
    String? imageUrl,
    required String messageId,
    required String assistantMessageId,
    required String chatId,
    String? chatTitle,
  }) async {
    try {
      final response = await _ragDataSource
          .sendMessage(
            prompt: prompt,
            label: label,
            confidence: confidence,
            imageUrl: imageUrl,
            messageId: messageId,
            chatId: chatId,
            assistantMessageId: assistantMessageId,
          )
          .timeout(
            const Duration(seconds: 90),
            onTimeout: () => throw ServerException(),
          );
      return right(response);
    } on SessionNotFoundException {
      try {
        // Self-healing: Register the missing session on the fly
        await _ragDataSource.startChat(
          chatId: chatId,
          title: chatTitle ?? 'Diagnosis',
        );
        // Immediate retry
        final retryResponse = await _ragDataSource
            .sendMessage(
              prompt: prompt,
              label: label,
              confidence: confidence,
              imageUrl: imageUrl,
              messageId: messageId,
              chatId: chatId,
              assistantMessageId: assistantMessageId,
            )
            .timeout(
              const Duration(seconds: 90),
              onTimeout: () => throw ServerException(),
            );
        return right(retryResponse);
      } catch (_) {
        return left(ServerFailure());
      }
    } on ServerException {
      return left(ServerFailure());
    } on OfflineException {
      return left(OfflineFailure());
    } catch (_) {
      return left(ServerFailure());
    }
  }
}
