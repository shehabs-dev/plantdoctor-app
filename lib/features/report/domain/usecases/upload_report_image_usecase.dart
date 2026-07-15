import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../../core/errors/failures.dart';
import '../repositories/report_repository.dart';

class UploadReportImageUsecase {
  final ReportRepository _repository;

  UploadReportImageUsecase(this._repository);

  Future<Either<Failure, String>> call(File image) =>
      _repository.uploadReportImage(image);
}
