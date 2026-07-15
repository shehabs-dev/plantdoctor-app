import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../../core/config/env_config.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/firebase_auth_error_codes.dart';

class GoogleSignInProvider {
  final GoogleSignIn _googleSignIn;
  bool _isInitialized = false;

  GoogleSignInProvider({required GoogleSignIn googleSignIn})
    : _googleSignIn = googleSignIn;

  Future<void> _initialize() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize(serverClientId: EnvConfig.googleClientId);
      _isInitialized = true;
    }
  }

  Future<OAuthCredential> getCredential({
    void Function()? onAccountSelected,
  }) async {
    await _initialize();
    try {
      final googleUser = await _googleSignIn.authenticate();

      // ── Account selected — trigger loading ────────────────────────
      onAccountSelected?.call();

      final idToken = googleUser.authentication.idToken;
      final authorizationClient = googleUser.authorizationClient;
      GoogleSignInClientAuthorization? authorization = await authorizationClient
          .authorizationForScopes(['email', 'profile']);
      if (authorization?.accessToken == null) {
        authorization = await authorizationClient.authorizationForScopes([
          'email',
          'profile',
        ]);
      }
      if (authorization?.accessToken == null) {
        throw const AuthException(
          code: FirebaseAuthErrorCodes.googleSignInAborted,
        );
      }
      return GoogleAuthProvider.credential(
        accessToken: authorization!.accessToken,
        idToken: idToken,
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException(
          code: FirebaseAuthErrorCodes.googleSignInAborted,
        );
      }
      throw const AuthException(
        code: FirebaseAuthErrorCodes.networkRequestFailed,
      );
    } catch (_) {
      throw const AuthException(
        code: FirebaseAuthErrorCodes.networkRequestFailed,
      );
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
