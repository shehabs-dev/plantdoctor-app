import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/firebase_auth_error_codes.dart';
import '../../domain/entities/auth_provider.dart';
import '../models/user_model.dart';
import 'providers/google_sign_in_provider.dart';

abstract class AuthRemoteDataSource {
  Stream<User?> get userChanges;

  Future<UserModel> signIn({required String email, required String password});

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<void> signOut();

  Future<void> sendEmailVerification();

  Future<String> isEmailVerified();

  Future<User> signInWithProvider({
    required AppAuthProvider provider,
    void Function()? onAccountSelected,
  });

  Future<void> resetPassword({required String email});
}

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignInProvider _googleSignInProvider;

  FirebaseAuthRemoteDataSource({
    required FirebaseAuth firebaseAuth,
    required GoogleSignInProvider googleSignInProvider,
  }) : _googleSignInProvider = googleSignInProvider,
       _firebaseAuth = firebaseAuth;

  @override
  Stream<User?> get userChanges => _firebaseAuth.userChanges();

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user!.updateDisplayName(name);
      return UserModel(
        id: credential.user!.uid,
        name: name,
        email: email,
        isEmailVerified: false,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(code: e.code);
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(code: e.code);
    } catch (_) {
      throw const AuthException(code: FirebaseAuthErrorCodes.invalidCredential);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignInProvider.signOut(),
      ]);
    } on FirebaseAuthException catch (e) {
      throw AuthException(code: e.code);
    }
  }

  @override
  Future<User> signInWithProvider({
    required AppAuthProvider provider,
    void Function()? onAccountSelected,
  }) async {
    try {
      return switch (provider) {
        AppAuthProvider.google => await _signInWithGoogle(
          onAccountSelected: onAccountSelected,
        ),
      };
    } on AuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthException(code: e.code);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException(code: FirebaseAuthErrorCodes.noCurrentUser);
    }

    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw AuthException(code: e.code);
    }
  }

  @override
  Future<String> isEmailVerified() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw const AuthException(code: FirebaseAuthErrorCodes.noCurrentUser);
      }

      await user.reload();
      final refreshedUser = _firebaseAuth.currentUser!;

      if (!refreshedUser.emailVerified) {
        throw const AuthException(
          code: FirebaseAuthErrorCodes.emailNotVerified,
        );
      }

      return refreshedUser.uid;
    } on FirebaseAuthException catch (e) {
      throw AuthException(code: e.code);
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(code: e.code);
    }
  }

  Future<User> _signInWithGoogle({void Function()? onAccountSelected}) async {
    final credential = await _googleSignInProvider.getCredential(
      onAccountSelected: onAccountSelected,
    );
    final result = await _firebaseAuth.signInWithCredential(credential);
    return result.user!;
  }
}
