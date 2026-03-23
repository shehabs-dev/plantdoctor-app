// error_messages.dart
class ErrorMessages {
  ErrorMessages._();

  static const String server =
      "We're having trouble connecting to the server. Please try again.";
  static const String offline =
      "You're offline. Please check your internet connection.";
  static const String unexpected = "Something went wrong. Please try again.";
  static const String emailAlreadyInUse =
      'An account with this email already exists.';
  static const String invalidCredential = 'Invalid email or password.';
  static const String notAuthenticated =
      'No account found with this email. Please sign up first.';
  static const String signInAborted = 'Sign in was cancelled.';
  static const String emailNotVerified =
      'Your email has not been verified yet.';
  static const String passwordResetSent =
      'Password reset email sent! Check your inbox.';

  static const String tooManyRequests =
      'Too many attempts. Please try again later.';
}
