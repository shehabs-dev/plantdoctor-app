import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageUsecase {
  final ChatRepository _repository;
  const SendMessageUsecase(this._repository);

  Future<Either<Failure, MessageEntity>> call(MessageEntity message) =>
      _repository.sendMessage(message);
}
