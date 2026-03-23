import '../errors/failures.dart';
import '../errors/firebase_auth_error_codes.dart';

// auth_failure_mapper.dart
class AuthFailureMapper {
  AuthFailureMapper._();

  static Failure fromFirebaseCode(String code) {
    return switch (code) {
      FirebaseAuthErrorCodes.emailAlreadyInUse => EmailAlreadyInUseFailure(),
      FirebaseAuthErrorCodes.noCurrentUser => NotAuthenticatedFailure(),
      FirebaseAuthErrorCodes.googleSignInAborted => SignInAbortedFailure(),
      FirebaseAuthErrorCodes.invalidCredential => InvalidCredentialFailure(),
      FirebaseAuthErrorCodes.networkRequestFailed => OfflineFailure(),
      FirebaseAuthErrorCodes.emailNotVerified => EmailNotVerifiedFailure(),
      FirebaseAuthErrorCodes.tooManyRequests => TooManyRequestsFailure(),
      _ => ServerFailure(),
    };
  }
}
