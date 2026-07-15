import 'package:fpdart/fpdart.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/report_entity.dart';
import '../repositories/report_repository.dart';

class GetPendingReportsUsecase {
  final ReportRepository _repository;

  GetPendingReportsUsecase(this._repository);

  Future<Either<Failure, List<ReportEntity>>> call(String userId) =>
      _repository.getPendingReports(userId);
}
