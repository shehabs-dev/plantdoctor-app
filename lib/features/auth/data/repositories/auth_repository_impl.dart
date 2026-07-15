import 'dart:io';

import 'package:fpdart/fpdart.dart';
import '../../../../core/helpers/auth_failure_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/auth_provider.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements Repository {
  final AuthRemoteDataSource _authDataSource;
  final UserRemoteDataSource _userDataSource;
  final UserLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource authDataSource,
    required UserRemoteDataSource userDataSource,
    required UserLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource,
       _authDataSource = authDataSource,
       _userDataSource = userDataSource;

  // ─── Stream ────────────────────────────────────────────────────────────────

  @override
  Stream<Either<Failure, UserEntity?>> get authStateChanges =>
      _authDataSource.userChanges.map((firebaseUser) {
        if (firebaseUser == null) return right(null);
        return right(UserModel.fromFirebaseUser(firebaseUser));
      });

  // ─── Authentication ────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await _authDataSource.signUp(
        email: email,
        password: password,
        name: name,
      );

      await _userDataSource.setUserData(user);
      await _localDataSource.cacheUser(user);
      return right(user);
    } on AuthException catch (e) {
      // This handle firebase auth errors
      return left(AuthFailureMapper.fromFirebaseCode(e.code));
    } on ServerException {
      // This handle firestore errors
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authDataSource.signIn(
        email: email,
        password: password,
      );
      await _localDataSource.cacheUser(user);
      return right(user);
    } on AuthException catch (e) {
      return left(AuthFailureMapper.fromFirebaseCode(e.code));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithProvider({
    required AppAuthProvider provider,
    void Function()? onAccountSelected,
  }) async {
    try {
      final firebaseUser = await _authDataSource.signInWithProvider(
        provider: provider,
        onAccountSelected: onAccountSelected,
      );

      UserModel user;
      try {
        user = await _userDataSource.getUserData(firebaseUser.uid);
      } on ServerException {
        user = UserModel.fromFirebaseUser(firebaseUser);
        await _userDataSource.setUserData(user);
      }
      await _localDataSource.cacheUser(user);
      return right(user);
    } on AuthException catch (e) {
      return left(AuthFailureMapper.fromFirebaseCode(e.code));
    } on ServerException {
      return left(ServerFailure());
    } catch (_) {
      return left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _authDataSource.signOut();
      await _localDataSource.clearCachedUser();

      return right(unit);
    } on AuthException catch (e) {
      return left(AuthFailureMapper.fromFirebaseCode(e.code));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendEmailVerification() async {
    try {
      await _authDataSource.sendEmailVerification();
      return right(unit);
    } on AuthException catch (e) {
      return left(AuthFailureMapper.fromFirebaseCode(e.code));
    }
  }

  @override
  Future<Either<Failure, bool>> isEmailVerified() async {
    try {
      final uid = await _authDataSource.isEmailVerified();
      await _userDataSource.updateUserData(uid, {'isEmailVerified': true});
      final cached = await _localDataSource.getCachedUser();
      if (cached != null) {
        await _localDataSource.cacheUser(
          cached.copyWith(isEmailVerified: true),
        );
      }
      return right(true);
    } on AuthException catch (e) {
      return left(AuthFailureMapper.fromFirebaseCode(e.code));
    } on ServerException {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({required String email}) async {
    try {
      await _authDataSource.resetPassword(email: email);
      return right(unit);
    } on AuthException catch (e) {
      return left(AuthFailureMapper.fromFirebaseCode(e.code));
    }
  }

  // ─── Firestore ─────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, UserEntity>> getUserData(String userId) async {
    try {
      final user = await _userDataSource.getUserData(userId);
      return right(user);
    } on ServerException {
      return left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> setUserData(UserEntity user) async {
    try {
      await _userDataSource.setUserData(user as UserModel);
      return right(unit);
    } on ServerException {
      return left(ServerFailure());
    }
  }

  // ─── Profile ───────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, UserEntity>> updatePicture({
    required String userId,
    required File image,
  }) async {
    try {
      // 1. upload to Cloudinary
      final url = await _userDataSource.uploadPicture(
        userId: userId,
        image: image,
      );

      // 2. update Firestore
      await _userDataSource.updateUserData(userId, {'picture': url});

      // 3. update local cache
      final cached = await _localDataSource.getCachedUser();
      if (cached != null) {
        await _localDataSource.cacheUser(cached.copyWith(picture: url));
      }

      // 4. return updated user
      final updatedUser = await _userDataSource.getUserData(userId);
      return right(updatedUser);
    } on ServerException {
      return left(ServerFailure());
    }
  }

  // ─── SharedPreference ─────────────────────────────────────────────────────────────
  @override
  Future<UserEntity?> getCachedUser() async {
    return await _localDataSource.getCachedUser();
  }
}
