import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

class ClearChatCacheUsecase {
  final ChatRepository _repository;
  const ClearChatCacheUsecase(this._repository);

  Future<Either<Failure, Unit>> call() => _repository.clearCache();
}
