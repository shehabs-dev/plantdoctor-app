import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

class SendToRagUsecase {
  final ChatRepository _repository;
  const SendToRagUsecase(this._repository);

  Future<Either<Failure, String>> call({
    String? prompt,
    String? label,
    double? confidence,
    String? imageUrl,
    required String messageId,
    required String assistantMessageId,
    required String chatId,
    String? chatTitle,
  }) => _repository.sendToRag(
    prompt: prompt,
    label: label,
    confidence: confidence,
    imageUrl: imageUrl,
    messageId: messageId,
    assistantMessageId: assistantMessageId,
    chatId: chatId,
    chatTitle: chatTitle,
  );
}
