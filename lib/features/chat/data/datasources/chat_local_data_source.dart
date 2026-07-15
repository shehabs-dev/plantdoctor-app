import 'package:hive/hive.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatLocalDataSource {
  // ─── Messages ──────────────────────────────────────────────────────────
  Future<void> saveMessage(MessageModel message);
  Future<void> saveMessages(List<MessageModel> messages);
  Future<List<MessageModel>> getPendingMessages(String chatId);
  Future<List<MessageModel>> getAllPendingMessages();
  Future<List<MessageModel>> getAllMessages();
  Future<void> deleteMessage(String messageId);
  Future<void> deleteMessagesByChatId(String chatId);

  // ─── Chats ─────────────────────────────────────────────────────────────
  Future<void> saveChat(ChatModel chat);
  Future<void> saveChats(List<ChatModel> chats);
  Future<List<ChatModel>> getPendingChats();
  Future<List<ChatModel>> getAllChats();
  Future<void> deleteChat(String chatId);

  Future<void> clearAll();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final Box<Map<dynamic, dynamic>> _messagesBox;
  final Box<Map<dynamic, dynamic>> _chatsBox;

  ChatLocalDataSourceImpl({
    required Box<Map<dynamic, dynamic>> messagesBox,
    required Box<Map<dynamic, dynamic>> chatsBox,
  }) : _messagesBox = messagesBox,
       _chatsBox = chatsBox;

  // ─── Messages ──────────────────────────────────────────────────────────

  @override
  Future<void> saveMessage(MessageModel message) async {
    try {
      await _messagesBox.put(message.id, message.toHiveMap());
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveMessages(List<MessageModel> messages) async {
    try {
      final entries = {for (var m in messages) m.id: m.toHiveMap()};
      await _messagesBox.putAll(entries);
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<MessageModel>> getPendingMessages(String chatId) async {
    try {
      return _messagesBox.values
          .map((e) => MessageModel.fromHiveMap(Map<String, dynamic>.from(e)))
          .where((m) => m.chatId == chatId && !m.isSynced)
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<MessageModel>> getAllPendingMessages() async {
    try {
      return _messagesBox.values
          .map((e) => MessageModel.fromHiveMap(Map<String, dynamic>.from(e)))
          .where((m) => !m.isSynced) // Only return unsynced messages
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<MessageModel>> getAllMessages() async {
    try {
      return _messagesBox.values
          .map((e) => MessageModel.fromHiveMap(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    await _messagesBox.delete(messageId);
  }

  @override
  Future<void> deleteMessagesByChatId(String chatId) async {
    try {
      final messageIdsToDelete = _messagesBox.values
          .map((e) => MessageModel.fromHiveMap(Map<String, dynamic>.from(e)))
          .where((m) => m.chatId == chatId)
          .map((m) => m.id)
          .toList();

      await _messagesBox.deleteAll(messageIdsToDelete);
    } catch (_) {
      throw CacheException();
    }
  }

  // ─── Chats ─────────────────────────────────────────────────────────────

  @override
  Future<void> saveChat(ChatModel chat) async {
    try {
      await _chatsBox.put(chat.id, chat.toHiveMap());
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveChats(List<ChatModel> chats) async {
    try {
      final entries = {for (var c in chats) c.id: c.toHiveMap()};
      await _chatsBox.putAll(entries);
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<ChatModel>> getPendingChats() async {
    try {
      return _chatsBox.values
          .map((e) => ChatModel.fromHiveMap(Map<String, dynamic>.from(e)))
          .where((c) => !c.isSynced) // Only return unsynced chats
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<ChatModel>> getAllChats() async {
    try {
      return _chatsBox.values
          .map((e) => ChatModel.fromHiveMap(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await _chatsBox.delete(chatId);
  }

  @override
  Future<void> clearAll() async {
    await _messagesBox.clear();
    await _chatsBox.clear();
  }
}
