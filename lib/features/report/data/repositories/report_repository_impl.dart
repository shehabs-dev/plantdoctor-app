import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_cloudinary_data_source.dart';
import '../datasources/report_local_data_source.dart';
import '../datasources/report_remote_data_source.dart';
import '../models/report_model.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource _remoteDataSource;
  final ReportLocalDataSource _localDataSource;
  final ReportCloudinaryDataSource _cloudinaryDataSource;

  ReportRepositoryImpl({
    required ReportRemoteDataSource remoteDataSource,
    required ReportLocalDataSource localDataSource,
    required ReportCloudinaryDataSource cloudinaryDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _cloudinaryDataSource = cloudinaryDataSource;

  @override
  Future<Either<Failure, Unit>> submitReport(
    ReportEntity report, {
    required bool isOnline,
  }) async {
    try {
      final model = ReportModel.fromEntity(report);

      // ── Always save locally first — instant, no network ─────────
      await _localDataSource.saveReport(model);

      // ── Attempt remote sync only when online ─────────────────────
      // Skipping this entirely offline eliminates the 8-second timeout wait.
      if (isOnline) {
        try {
          await _remoteDataSource
              .submitReport(model.copyWith(isSynced: true))
              .timeout(const Duration(seconds: 8));
          await _localDataSource.deleteReport(model.id);
        } on ServerException {
          // stays in Hive — will sync when back online
        } catch (_) {
          // timeout or any other error — stays in Hive
        }
      }

      return right(unit);
    } on CacheException {
      return left(CacheFailure());
    } catch (_) {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadReportImage(File image) async {
    try {
      final url = await _cloudinaryDataSource.uploadImage(image);
      return right(url);
    } on ServerException {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> getPendingReports(
    String userId,
  ) async {
    try {
      // Keep local report cache lean: pending list is the only local source
      // consumed by UI, so synced rows can be safely pruned.
      await _localDataSource.pruneSyncedReports();
      final reports = await _localDataSource.getPendingReports(userId);
      return right(reports);
    } on CacheException {
      return left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>> syncPendingReports() async {
    try {
      final pending = await _localDataSource.getAllPendingReports();
      int synced = 0;

      for (final report in pending) {
        try {
          var reportToSync = report;

          // ── Upload image to Cloudinary if it was saved offline ────
          // imagePath = local device path (saved offline)
          // imageURL  = null because upload was skipped when offline
          if (report.imagePath != null && report.imageURL == null) {
            final imageFile = File(report.imagePath!);
            if (imageFile.existsSync()) {
              final url = await _cloudinaryDataSource.uploadImage(imageFile);
              reportToSync = report.copyWith(imageURL: url);
            }
          }

          await _remoteDataSource
              .submitReport(reportToSync.copyWith(isSynced: true))
              .timeout(const Duration(seconds: 8));
          await _localDataSource.deleteReport(report.id);
          synced++;
        } on ServerException {
          // skip — try again next sync
        } catch (_) {
          // timeout or image upload error — skip, retry next sync
        }
      }

      return right(synced);
    } catch (_) {
      return left(ServerFailure());
    }
  }
}
