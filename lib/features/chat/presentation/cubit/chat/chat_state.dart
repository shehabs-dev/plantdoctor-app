part of 'chat_cubit.dart';

enum ChatAction {
  none,
  creatingChat,
  loadingChats,
  deletingChat,
  loadingMessages,
  sendingMessage,
}

sealed class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {
  final ChatAction action;
  final bool isFirstTime;

  const ChatLoading(this.action, {this.isFirstTime = false});

  @override
  List<Object?> get props => [action, isFirstTime];
}

final class ChatsLoaded extends ChatState {
  final List<ChatEntity> chats;
  final bool isFromCache;
  final bool isRefreshing;
  final String? deletingChatId;

  const ChatsLoaded({
    required this.chats,
    this.isFromCache = false,
    this.isRefreshing = false,
    this.deletingChatId,
  });

  @override
  List<Object?> get props => [chats, isFromCache, isRefreshing, deletingChatId];
}

final class MessagesLoaded extends ChatState {
  final List<MessageEntity> messages;
  const MessagesLoaded(this.messages);
  @override
  List<Object?> get props => [messages];
}

final class ChatError extends ChatState {
  final ErrorMessageKey key;
  final String _timestamp;
  ChatError(this.key) : _timestamp = DateTime.now().toIso8601String();
  @override
  List<Object?> get props => [key, _timestamp];
}

/// Emitted when the background task for [completedMessageId] finishes.
/// The view removes that id from _sendingIds to hide the typing indicator.
final class MessagesUpdated extends ChatState {
  final List<MessageEntity> messages;
  final String completedMessageId;
  const MessagesUpdated(this.messages, this.completedMessageId);
  @override
  List<Object?> get props => [messages, completedMessageId];
}

extension ChatStateX on ChatState {
  bool isLoading(ChatAction action) =>
      this is ChatLoading && (this as ChatLoading).action == action;
  bool get isAnyLoading => this is ChatLoading;
}
