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

class Authenticated extends AuthState {
  final UserEntity user;
  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class UnverifiedEmail extends AuthState {
  final UserEntity user;
  final String? message;

  const UnverifiedEmail(this.user, {this.message});
  @override
  List<Object?> get props => [message, user];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class EmailVerificationSent extends AuthState {}

class PasswordResetSent extends AuthState {}

extension AuthStateX on AuthState {
  bool isLoading(AuthAction action) =>
      this is AuthLoading && (this as AuthLoading).action == action;

  bool get isAnyLoading => this is AuthLoading;
}
