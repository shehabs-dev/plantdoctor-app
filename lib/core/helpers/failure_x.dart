// core/helpers/failure_x.dart
import '../errors/failures.dart';
import 'error_message_key.dart';

extension FailureX on Failure {
  ErrorMessageKey toKey() {
    return switch (this) {
      ServerFailure() => ErrorMessageKey.server,
      OfflineFailure() => ErrorMessageKey.offline,
      CacheFailure() => ErrorMessageKey.cache,
      OfflinePromptFailure() => ErrorMessageKey.offlinePrompt,
      EmailAlreadyInUseFailure() => ErrorMessageKey.emailAlreadyInUse,
      OfflineDeleteFailure() => ErrorMessageKey.offlineDelete,
      InvalidCredentialFailure() => ErrorMessageKey.invalidCredential,
      NotAuthenticatedFailure() => ErrorMessageKey.notAuthenticated,
      SignInAbortedFailure() => ErrorMessageKey.signInAborted,
      EmailNotVerifiedFailure() => ErrorMessageKey.emailNotVerified,
      TooManyRequestsFailure() => ErrorMessageKey.tooManyRequests,
      ModelFailure() => ErrorMessageKey.errorModel,
      _ => ErrorMessageKey.unexpected,
    };
  }
}
