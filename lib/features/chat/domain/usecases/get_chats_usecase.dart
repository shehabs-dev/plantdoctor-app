import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class GetChatsUsecase {
  final ChatRepository _repository;
  const GetChatsUsecase(this._repository);

  Future<Either<Failure, List<ChatEntity>>> call(String userId, {int? limit}) =>
      _repository.getChats(userId, limit: limit);
}
