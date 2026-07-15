import 'dart:core';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helpers/error_message_key.dart';
import '../../../../../core/helpers/failure_x.dart';
import '../../../../../core/helpers/uuid_generator.dart';
import '../../../../../core/services/location/location_service.dart';
import '../../../../../core/services/storage/local_image_storage_service.dart';
import '../../../../network_system/domain/repositories/network_info.dart';
import '../../../domain/entities/auto_report_entity.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/usecases/classify_image_usecase.dart';
import '../../../domain/usecases/create_chat_usecase.dart';
import '../../../domain/usecases/delete_chat_usecase.dart';
import '../../../domain/usecases/get_cached_chats_usecase.dart';
import '../../../domain/usecases/get_cached_messages_usecase.dart';
import '../../../domain/usecases/get_chats_usecase.dart';
import '../../../domain/usecases/get_messages_usecase.dart';
import '../../../domain/usecases/preload_chat_data_usecase.dart';
import '../../../domain/usecases/save_report_usecase.dart';
import '../../../domain/usecases/send_message_usecase.dart';
import '../../../domain/usecases/send_to_rag_usecase.dart';
import '../../../domain/usecases/sync_pending_reports_usecase.dart';
import '../../../domain/usecases/upload_image_usecase.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final CreateChatUsecase _createChatUsecase;
  final GetChatsUsecase _getChatsUsecase;
  final PreloadChatDataUsecase _preloadChatDataUsecase;
  final GetCachedChatsUsecase _getCachedChatsUsecase;
  final GetCachedMessagesUsecase _getCachedMessagesUsecase;
  final DeleteChatUsecase _deleteChatUsecase;
  final SendMessageUsecase _sendMessageUsecase;
  final GetMessagesUsecase _getMessagesUsecase;
  final ClassifyImageUsecase _classifyImageUsecase;
  final UploadImageUsecase _uploadImageUsecase;
  final SendToRagUsecase _sendToRagUsecase;
  final SaveReportUsecase _saveReportUsecase;
  final SyncPendingReportsUsecase _syncPendingReportsUsecase;
  final NetworkInfo _networkInfo;
  final LocalImageStorageService _localImageStorageService;
  final LocationService _locationService;

  String? _activeChatId;

  ChatCubit({
    required CreateChatUsecase createChatUsecase,
    required GetChatsUsecase getChatsUsecase,
    required PreloadChatDataUsecase preloadChatDataUsecase,
    required GetCachedChatsUsecase getCachedChatsUsecase,
    required GetCachedMessagesUsecase getCachedMessagesUsecase,
    required DeleteChatUsecase deleteChatUsecase,
    required SendMessageUsecase sendMessageUsecase,
    required GetMessagesUsecase getMessagesUsecase,
    required ClassifyImageUsecase classifyImageUsecase,
    required UploadImageUsecase uploadImageUsecase,
    required SendToRagUsecase sendToRagUsecase,
    required SaveReportUsecase saveReportUsecase,
    required SyncPendingReportsUsecase syncPendingReportsUsecase,
    required NetworkInfo networkInfo,
    required LocalImageStorageService localImageStorageService,
    required LocationService locationService,
  }) : _createChatUsecase = createChatUsecase,
       _getChatsUsecase = getChatsUsecase,
       _preloadChatDataUsecase = preloadChatDataUsecase,
       _getCachedChatsUsecase = getCachedChatsUsecase,
       _getCachedMessagesUsecase = getCachedMessagesUsecase,
       _deleteChatUsecase = deleteChatUsecase,
       _sendMessageUsecase = sendMessageUsecase,
       _getMessagesUsecase = getMessagesUsecase,
       _classifyImageUsecase = classifyImageUsecase,
       _uploadImageUsecase = uploadImageUsecase,
       _sendToRagUsecase = sendToRagUsecase,
       _saveReportUsecase = saveReportUsecase,
       _syncPendingReportsUsecase = syncPendingReportsUsecase,
       _networkInfo = networkInfo,
       _localImageStorageService = localImageStorageService,
       _locationService = locationService,
       super(ChatInitial());

  List<MessageEntity>? _currentMessagesOrNull() {
    final s = state;
    if (s is MessagesLoaded) return s.messages;
    if (s is MessagesUpdated) return s.messages;
    return null;
  }

  // ─── Chats ────────────────────────────────────────────────────────────────

  Future<void> getChats(String userId, {int retryCount = 0}) async {
    final cacheResult = await _getCachedChatsUsecase(userId);
    final cachedChats = cacheResult.fold((_) => <ChatEntity>[], (c) => c);
    final isFirstLoad = cachedChats.isEmpty;

    if (cachedChats.isNotEmpty) {
      emit(ChatsLoaded(chats: cachedChats, isFromCache: true));
    } else if (retryCount == 0) {
      emit(const ChatLoading(ChatAction.loadingChats, isFirstTime: true));
    }

    if (isFirstLoad) {
      await _preloadChatDataUsecase(userId);
      if (isClosed) return;
    }

    final result = await _getChatsUsecase(userId);
    if (isClosed) return;

    await result.fold(
      (failure) async {
        if (retryCount < 2) {
          await Future.delayed(Duration(seconds: retryCount + 1));
          return getChats(userId, retryCount: retryCount + 1);
        }
        if (state is! ChatsLoaded) emit(ChatError(failure.toKey()));
      },
      (chats) async {
        final currentState = state;
        if (currentState is ChatsLoaded &&
            currentState.chats.length == chats.length &&
            !currentState.isRefreshing &&
            !currentState.isFromCache) {
          return;
        }
        emit(ChatsLoaded(chats: chats, isFromCache: false));
      },
    );
  }

  Future<void> deleteChat({
    required String chatId,
    required String userId,
  }) async {
    if (isClosed) return;
    final canProceed = await _networkInfo.isConnected;
    if (!canProceed) {
      if (!isClosed) emit(ChatError(ErrorMessageKey.offlineDelete));
      return;
    }
    final currentState = state;
    if (currentState is ChatsLoaded) {
      emit(
        ChatsLoaded(
          chats: currentState.chats,
          isFromCache: currentState.isFromCache,
          isRefreshing: currentState.isRefreshing,
          deletingChatId: chatId,
        ),
      );
    }
    final result = await _deleteChatUsecase(chatId);
    if (isClosed) return;
    result.fold((failure) {
      final loaded = state;
      if (loaded is ChatsLoaded) {
        emit(
          ChatsLoaded(
            chats: loaded.chats,
            isFromCache: loaded.isFromCache,
            isRefreshing: loaded.isRefreshing,
          ),
        );
      }
      emit(ChatError(failure.toKey()));
    }, (_) => getChats(userId));
  }

  void resetChat() {
    if (isClosed) return;
    _activeChatId = null;
    final currentState = state;
    if (currentState is ChatsLoaded) {
      emit(
        ChatsLoaded(
          chats: currentState.chats,
          isRefreshing: false,
          isFromCache: currentState.isFromCache,
        ),
      );
    } else {
      emit(ChatInitial());
    }
  }

  // ─── Messages ─────────────────────────────────────────────────────────────

  Future<void> _fetchMessages(String chatId, {int retryCount = 0}) async {
    if (isClosed || _activeChatId != chatId) return;
    final result = await _getMessagesUsecase(chatId);
    if (isClosed || _activeChatId != chatId) return;
    result.fold(
      (failure) async {
        if (retryCount < 2) {
          await Future.delayed(Duration(seconds: retryCount + 1));
          return _fetchMessages(chatId, retryCount: retryCount + 1);
        }
        // Silent failure — cached messages (if any) remain visible.
      },
      (messages) {
        // Guard: never replace visible messages with an empty list.
        // The Firestore SDK cache can return a stale empty result for a new chat
        // (the early _fetchMessages call runs before RAG writes to Firestore,
        // caching an empty snapshot; going offline later replays that empty cache).
        if (messages.isEmpty && _currentMessagesOrNull()?.isNotEmpty == true) {
          return;
        }
        emit(MessagesLoaded(messages));
      },
    );
  }

  Future<void> getMessages(String chatId) async {
    _activeChatId = chatId;
    final cacheResult = await _getCachedMessagesUsecase(chatId);
    final cachedMessages = cacheResult.fold(
      (_) => <MessageEntity>[],
      (messages) => messages,
    );

    if (_activeChatId != chatId) return;

    if (cachedMessages.isNotEmpty) {
      emit(MessagesLoaded(cachedMessages));
    } else {
      emit(const ChatLoading(ChatAction.loadingMessages));
    }

    await _fetchMessages(chatId);
  }

  // ─── Send ──────────────────────────────────────────────────────────────────

  Future<bool> sendMessage({
    required String activeChatId,
    required bool isNewChat,
    required String messageId,
    required String userId,
    String? prompt,
    File? image,
    double? latitude,
    double? longitude,
  }) async {
    String? localImagePath;
    String? label;
    double? confidence;

    final hasImage = image != null;
    final hasPrompt = prompt != null && prompt.trim().isNotEmpty;
    final isOnline = await _networkInfo.isConnected;

    _activeChatId = activeChatId;

    // ── Step 1: Classify ─────────────────────────────────────────────────────
    if (hasImage) {
      final classifyResult = await _classifyImageUsecase(image);
      final failed = classifyResult.fold((failure) => true, (result) {
        label = result.$1;
        confidence = result.$2;
        return false;
      });
      if (failed) return false;

      try {
        localImagePath = await _localImageStorageService.persistChatImage(
          image,
          messageId: messageId,
        );
      } catch (_) {
        localImagePath = image.path;
      }
    }

    // ── Step 2: Create chat (RAG session + Hive) before messaging ───────────
    String? chatTitle;
    if (isNewChat) {
      chatTitle = hasPrompt
          ? prompt.split(' ').take(5).join(' ')
          : label ?? 'Plant Diagnosis';
      final chat = ChatEntity(
        id: activeChatId,
        userId: userId,
        title: chatTitle,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: false,
      );
      await _createChatUsecase(chat);
    }

    // ── Step 3: Save user message to Hive ────────────────────────────────────
    final userTimestamp = DateTime.now();
    final userMessage = MessageEntity(
      id: messageId,
      chatId: activeChatId,
      prompt: hasPrompt ? prompt : null,
      imageURL: null,
      localImagePath: localImagePath,
      label: label,
      confidence: confidence,
      ragResponse: null,
      role: MessageRole.user,
      timestamp: userTimestamp,
      isSynced: false,
    );

    final userResult = await _sendMessageUsecase(userMessage);
    if (userResult.isLeft()) {
      return false;
    }

    // ── Step 4: Show classification card immediately ──────────────────────────
    // TFLite result is OPTIMISTIC UI only — it is intentionally temporary.
    // The repository's remote-first merge will overwrite label/confidence/ragResponse
    // once Firestore/RAG responds. The UI updates naturally via _finishBackground
    // → getMessages → merge. Do NOT treat local classification as permanent.
    //
    // Generate assistantMessageId here — same UUID will be passed to RAG
    // so RAG stores the assistant response under this exact Firestore document ID.
    // This means local card ID == Firestore document ID — no mismatch ever.
    String? immediateAssistantId;
    final assistantTimestamp = userTimestamp.add(
      const Duration(milliseconds: 100),
    );

    if (hasImage && label != null) {
      immediateAssistantId = UuidGenerator.generate();
      final confidencePct = confidence != null
          ? ' (${(confidence! * 100).toStringAsFixed(1)}%)'
          : '';
      final immediateAssistant = MessageEntity(
        id: immediateAssistantId,
        chatId: activeChatId,
        prompt: null,
        imageURL: null,
        localImagePath: null,
        label: label,
        confidence: confidence,
        ragResponse: 'label:$label$confidencePct',
        role: MessageRole.assistant,
        timestamp: assistantTimestamp,
        isSynced: false,
      );
      await _sendMessageUsecase(immediateAssistant);
    }

    // ── Step 5: Show user message + classification card in UI ────────────────
    await _fetchMessages(activeChatId);

    // ── Step 6: Background — upload + RAG ───────────────────────────────────
    final needsRag = hasPrompt || label != null;
    final shouldRunRagBackground =
        needsRag && (isOnline || (hasPrompt && !hasImage));

    if (shouldRunRagBackground) {
      _runBackgroundTasks(
        activeChatId: activeChatId,
        userId: userId,
        messageId: messageId,
        chatTitle: chatTitle,
        immediateAssistantId: immediateAssistantId,
        prompt: hasPrompt ? prompt : null,
        image: image,
        label: label,
        confidence: confidence,
        localImagePath: localImagePath,
        latitude: latitude,
        longitude: longitude,
        userTimestamp: userTimestamp,
        assistantTimestamp: assistantTimestamp,
      );
    } else {
      await _finishBackground(activeChatId, messageId);
    }

    // ── Auto report ───────────────────────────────────────────────────────────
    // Deliberately outside the shouldRunRagBackground gate.
    // When offline + image only, shouldRunRagBackground is false so
    // _runBackgroundTasks never runs — without this block the report would
    // never be written to Hive and there would be nothing to sync on reconnect.
    // imageURL is always '' here; syncPendingReports uploads it on reconnect.
    // Wrapped in Future() so it never blocks the return value or the UI.
    if (hasImage && label != null && latitude != null && longitude != null) {
      Future(() async {
        try {
          await _saveAutoReport(
            userId: userId,
            label: label!,
            confidence: confidence,
            image: image,
            localImagePath: localImagePath,
            latitude: latitude,
            longitude: longitude,
          );
        } catch (_) {
          // Silent — report stays unsynced; ConnectivityCubit retries on reconnect.
        }
      });
    }

    return true;
  }

  // ─── Background ───────────────────────────────────────────────────────────

  void _runBackgroundTasks({
    required String activeChatId,
    required String userId,
    required String messageId,
    required String? chatTitle,
    required String? immediateAssistantId,
    required String? prompt,
    required File? image,
    required String? label,
    required double? confidence,
    required String? localImagePath,
    required double? latitude,
    required double? longitude,
    required DateTime userTimestamp,
    required DateTime assistantTimestamp,
  }) {
    Future(() async {
      try {
        await _doBackgroundWork(
          activeChatId: activeChatId,
          userId: userId,
          messageId: messageId,
          chatTitle: chatTitle,
          immediateAssistantId: immediateAssistantId,
          prompt: prompt,
          image: image,
          label: label,
          confidence: confidence,
          localImagePath: localImagePath,
          latitude: latitude,
          longitude: longitude,
          userTimestamp: userTimestamp,
          assistantTimestamp: assistantTimestamp,
        ).timeout(const Duration(seconds: 90));
      } catch (_) {
        await _finishBackground(activeChatId, messageId);
      }
    });
  }

  Future<void> _doBackgroundWork({
    required String activeChatId,
    required String userId,
    required String messageId,
    required String? chatTitle,
    required String? immediateAssistantId,
    required String? prompt,
    required File? image,
    required String? label,
    required double? confidence,
    required String? localImagePath,
    required double? latitude,
    required double? longitude,
    required DateTime userTimestamp,
    required DateTime assistantTimestamp,
  }) async {
    String? imageURL;
    String? ragResponse;

    final hasImage = image != null;
    final hasPrompt = prompt != null && prompt.trim().isNotEmpty;

    // ── Upload image ──────────────────────────────────────────────────────────
    if (hasImage) {
      final uploadResult = await _uploadImageUsecase(image);
      uploadResult.fold((_) => null, (url) => imageURL = url);

      if (imageURL != null) {
        await _sendMessageUsecase(
          MessageEntity(
            id: messageId,
            chatId: activeChatId,
            prompt: prompt,
            imageURL: imageURL,
            localImagePath: localImagePath,
            label: label,
            confidence: confidence,
            ragResponse: null,
            role: MessageRole.user,
            timestamp: userTimestamp,
            isSynced: false,
          ),
        );
      }
    }

    // ── Call RAG ──────────────────────────────────────────────────────────────
    // Pass assistantMessageId so RAG stores the assistant response under
    // this exact Firestore document ID — matching the local card UUID.
    // For text-only (no immediateAssistantId), generate one now so the
    // assistant Firestore document ID is also known in advance.
    final assistantMessageId = immediateAssistantId ?? UuidGenerator.generate();

    if (hasPrompt || label != null) {
      final ragResult = await _sendToRagUsecase(
        prompt: hasPrompt ? prompt : null,
        label: label,
        confidence: confidence,
        imageUrl: imageURL,
        messageId: messageId,
        assistantMessageId: assistantMessageId,
        chatId: activeChatId,
        chatTitle: chatTitle,
      );
      ragResult.fold((failure) {
        final key = failure.toKey();
        ragResponse = (key == ErrorMessageKey.offline)
            ? ErrorMessageKey.offlinePrompt.name
            : ErrorMessageKey.server.name;
      }, (response) => ragResponse = response);
    }

    // ── Handle RAG response ───────────────────────────────────────────────────
    if (ragResponse != null) {
      final isRagError =
          ragResponse == ErrorMessageKey.offlinePrompt.name ||
          ragResponse == ErrorMessageKey.server.name;

      if (immediateAssistantId != null) {
        // Classification path — expand the card with RAG response
        final confidencePct = confidence != null
            ? ' (${(confidence * 100).toStringAsFixed(1)}%)'
            : '';
        if (!isRagError) {
          await _sendMessageUsecase(
            MessageEntity(
              id: immediateAssistantId,
              chatId: activeChatId,
              prompt: null,
              imageURL: null,
              localImagePath: null,
              label: label,
              confidence: confidence,
              // Composite format: "label:X (Y%)\n\n---\n\nAnswer"
              // Stored here so Firestore becomes fully self-contained.
              ragResponse: 'label:$label$confidencePct\n\n---\n\n$ragResponse',
              role: MessageRole.assistant,
              timestamp: assistantTimestamp,
              // false → syncPendingMessages will overwrite the Firestore assistant
              // doc with the complete record (label + confidence + composite ragResponse).
              // After sync, reinstall/cache-clear can rebuild the card from Firestore alone.
              isSynced: false,
            ),
          );
          // User message persisted by RAG — do not re-push via syncPendingMessages
          await _sendMessageUsecase(
            MessageEntity(
              id: messageId,
              chatId: activeChatId,
              prompt: hasPrompt ? prompt : null,
              imageURL: imageURL,
              localImagePath: localImagePath,
              label: label,
              confidence: confidence,
              ragResponse: null,
              role: MessageRole.user,
              timestamp: userTimestamp,
              isSynced: true,
            ),
          );
        } else {
          await _sendMessageUsecase(
            MessageEntity(
              id: immediateAssistantId,
              chatId: activeChatId,
              prompt: null,
              imageURL: null,
              localImagePath: null,
              label: label,
              confidence: confidence,
              ragResponse: 'label:$label$confidencePct\n\n---\n\n$ragResponse',
              role: MessageRole.assistant,
              timestamp: assistantTimestamp,
              isSynced: false,
            ),
          );
        }
        await _finishBackground(activeChatId, messageId);
      } else {
        // Text-only path — RAG stores the assistant under assistantMessageId.
        if (!isRagError) {
          await _sendMessageUsecase(
            MessageEntity(
              id: assistantMessageId,
              chatId: activeChatId,
              prompt: null,
              imageURL: null,
              localImagePath: null,
              label: null,
              confidence: null,
              ragResponse: ragResponse,
              role: MessageRole.assistant,
              timestamp: DateTime.now(),
              isSynced: true,
            ),
          );

          final existing = _currentMessagesOrNull();
          if (existing != null &&
              !existing.any((m) => m.id == assistantMessageId)) {
            emit(
              MessagesUpdated([
                ...existing,
                MessageEntity(
                  id: assistantMessageId,
                  chatId: activeChatId,
                  prompt: null,
                  imageURL: null,
                  localImagePath: null,
                  label: null,
                  confidence: null,
                  ragResponse: ragResponse,
                  role: MessageRole.assistant,
                  timestamp: DateTime.now(),
                  isSynced: true,
                ),
              ], messageId),
            );
          }

          await _sendMessageUsecase(
            MessageEntity(
              id: messageId,
              chatId: activeChatId,
              prompt: hasPrompt ? prompt : null,
              imageURL: imageURL,
              localImagePath: localImagePath,
              label: label,
              confidence: confidence,
              ragResponse: null,
              role: MessageRole.user,
              timestamp: userTimestamp,
              isSynced: true,
            ),
          );
        } else {
          await _sendMessageUsecase(
            MessageEntity(
              id: assistantMessageId,
              chatId: activeChatId,
              prompt: null,
              imageURL: null,
              localImagePath: null,
              label: null,
              confidence: null,
              ragResponse: ragResponse,
              role: MessageRole.assistant,
              timestamp: DateTime.now(),
              isSynced: false,
            ),
          );
        }

        await _finishBackground(activeChatId, messageId);
      }
    } else {
      await _finishBackground(activeChatId, messageId);
    }
  }

  // ─── Auto report helper ───────────────────────────────────────────────────

  Future<void> _saveAutoReport({
    required String userId,
    required String label,
    required double? confidence,
    required File image,
    required String? localImagePath,
    required double latitude,
    required double longitude,
  }) async {
    String? governorate;
    try {
      governorate = await _locationService.getGovernorate(latitude, longitude);
    } catch (_) {}

    await _saveReportUsecase(
      AutoReportEntity(
        id: UuidGenerator.generate(),
        userId: userId,
        label: label,
        confidence: confidence ?? 0.0,
        imageURL: '',
        imagePath: localImagePath ?? image.path,
        latitude: latitude,
        longitude: longitude,
        governorate: governorate,
        timestamp: DateTime.now(),
        isSynced: false,
      ),
    );
    await _syncPendingReportsUsecase();
  }

  // ─── Finish ───────────────────────────────────────────────────────────────

  Future<void> _finishBackground(
    String chatId,
    String completedMessageId,
  ) async {
    // Step 1: Emit from Hive immediately.
    // By this point _doBackgroundWork has already saved the full composite
    // ragResponse to Hive via _sendMessageUsecase, so the cache is current.
    // No network round-trip needed — the typing indicator disappears and the
    // full response renders as soon as the RAG HTTP response arrives.
    final cacheResult = await _getCachedMessagesUsecase(chatId);
    if (isClosed || _activeChatId != chatId) return;

    cacheResult.fold(
      (_) => _emitCurrentWithCompleted(completedMessageId),
      (messages) => emit(MessagesUpdated(messages, completedMessageId)),
    );

    // Step 2: Reconcile with Firestore silently in the background.
    // Picks up imageURLs, server-side field updates, and re-caches images
    // without blocking the UI. Uses the same Future(() async {}) pattern
    // already established in _runBackgroundTasks.
    Future(() async {
      await _reconcileWithServer(chatId, completedMessageId);
    });
  }

  // Fetches the latest state from Firestore + Hive merge and re-emits only
  // if something actually changed. This prevents a pointless rebuild when
  // Hive and Firestore are already in sync (the common case).
  Future<void> _reconcileWithServer(
    String chatId,
    String completedMessageId,
  ) async {
    if (isClosed || _activeChatId != chatId) return;

    final result = await _getMessagesUsecase(chatId);
    if (isClosed || _activeChatId != chatId) return;

    result.fold((_) => null, (messages) {
      final current = _currentMessagesOrNull();
      if (current == null) return;

      // Check for new messages (count mismatch).
      final hasNewMessages = messages.length != current.length;

      // Check for updated fields on existing messages.
      // We care about imageURL (Cloudinary URL resolved after upload),
      // localImagePath (downloaded asset), and ragResponse (edge case:
      // server wrote a different composite than the local reconstruction).
      final hasUpdatedFields =
          !hasNewMessages &&
          messages.any((remote) {
            final local = current.firstWhere(
              (m) => m.id == remote.id,
              orElse: () => remote,
            );
            return remote.imageURL != local.imageURL ||
                remote.localImagePath != local.localImagePath ||
                remote.ragResponse != local.ragResponse;
          });

      // Guard: never replace visible messages with an empty list.
      // Same root cause as the _fetchMessages guard above.
      if (messages.isEmpty) return;

      if (hasNewMessages || hasUpdatedFields) {
        emit(MessagesUpdated(messages, completedMessageId));
      }
    });
  }

  // Emits MessagesUpdated from the current in-memory message list.
  // Used as a fallback when the Hive read fails — the existing visible
  // messages are preserved and the typing indicator still clears.
  void _emitCurrentWithCompleted(String completedMessageId) {
    final current = _currentMessagesOrNull();
    if (current == null) return;
    emit(MessagesUpdated(current, completedMessageId));
  }
}
