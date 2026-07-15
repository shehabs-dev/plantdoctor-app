import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

class SyncPendingReportsUsecase {
  final ChatRepository _repository;
  const SyncPendingReportsUsecase(this._repository);

  Future<Either<Failure, Unit>> call() => _repository.syncPendingReports();
}
