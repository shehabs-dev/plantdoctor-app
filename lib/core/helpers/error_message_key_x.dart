import 'package:flutter/widgets.dart';
import '../../config/localization/generated/l10n.dart';
import 'error_message_key.dart';

extension ErrorMessageKeyX on ErrorMessageKey {
  String tr(BuildContext context) {
    final s = S.of(context);

    return switch (this) {
      ErrorMessageKey.server => s.serverError,
      ErrorMessageKey.offline => s.offlineError,
      ErrorMessageKey.offlineClassificationQueued => s.offlineClassificationQueued,
      ErrorMessageKey.offlinePrompt => s.offlinePromptError,
      ErrorMessageKey.cache => s.cacheError,
      ErrorMessageKey.unexpected => s.unexpectedError,
      ErrorMessageKey.emailAlreadyInUse => s.emailAlreadyInUse,
      ErrorMessageKey.offlineDelete => s.offlineDeleteError,
      ErrorMessageKey.invalidCredential => s.invalidCredential,
      ErrorMessageKey.notAuthenticated => s.notAuthenticated,
      ErrorMessageKey.signInAborted => s.signInAborted,
      ErrorMessageKey.emailNotVerified => s.emailNotVerified,
      ErrorMessageKey.tooManyRequests => s.tooManyRequests,
      ErrorMessageKey.emailVerificationSent => s.emailVerificationSent,
      ErrorMessageKey.passwordResetSent => s.passwordResetSent,
      ErrorMessageKey.errorModel => s.errorModel,
    };
  }
}
