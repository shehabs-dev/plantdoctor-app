import 'package:fpdart/fpdart.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/report_entity.dart';
import '../repositories/report_repository.dart';

class SubmitReportUsecase {
  final ReportRepository _repository;

  SubmitReportUsecase(this._repository);

  Future<Either<Failure, Unit>> call(
    ReportEntity report, {
    required bool isOnline,
  }) => _repository.submitReport(report, isOnline: isOnline);
}
