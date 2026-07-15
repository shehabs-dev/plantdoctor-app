import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/errors/exceptions.dart';

abstract class CloudinaryDataSource {
  Future<String> uploadImage(File image);
}

class CloudinaryDataSourceImpl implements CloudinaryDataSource {
  final Dio _dio;
  final String _cloudName;
  final String _uploadPreset;
  final String _diseaseFolder;

  CloudinaryDataSourceImpl({
    required Dio dio,
    required String cloudName,
    required String uploadPreset,
    required String diseaseFolder,
  }) : _diseaseFolder = diseaseFolder,
       _dio = dio,
       _cloudName = cloudName,
       _uploadPreset = uploadPreset;

  @override
  Future<String> uploadImage(File image) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path),
        'upload_preset': _uploadPreset,
        'folder': _diseaseFolder,
      });

      final response = await _dio.post(
        '${EnvConfig.cloudinaryApiBaseUrl}/$_cloudName/image/upload',
        data: formData,
      );

      return response.data['secure_url'] as String;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw OfflineException();
      }
      throw ServerException();
    }
  }
}
