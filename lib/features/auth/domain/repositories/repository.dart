import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_provider.dart';
import '../entities/user_entity.dart';

abstract class Repository {
  Stream<Either<Failure, UserEntity?>> get authStateChanges;
  // Authentication
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, UserEntity>> signInWithProvider({
    required AppAuthProvider provider,
  });

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, Unit>> sendEmailVerification();
  Future<Either<Failure, bool>> isEmailVerified();

  Future<Either<Failure, Unit>> resetPassword({required String email});

  // Firestore___________________________________
  Future<Either<Failure, Unit>> setUserData(UserEntity user);

  Future<Either<Failure, UserEntity>> getUserData(String userId);

  // SharedPreference___________________________________
  Future<UserEntity?> getCachedUser();
}
