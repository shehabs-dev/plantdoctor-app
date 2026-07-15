import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

class SyncPendingMessagesUsecase {
  final ChatRepository _repository;
  const SyncPendingMessagesUsecase(this._repository);

  Future<Either<Failure, Unit>> call() => _repository.syncPendingMessages();
}
