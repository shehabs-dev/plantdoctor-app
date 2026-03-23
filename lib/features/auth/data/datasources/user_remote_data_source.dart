import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<void> setUserData(UserModel user);
  Future<UserModel> getUserData(String userId);
  Future<void> updateUserData(String userId, Map<String, dynamic> data);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore _firestore;

  UserRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  @override
  Future<void> setUserData(UserModel user) async {
    try {
      await _users
          .doc(user.id)
          .set(user.toFirestoreMap(), SetOptions(merge: true));
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getUserData(String userId) async {
    try {
      final doc = await _users.doc(userId).get();
      if (!doc.exists || doc.data() == null) throw ServerException();
      return UserModel.fromFirestoreMap(doc.data()!);
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await _users.doc(userId).update(data);
    } on FirebaseException {
      throw ServerException();
    }
  }
}
