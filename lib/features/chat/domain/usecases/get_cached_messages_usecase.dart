import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class GetCachedMessagesUsecase {
  final ChatRepository _repository;
  const GetCachedMessagesUsecase(this._repository);

  Future<Either<Failure, List<MessageEntity>>> call(String chatId) async {
    return await _repository.getCachedMessages(chatId);
  }
}
