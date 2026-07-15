import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class CreateChatUsecase {
  final ChatRepository _repository;
  const CreateChatUsecase(this._repository);

  Future<Either<Failure, ChatEntity>> call(ChatEntity chat) =>
      _repository.createChat(chat);
}
