import 'package:fpdart/fpdart.dart';
import '../../../../../core/errors/failures.dart';
import '../repositories/report_repository.dart';

class SyncReportsUsecase {
  final ReportRepository _repository;

  SyncReportsUsecase(this._repository);

  /// Returns number of successfully synced reports
  Future<Either<Failure, int>> call() => _repository.syncPendingReports();
}
