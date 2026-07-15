import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auto_report_entity.dart';
import '../repositories/chat_repository.dart';

class SaveReportUsecase {
  final ChatRepository _repository;
  const SaveReportUsecase(this._repository);

  Future<Either<Failure, Unit>> call(AutoReportEntity report) =>
      _repository.saveReport(report);
}
