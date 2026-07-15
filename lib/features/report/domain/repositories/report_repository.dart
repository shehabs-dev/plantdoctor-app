import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/report_entity.dart';

abstract class ReportRepository {
  /// Save report locally first, sync to Firestore only when online
  Future<Either<Failure, Unit>> submitReport(
    ReportEntity report, {
    required bool isOnline,
  });

  /// Upload image to Cloudinary
  Future<Either<Failure, String>> uploadReportImage(File image);

  /// Get all pending (unsynced) reports for current user
  Future<Either<Failure, List<ReportEntity>>> getPendingReports(String userId);

  /// Sync all pending reports to Firestore, delete from local on success
  Future<Either<Failure, int>> syncPendingReports();
}
