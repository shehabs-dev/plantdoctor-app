import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../config/localization/generated/l10n.dart';
import '../../../../../core/helpers/uuid_generator.dart';
import '../../../../../core/services/location/location_helper.dart';
import 'coming_soon_dialog.dart';
import '../../../../auth/presentation/cubit/auth/auth_cubit.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../data/models/message_model.dart';
import '../../cubit/chat/chat_cubit.dart';
import 'assistant_message_bubble.dart';
import 'attachment_picker_sheet.dart';
import 'chat_empty_state.dart';
import 'image_preview_widget.dart';
import 'inline_chat_input.dart';
import 'typing_indicator.dart';
import 'user_message_bubble.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    super.key,
    this.chatId,
    this.chatTitle,
    required this.locationHelper,
  });

  final String? chatId;
  final String? chatTitle;
  final LocationHelper locationHelper;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final Map<String, File> _localImages = {};
  final Set<String> _sendingIds = {};
  final List<MessageEntity> _pendingMessages = [];

  String? _currentChatId;
  List<MessageEntity> _messages = [];

  File? _selectedImage;
  double? _selectedImageLat;
  double? _selectedImageLng;

  bool _showScrollToBottomFab = false;

  bool _didInitialScroll = false;
  bool _hasLoadedInitialMessages = false;

  bool get _isSending => _sendingIds.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _currentChatId = widget.chatId;
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChatView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.chatId != widget.chatId) {
      _didInitialScroll = false;
      _hasLoadedInitialMessages = false;
    }
  }

  // ─── Scroll helpers ───────────────────────────────────────────────────────

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final distanceFromBottom =
        _scrollController.position.maxScrollExtent - _scrollController.offset;

    final isNearBottom = distanceFromBottom <= 120;
    final shouldShow = !isNearBottom;
    if (shouldShow != _showScrollToBottomFab) {
      setState(() => _showScrollToBottomFab = shouldShow);
    }
  }

  // Taps the FAB → jumps to bottom with no animation so there is no
  // "scrolls twice" effect.  We poll maxScrollExtent for up to ~300 ms
  // until it stops growing (covers late-decoding images and table layout
  // passes), then fire a single jumpTo.
  Future<void> _glideToBottom() async {
    if (!_scrollController.hasClients) return;

    double lastExtent = -1;
    int stableCount = 0;

    for (int i = 0; i < 10; i++) {
      if (!mounted || !_scrollController.hasClients) return;

      final current = _scrollController.position.maxScrollExtent;

      if (current == lastExtent) {
        stableCount++;
        // Two consecutive identical readings → extent has settled
        if (stableCount >= 2) break;
      } else {
        stableCount = 0;
        lastExtent = current;
      }

      await Future.delayed(const Duration(milliseconds: 32));
    }

    if (!mounted || !_scrollController.hasClients) return;

    final max = _scrollController.position.maxScrollExtent;
    _scrollController.jumpTo(max.clamp(0.0, max));
  }

  void _animateToBottom() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final target = max.clamp(0.0, max);
    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
    );
  }

  Future<void> _scheduleInitialScroll() async {
    if (_didInitialScroll) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted || !_scrollController.hasClients) return;

      // Safely access position
      final pos = _scrollController.position;
      if (!pos.hasContentDimensions) return;
      _scrollController.jumpTo(pos.maxScrollExtent);

      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted || !_scrollController.hasClients) return;

      final pos2 = _scrollController.position;
      if (!pos2.hasContentDimensions) return;
      _scrollController.jumpTo(pos2.maxScrollExtent);

      _didInitialScroll = true;
    });
  }

  void _scheduleAnimateToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _animateToBottom();
    });
  }

  // ─── Attachment ───────────────────────────────────────────────────────────

  Future<void> _handleAttachment() async {
    final locationHelper = widget.locationHelper;
    final hasAccess = await locationHelper.hasLocationAccess();

    if (!hasAccess) {
      // No permission yet — must await before proceeding so the user
      // sees the permission dialog before the image picker.
      if (!mounted) return;
      final position = await locationHelper.getLocationWithPermission(context);
      if (position == null) return;
      if (!mounted) return;
      setState(() {
        _selectedImageLat = position.latitude;
        _selectedImageLng = position.longitude;
      });
    } else {
      // Permission already granted — fire in background so the picker
      // opens immediately. _handleSend will wait up to 8 s if needed.
      if (!mounted) return;
      locationHelper.getLocationWithPermission(context).then((position) {
        if (mounted && position != null) {
          setState(() {
            _selectedImageLat = position.latitude;
            _selectedImageLng = position.longitude;
          });
        }
      });
    }

    if (!mounted) return;

    AttachmentPickerSheet.show(
      cameraLabel: S.of(context).takePhoto,
      galleryLabel: S.of(context).chooseFromGallery,
      context,
      onSelected: (source) async {
        final picker = ImagePicker();
        XFile? picked;
        if (source == AttachmentSource.camera) {
          picked = await picker.pickImage(source: ImageSource.camera);
        } else if (source == AttachmentSource.gallery) {
          picked = await picker.pickImage(source: ImageSource.gallery);
        }
        if (picked == null) return;
        if (!mounted) return;
        setState(() => _selectedImage = File(picked!.path));
      },
    );
  }

  // ─── Send ─────────────────────────────────────────────────────────────────

  Future<void> _handleSend() async {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty && _selectedImage == null) return;

    final image = _selectedImage;
    final lat = _selectedImageLat;
    final lng = _selectedImageLng;
    final authState = context.read<AuthCubit>().state;
    final userId = authState is Authenticated ? authState.user.id ?? '' : '';

    final isNewChat = _currentChatId == null;
    final activeChatId = _currentChatId ?? UuidGenerator.generate();
    final messageId = UuidGenerator.generate();

    if (image != null) _localImages[messageId] = image;

    final pendingMessage = MessageEntity(
      id: messageId,
      chatId: activeChatId,
      prompt: prompt.isEmpty ? null : prompt,
      imageURL: null,
      label: null,
      confidence: null,
      ragResponse: null,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    setState(() {
      _sendingIds.add(messageId);
      _pendingMessages.add(pendingMessage);
      _selectedImage = null;
      _selectedImageLat = null;
      _selectedImageLng = null;
      _controller.clear();
    });

    _scheduleAnimateToBottom();

    final success = await context.read<ChatCubit>().sendMessage(
      activeChatId: activeChatId,
      isNewChat: isNewChat,
      messageId: messageId,
      userId: userId,
      prompt: prompt.isEmpty ? null : prompt,
      image: image,
      latitude: lat,
      longitude: lng,
    );

    if (!mounted) return;

    if (success && isNewChat) {
      _currentChatId = activeChatId;
    }

    if (!success) {
      setState(() {
        _sendingIds.remove(messageId);
        _pendingMessages.removeWhere((p) => p.id == messageId);
        _localImages.remove(messageId);
      });
    }
  }

  // ─── State updates ────────────────────────────────────────────────────────

  void _handleMessagesUpdate(
    List<MessageEntity> messages, {
    String? completedId,
    bool keepSendingIds = false,
    bool scrollToBottom = false,
    bool animate = false,
  }) {
    setState(() {
      _messages = messages;

      for (final message in messages) {
        if (message.localImagePath != null &&
            !_localImages.containsKey(message.id)) {
          final file = File(message.localImagePath!);
          if (file.existsSync()) {
            _localImages[message.id] = file;
          }
        }
      }

      final confirmedIds = _messages.map((m) => m.id).toSet();
      _pendingMessages.removeWhere((p) => confirmedIds.contains(p.id));

      if (!keepSendingIds && completedId != null) {
        _sendingIds.remove(completedId);
      } else if (!keepSendingIds &&
          completedId == null &&
          _sendingIds.isNotEmpty) {
        _sendingIds.clear();
      }
    });

    if (scrollToBottom) {
      if (animate) {
        _scheduleAnimateToBottom();
      } else {
        _scheduleInitialScroll();
      }
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is MessagesLoaded) {
          _handleMessagesUpdate(
            state.messages,
            keepSendingIds: true,
            scrollToBottom: !_hasLoadedInitialMessages,
            animate: false,
          );

          _hasLoadedInitialMessages = true;
        }

        if (state is MessagesUpdated) {
          _handleMessagesUpdate(
            state.messages,
            completedId: state.completedMessageId,
            scrollToBottom: false,
            animate: false,
          );
        }

        if (state is ChatLoading &&
            state.action == ChatAction.loadingMessages) {
          setState(() => _messages = []);
        }
      },
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final isLoadingMessages = state.isLoading(ChatAction.loadingMessages);
          final allMessages = [..._messages, ..._pendingMessages];

          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // ── Message list ─────────────────────────────────────
                    isLoadingMessages
                        ? const Center(child: CircularProgressIndicator())
                        : allMessages.isEmpty && !_isSending
                        ? const ChatEmptyState()
                        : ListView.builder(
                            scrollCacheExtent: ScrollCacheExtent.pixels(2000),
                            controller: _scrollController,
                            physics: const ClampingScrollPhysics(),
                            reverse: false,
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 12.h,
                            ),
                            itemCount:
                                allMessages.length + (_isSending ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (_isSending && index == allMessages.length) {
                                return const TypingIndicator();
                              }
                              final message = allMessages[index];

                              if (message.role == MessageRole.user) {
                                final inputMessage = MessageModel.fromEntity(
                                  message,
                                ).asInputOnly();
                                return RepaintBoundary(
                                  child: UserMessageBubble(
                                    key: ValueKey(message.id),
                                    message: inputMessage,
                                    localImage: _localImages[message.id],
                                  ),
                                );
                              }
                              return RepaintBoundary(
                                child: AssistantMessageBubble(
                                  key: ValueKey(message.id),
                                  message: message,
                                ),
                              );
                            },
                          ),

                    // ── FAB ──────────────────────────────────────────────
                    if (_showScrollToBottomFab)
                      PositionedDirectional(
                        bottom: 12.h,
                        start: 16.w,
                        child: FloatingActionButton.small(
                          heroTag: 'scroll_to_bottom_fab',
                          onPressed: _glideToBottom,
                          elevation: 4,
                          child: const Icon(Icons.keyboard_arrow_down),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Image preview ──────────────────────────────────────────
              if (_selectedImage != null)
                ImagePreviewWidget(
                  image: _selectedImage!,
                  onRemove: () => setState(() {
                    _selectedImage = null;
                    _selectedImageLat = null;
                    _selectedImageLng = null;
                  }),
                ),

              // ── Chat input ─────────────────────────────────────────────
              InlineChatInput(
                controller: _controller,
                hintText: S.of(context).askPlantDoctor,
                showMic: true,
                showVoice: false,
                hasAttachment: _selectedImage != null,
                onSend: _handleSend,
                onAttachment: _handleAttachment,
                onMic: () => ComingSoonDialog.show(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
