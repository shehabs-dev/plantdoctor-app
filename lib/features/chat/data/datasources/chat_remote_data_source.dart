import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/storage/local_image_storage_service.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatModel> createChat(ChatModel chat);
  Future<List<ChatModel>> getChats(
    String userId, {
    int? limit,
    Source source = Source.serverAndCache,
  });
  Future<void> deleteChat(String chatId);
  Future<MessageModel> sendMessage(MessageModel message);
  Future<List<MessageModel>> getMessages(
    String chatId, {
    int? limit,
    Source source = Source.serverAndCache,
  });
  Future<MessageModel> cacheMessageAssets(MessageModel message);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore _firestore;
  final LocalImageStorageService _localImageStorageService;

  static const Duration _timeout = Duration(seconds: 10);
  // Increased timeout for assets as they can be large/Cloudinary can be slow
  static const Duration _imageDownloadTimeout = Duration(seconds: 30);

  ChatRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required Dio dio,
    required LocalImageStorageService localImageStorageService,
  }) : _firestore = firestore,
       _localImageStorageService = localImageStorageService;

  String _guessImageExtension(String url) {
    final u = url.toLowerCase();
    if (u.contains('.png')) return '.png';
    if (u.contains('.webp')) return '.webp';
    if (u.contains('.gif')) return '.gif';
    return '.jpg';
  }

  @override
  Future<MessageModel> cacheMessageAssets(MessageModel msg) async {
    // If already has a local path, don't download again
    if (msg.localImagePath != null && msg.localImagePath!.isNotEmpty) {
      if (await File(msg.localImagePath!).exists()) {
        return msg;
      }
    }

    final url = msg.imageURL;
    if (url == null || url.isEmpty) return msg;

    try {
      // Use a separate Dio instance or ensure this one is clean for binary data
      final response = await Dio()
          .get<List<int>>(
            url,
            options: Options(
              responseType: ResponseType.bytes,
              followRedirects: true,
              validateStatus: (status) => status != null && status < 500,
            ),
          )
          .timeout(_imageDownloadTimeout);

      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) return msg;

      final path = await _localImageStorageService.persistChatImageBytes(
        Uint8List.fromList(bytes),
        messageId: msg.id,
        extension: _guessImageExtension(url),
      );

      return MessageModel.fromEntity(msg.copyWith(localImagePath: path));
    } catch (e) {
      // Silent fail - will fallback to URL in UI or retry next time
      return msg;
    }
  }

  @override
  Future<ChatModel> createChat(ChatModel chat) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chat.id)
          .set(chat.toFirestoreMap())
          .timeout(_timeout);
      return chat;
    } on FirebaseException {
      throw ServerException();
    } on TimeoutException {
      throw ServerException();
    }
  }

  @override
  Future<List<ChatModel>> getChats(
    String userId, {
    int? limit,
    Source source = Source.serverAndCache,
  }) async {
    try {
      var query = _firestore
          .collection('chats')
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      final fetchFuture = query.get(GetOptions(source: source));
      final snapshot = source == Source.cache
          ? await fetchFuture
          : await fetchFuture.timeout(_timeout);

      return snapshot.docs
          .map(
            (doc) => ChatModel.fromFirestoreMap({
              ...doc.data(),
              'chat_id': doc.id,
            }),
          )
          .toList();
    } on FirebaseException catch (_) {
      if (source == Source.cache) throw ServerException();
      try {
        final cacheSnapshot = await _firestore
            .collection('chats')
            .where('userId', isEqualTo: userId)
            .orderBy('updatedAt', descending: true)
            .get(const GetOptions(source: Source.cache));
        return cacheSnapshot.docs
            .map(
              (doc) => ChatModel.fromFirestoreMap({
                ...doc.data(),
                'chat_id': doc.id,
              }),
            )
            .toList();
      } catch (_) {
        throw ServerException();
      }
    } on TimeoutException {
      try {
        final cacheSnapshot = await _firestore
            .collection('chats')
            .where('userId', isEqualTo: userId)
            .orderBy('updatedAt', descending: true)
            .get(const GetOptions(source: Source.cache));
        return cacheSnapshot.docs
            .map(
              (doc) => ChatModel.fromFirestoreMap({
                ...doc.data(),
                'chat_id': doc.id,
              }),
            )
            .toList();
      } catch (_) {
        throw ServerException();
      }
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    try {
      final batch = _firestore.batch();

      batch.delete(_firestore.collection('chats').doc(chatId));

      final messages = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();

      for (final doc in messages.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit().timeout(_timeout);
    } on FirebaseException {
      throw ServerException();
    } on TimeoutException {
      throw ServerException();
    }
  }

  @override
  Future<MessageModel> sendMessage(MessageModel message) async {
    try {
      await _firestore
          .collection('chats')
          .doc(message.chatId)
          .collection('messages')
          .doc(message.id)
          .set(message.toFirestoreMap())
          .timeout(_timeout);
      return message;
    } on FirebaseException {
      throw ServerException();
    } on TimeoutException {
      throw ServerException();
    }
  }

  @override
  Future<List<MessageModel>> getMessages(
    String chatId, {
    int? limit,
    Source source = Source.serverAndCache,
  }) async {
    try {
      var query = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages');

      final fetchFuture = query.get(GetOptions(source: source));
      final snapshot = source == Source.cache
          ? await fetchFuture
          : await fetchFuture.timeout(_timeout);

      final messages = snapshot.docs
          .map(
            (doc) => MessageModel.fromFirestoreMap({
              ...doc.data(),
              'message_id': doc.id,
              'chat_id': chatId,
            }),
          )
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

      if (limit != null && messages.length > limit) {
        return messages.sublist(messages.length - limit);
      }

      return messages;
    } on FirebaseException {
      if (source == Source.cache) throw ServerException();
      try {
        final cacheSnapshot = await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .get(const GetOptions(source: Source.cache));
        final messages = cacheSnapshot.docs
            .map(
              (doc) => MessageModel.fromFirestoreMap({
                ...doc.data(),
                'message_id': doc.id,
                'chat_id': chatId,
              }),
            )
            .toList()
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
        if (limit != null && messages.length > limit) {
          return messages.sublist(messages.length - limit);
        }
        return messages;
      } catch (_) {
        throw ServerException();
      }
    } on TimeoutException {
      try {
        final cacheSnapshot = await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .get(const GetOptions(source: Source.cache));
        final messages = cacheSnapshot.docs
            .map(
              (doc) => MessageModel.fromFirestoreMap({
                ...doc.data(),
                'message_id': doc.id,
                'chat_id': chatId,
              }),
            )
            .toList()
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
        if (limit != null && messages.length > limit) {
          return messages.sublist(messages.length - limit);
        }
        return messages;
      } catch (_) {
        throw ServerException();
      }
    }
  }
}
