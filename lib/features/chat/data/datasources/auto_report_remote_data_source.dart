import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/auto_report_model.dart';

abstract class AutoReportRemoteDataSource {
  Future<void> saveReport(AutoReportModel report);
}

class AutoReportRemoteDataSourceImpl implements AutoReportRemoteDataSource {
  final FirebaseFirestore _firestore;
  static const Duration _timeout = Duration(seconds: 5);

  AutoReportRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Future<void> saveReport(AutoReportModel report) async {
    try {
      await _firestore
          .collection('auto_reports')
          .doc(report.id)
          .set(report.toFirestoreMap())
          .timeout(_timeout);
    } on FirebaseException {
      throw ServerException();
    } on TimeoutException {
      throw ServerException();
    }
  }
}
