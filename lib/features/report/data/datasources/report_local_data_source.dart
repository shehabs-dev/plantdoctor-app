import 'package:hive/hive.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/report_model.dart';

abstract class ReportLocalDataSource {
  Future<void> saveReport(ReportModel report);
  Future<List<ReportModel>> getPendingReports(String userId);
  Future<List<ReportModel>> getAllPendingReports();
  Future<void> pruneSyncedReports();
  Future<void> deleteReport(String reportId);
}

class ReportLocalDataSourceImpl implements ReportLocalDataSource {
  final Box<Map<dynamic, dynamic>> _box;

  ReportLocalDataSourceImpl({required Box<Map<dynamic, dynamic>> box})
    : _box = box;

  @override
  Future<void> saveReport(ReportModel report) async {
    try {
      await _box.put(report.id, report.toMap());
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<ReportModel>> getPendingReports(String userId) async {
    try {
      return _box.values
          .map((e) => ReportModel.fromMap(Map<String, dynamic>.from(e)))
          .where((r) => r.userId == userId && !r.isSynced)
          .toList();
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<ReportModel>> getAllPendingReports() async {
    try {
      return _box.values
          .map((e) => ReportModel.fromMap(Map<String, dynamic>.from(e)))
          .where((r) => !r.isSynced)
          .toList();
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> pruneSyncedReports() async {
    try {
      final syncedIds = _box.values
          .map((e) => ReportModel.fromMap(Map<String, dynamic>.from(e)))
          .where((r) => r.isSynced)
          .map((r) => r.id)
          .toList();

      if (syncedIds.isNotEmpty) {
        await _box.deleteAll(syncedIds);
      }
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteReport(String reportId) async {
    try {
      await _box.delete(reportId);
    } catch (_) {
      throw CacheException();
    }
  }
}
