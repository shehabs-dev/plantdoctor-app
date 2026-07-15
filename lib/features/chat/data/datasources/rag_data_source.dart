import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/token/token_provider.dart';

abstract class RagDataSource {
  Future<void> startChat({required String chatId, required String title});
  Future<String> sendMessage({
    String? prompt,
    String? label,
    double? confidence,
    String? imageUrl,
    required String messageId,
    required String assistantMessageId,
    required String chatId,
  });
}

class RagDataSourceImpl implements RagDataSource {
  final Dio _dio;
  final String _baseUrl;
  final TokenProvider _tokenProvider;

  static const Duration _ragReceiveTimeout = Duration(seconds: 90);
  static const Duration _ragSendTimeout = Duration(seconds: 30);

  RagDataSourceImpl({
    required Dio dio,
    required String baseUrl,
    required TokenProvider tokenProvider,
  }) : _dio = dio,
       _baseUrl = baseUrl,
       _tokenProvider = tokenProvider;

  String get _root => _baseUrl.endsWith('/')
      ? _baseUrl.substring(0, _baseUrl.length - 1)
      : _baseUrl;

  Future<Map<String, String>> _authHeader({bool forceRefresh = false}) async {
    final token = await _tokenProvider.getToken(forceRefresh: forceRefresh);
    if (token == null) throw ServerException();
    return {'Authorization': 'Bearer $token'};
  }

  Options _ragOptions(Map<String, String> headers) => Options(
    headers: headers,
    receiveTimeout: _ragReceiveTimeout,
    sendTimeout: _ragSendTimeout,
  );

  Never _throwForDio(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      throw OfflineException();
    }
    final status = e.response?.statusCode;
    if (status == 404) throw SessionNotFoundException();
    throw ServerException();
  }

  static const int _maxPromptLength = 1000;

  String? _normalizePrompt(String? prompt) {
    if (prompt == null) return null;
    final trimmed = prompt.trim();
    if (trimmed.isEmpty) return null;
    return trimmed.length <= _maxPromptLength
        ? trimmed
        : trimmed.substring(0, _maxPromptLength);
  }

  double? _normalizeConfidence(double? confidence) {
    if (confidence == null) return null;
    if (confidence.isNaN) return null;
    return confidence.clamp(0.0, 1.0);
  }

  String _parseAnswer(dynamic data) {
    if (data is! Map) throw ServerException();
    final message = data['message'];
    if (message is Map && message['answer'] is String) {
      return message['answer'] as String;
    }
    // Legacy / alternate shape
    if (data['response'] is String) return data['response'] as String;
    throw ServerException();
  }

  @override
  Future<void> startChat({
    required String chatId,
    required String title,
  }) async {
    try {
      final headers = await _authHeader();
      if (kDebugMode) {
        debugPrint('[RAG] POST /chat/start chat_id=$chatId');
      }
      await _dio.post(
        '$_root/chat/start',
        data: {'chat_id': chatId, 'title': title},
        options: _ragOptions(headers),
      );
    } on DioException catch (e) {
      _throwForDio(e);
    }
  }

  @override
  Future<String> sendMessage({
    String? prompt,
    String? label,
    double? confidence,
    String? imageUrl,
    required String messageId,
    required String assistantMessageId,
    required String chatId,
  }) async {
    // Matches backend MessageRequest (snake_case JSON field names).
    final normalizedPrompt = _normalizePrompt(prompt);
    final normalizedConfidence = _normalizeConfidence(confidence);
    final body = <String, dynamic>{
      'message_id': messageId,
      'assistant_message_id': assistantMessageId,
      'prompt': ?normalizedPrompt,
      if (label != null && label.isNotEmpty) 'label': label,
      'confidence': ?normalizedConfidence,
      if (imageUrl != null && imageUrl.isNotEmpty) 'image_url': imageUrl,
    };

    if (!body.containsKey('prompt') && !body.containsKey('label')) {
      throw ServerException();
    }

    if (kDebugMode) {
      debugPrint(
        '[RAG] POST /chat/$chatId/message body=${body.keys.join(', ')}',
      );
    }

    return _postMessage(chatId: chatId, body: body, forceRefresh: false);
  }

  Future<String> _postMessage({
    required String chatId,
    required Map<String, dynamic> body,
    required bool forceRefresh,
  }) async {
    try {
      final headers = await _authHeader(forceRefresh: forceRefresh);
      final response = await _dio.post(
        '$_root/chat/$chatId/message',
        data: body,
        options: _ragOptions(headers),
      );
      return _parseAnswer(response.data);
    } on DioException catch (e) {
      if (!forceRefresh && e.response?.statusCode == 401) {
        return _postMessage(chatId: chatId, body: body, forceRefresh: true);
      }
      _throwForDio(e);
    }
  }
}
