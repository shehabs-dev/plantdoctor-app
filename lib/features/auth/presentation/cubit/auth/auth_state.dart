part of 'auth_cubit.dart';

enum AuthAction {
  none,
  signIn,
  signUp,
  googleSignIn,
  signOut,
  sendVerification,
  checkVerification,
  resetPassword,
  updatePicture,
}

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final AuthAction action;
  const AuthLoading({required this.action});

  @override
  List<Object?> get props => [action];
}

// Add to AuthState
class Authenticated extends AuthState {
  final UserEntity user;
  final ErrorMessageKey? pictureError;
  const Authenticated(this.user, {this.pictureError});

  @override
  List<Object?> get props => [user, pictureError];
}

class Unauthenticated extends AuthState {}

class UnverifiedEmail extends AuthState {
  final UserEntity user;
  final ErrorMessageKey? messageKey;

  const UnverifiedEmail(this.user, {this.messageKey});

  @override
  List<Object?> get props => [messageKey, user];
}

class AuthError extends AuthState {
  final ErrorMessageKey messageKey;
  const AuthError(this.messageKey);

  @override
  List<Object?> get props => [messageKey];
}

class EmailVerificationSent extends AuthState {}

class PasswordResetSent extends AuthState {}

extension AuthStateX on AuthState {
  bool isLoading(AuthAction action) =>
      this is AuthLoading && (this as AuthLoading).action == action;

  bool get isAnyLoading => this is AuthLoading;
}
