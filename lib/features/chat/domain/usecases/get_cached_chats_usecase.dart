import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class GetCachedChatsUsecase {
  final ChatRepository _repository;
  const GetCachedChatsUsecase(this._repository);

  Future<Either<Failure, List<ChatEntity>>> call(String userId) =>
      _repository.getCachedChats(userId);
}
