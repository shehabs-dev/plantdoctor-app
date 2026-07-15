import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<void> setUserData(UserModel user);
  Future<UserModel> getUserData(String userId);
  Future<void> updateUserData(String userId, Map<String, dynamic> data);
  Future<String> uploadPicture({required String userId, required File image});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore _firestore;
  static const Duration _timeout = Duration(seconds: 15);
  final String _cloudinaryCloudName;
  final String _cloudinaryProfilePreset;
  final String _cloudinaryProfileFolder;
  final Dio _dio;

  UserRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required Dio dio,
    required String cloudinaryCloudName,
    required String cloudinaryProfilePreset,
    required String cloudinaryProfileFolder,
  }) : _cloudinaryCloudName = cloudinaryCloudName,
       _cloudinaryProfilePreset = cloudinaryProfilePreset,
       _cloudinaryProfileFolder = cloudinaryProfileFolder,
       _dio = dio,
       _firestore = firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Never _handleError(Object e) {
    if (e is ServerException) throw e;
    throw ServerException();
  }

  @override
  Future<void> setUserData(UserModel user) async {
    try {
      await _users
          .doc(user.id)
          .set(user.toFirestoreMap(), SetOptions(merge: true))
          .timeout(_timeout);
    } catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<UserModel> getUserData(String userId) async {
    try {
      final doc = await _users.doc(userId).get().timeout(_timeout);
      if (!doc.exists || doc.data() == null) throw ServerException();
      return UserModel.fromFirestoreMap(doc.data()!);
    } catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await _users.doc(userId).update(data).timeout(_timeout);
    } catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<String> uploadPicture({
    required String userId,
    required File image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path),
        'upload_preset': _cloudinaryProfilePreset,
        'folder': _cloudinaryProfileFolder,
      });

      final response = await _dio
          .post(
            '${EnvConfig.cloudinaryApiBaseUrl}/$_cloudinaryCloudName/image/upload',
            data: formData,
          )
          .timeout(_timeout);

      final url = response.data['secure_url'] as String?;
      if (url == null) throw ServerException();
      return url;
    } catch (e) {
      _handleError(e);
    }
  }
}
