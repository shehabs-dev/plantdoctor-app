import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

class DeleteChatUsecase {
  final ChatRepository _repository;
  const DeleteChatUsecase(this._repository);

  Future<Either<Failure, Unit>> call(String chatId) =>
      _repository.deleteChat(chatId);
}
