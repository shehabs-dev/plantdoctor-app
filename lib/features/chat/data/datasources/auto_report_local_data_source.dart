import 'package:hive/hive.dart';
import '../models/auto_report_model.dart';

abstract class AutoReportLocalDataSource {
  Future<void> saveReport(AutoReportModel report);
  Future<List<AutoReportModel>> getPendingReports();
  Future<void> deleteReport(String reportId);
  Future<void> clearAll();
}

class AutoReportLocalDataSourceImpl implements AutoReportLocalDataSource {
  final Box<Map<dynamic, dynamic>> _box;

  AutoReportLocalDataSourceImpl({required Box<Map<dynamic, dynamic>> box})
    : _box = box;

  @override
  Future<void> saveReport(AutoReportModel report) async {
    await _box.put(report.id, report.toHiveMap());
  }

  @override
  Future<List<AutoReportModel>> getPendingReports() async {
    return _box.values
        .map((e) => AutoReportModel.fromHiveMap(Map<String, dynamic>.from(e)))
        .where((r) => !r.isSynced) // ← Only return unsynced auto-reports
        .toList();
  }

  @override
  Future<void> deleteReport(String reportId) async {
    await _box.delete(reportId);
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
  }
}
