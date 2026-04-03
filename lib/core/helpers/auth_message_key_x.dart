import 'package:flutter/widgets.dart';
import '../../config/localization/generated/l10n.dart';
import '../../features/auth/presentation/cubit/auth/auth_message_key.dart';

extension AuthMessageKeyX on AuthMessageKey {
  String tr(BuildContext context) {
    final s = S.of(context);

    return switch (this) {
      AuthMessageKey.server => s.serverError,
      AuthMessageKey.offline => s.offlineError,
      AuthMessageKey.unexpected => s.unexpectedError,
      AuthMessageKey.emailAlreadyInUse => s.emailAlreadyInUse,
      AuthMessageKey.invalidCredential => s.invalidCredential,
      AuthMessageKey.notAuthenticated => s.notAuthenticated,
      AuthMessageKey.signInAborted => s.signInAborted,
      AuthMessageKey.emailNotVerified => s.emailNotVerified,
      AuthMessageKey.tooManyRequests => s.tooManyRequests,
      AuthMessageKey.emailVerificationSent => s.emailVerificationSent,
      AuthMessageKey.passwordResetSent => s.passwordResetSent,
    };
  }
}
