import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class GetMessagesUsecase {
  final ChatRepository _repository;
  const GetMessagesUsecase(this._repository);

  Future<Either<Failure, List<MessageEntity>>> call(String chatId, {int? limit}) =>
      _repository.getMessages(chatId, limit: limit);
}
