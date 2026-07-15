import 'dart:io';

import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auto_report_entity.dart';
import '../entities/chat_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  // ─── Chat ────────────────────────────────────────────────────────────────
  Future<Either<Failure, ChatEntity>> createChat(ChatEntity chat);
  Future<Either<Failure, List<ChatEntity>>> getChats(
    String userId, {
    int? limit,
  });
  Future<Either<Failure, List<ChatEntity>>> getCachedChats(String userId);
  Future<Either<Failure, Unit>> deleteChat(String chatId);
  Future<Either<Failure, void>> preload(String userId);
  Future<Either<Failure, Unit>> clearCache();

  // ─── Message ─────────────────────────────────────────────────────────────
  Future<Either<Failure, MessageEntity>> sendMessage(MessageEntity message);
  Future<Either<Failure, List<MessageEntity>>> getMessages(
    String chatId, {
    int? limit,
  });
  Future<Either<Failure, List<MessageEntity>>> getCachedMessages(String chatId);
  Future<Either<Failure, Unit>> syncPendingMessages();

  // ─── Auto Report ─────────────────────────────────────────────────────────
  Future<Either<Failure, Unit>> saveReport(AutoReportEntity report);
  Future<Either<Failure, Unit>> syncPendingReports();

  // ─── Classification ───────────────────
  Future<Either<Failure, (String label, double confidence)>> classifyImage(
    File image,
  );

  // ─── Storage ──────────────────────────
  Future<Either<Failure, String>> uploadImage(File image);

  // ─── RAG ──────────────────────────────
  Future<Either<Failure, String>> sendToRag({
    String? prompt,
    String? label,
    double? confidence,
    String? imageUrl,
    required String messageId,
    required String assistantMessageId,
    required String chatId,
    String? chatTitle,
  });
}
