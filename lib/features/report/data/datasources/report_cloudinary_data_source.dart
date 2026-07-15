import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/errors/exceptions.dart';

abstract class ReportCloudinaryDataSource {
  Future<String> uploadImage(File image);
}

class ReportCloudinaryDataSourceImpl implements ReportCloudinaryDataSource {
  final Dio _dio;
  final String _cloudinaryReportPreset;
  final String _cloudinaryReportFolder;
  final String _cloudinaryCloudName;

  ReportCloudinaryDataSourceImpl({
    required Dio dio,
    required String cloudinaryReportPreset,
    required String cloudinaryReportFolder,
    required String cloudinaryCloudName,
  }) : _cloudinaryCloudName = cloudinaryCloudName,
       _cloudinaryReportPreset = cloudinaryReportPreset,
       _cloudinaryReportFolder = cloudinaryReportFolder,
       _dio = dio;

  @override
  Future<String> uploadImage(File image) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path),
        'upload_preset': _cloudinaryReportPreset,
        'folder': _cloudinaryReportFolder,
      });

      final response = await _dio.post(
        '${EnvConfig.cloudinaryApiBaseUrl}/$_cloudinaryCloudName/image/upload',
        data: formData,
      );

      final url = response.data['secure_url'] as String?;
      if (url == null) throw ServerException();
      return url;
    } catch (_) {
      throw ServerException();
    }
  }
}
