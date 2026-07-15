import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/report_model.dart';

abstract class ReportRemoteDataSource {
  Future<void> submitReport(ReportModel report);
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final FirebaseFirestore _firestore;
  static const Duration _timeout = Duration(seconds: 5);

  ReportRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> get _reports =>
      _firestore.collection('reports');

  @override
  Future<void> submitReport(ReportModel report) async {
    try {
      await _reports.doc(report.id).set(report.toFirestoreMap()).timeout(_timeout);
    } on FirebaseException {
      throw ServerException();
    }
  }
}
