import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/auth_provider.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/auth_state_changes_usecase.dart';
import '../../../domain/usecases/get_cached_user_usecase.dart';
import '../../../domain/usecases/get_user_data_usecase.dart';
import '../../../domain/usecases/is_email_verified_usecase.dart';
import '../../../domain/usecases/reset_password_usercase.dart';
import '../../../domain/usecases/send_email_verification_usecase.dart';
import '../../../domain/usecases/sign_in_usecase.dart';
import '../../../domain/usecases/sign_in_with_provider_usecase.dart';
import '../../../domain/usecases/sign_out_usecase.dart';
import '../../../domain/usecases/sign_up_usecase.dart';
import 'auth_message_key.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthStateChangesUsecase _authStateChangesUsecase;
  final GetUserDataUsecase _getUserDataUsecase;
  final IsEmailVerifiedUsecase _isEmailVerifiedUsecase;
  final ResetPasswordUsercase _resetPasswordUsecase;
  final SendEmailVerificationUsecase _sendEmailVerificationUsecase;
  final SignInUsecase _signInUsecase;
  final SignInWithProviderUsecase _signInWithProviderUsecase;
  final GetCachedUserUsecase _getCachedUserUsecase;
  final SignOutUsecase _signOutUsecase;
  final SignUpUsecase _signUpUsecase;

  late final StreamSubscription _authSubscription;

  AuthCubit({
    required IsEmailVerifiedUsecase isEmailVerifiedUsecase,
    required ResetPasswordUsercase resetPasswordUsecase,
    required SendEmailVerificationUsecase sendEmailVerificationUsecase,
    required SignInUsecase signInUsecase,
    required SignInWithProviderUsecase signInWithProviderUsecase,
    required SignOutUsecase signOutUsecase,
    required SignUpUsecase signUpUsecase,
    required AuthStateChangesUsecase authStateChangesUsecase,
    required GetUserDataUsecase getUserDataUsecase,
    required GetCachedUserUsecase getCachedUserUsecase,
  }) : _getCachedUserUsecase = getCachedUserUsecase,
       _authStateChangesUsecase = authStateChangesUsecase,
       _getUserDataUsecase = getUserDataUsecase,
       _isEmailVerifiedUsecase = isEmailVerifiedUsecase,
       _resetPasswordUsecase = resetPasswordUsecase,
       _sendEmailVerificationUsecase = sendEmailVerificationUsecase,
       _signInUsecase = signInUsecase,
       _signInWithProviderUsecase = signInWithProviderUsecase,
       _signOutUsecase = signOutUsecase,
       _signUpUsecase = signUpUsecase,

       super(AuthInitial()) {
    _checkCachedUser();
    _stream();
  }

  // ─── Session Restore ───────────────────────────────────────────────────────

  // online: listens to Firebase auth state changes
  void _stream() {
    _authSubscription = _authStateChangesUsecase().listen((result) {
      result.fold((failure) => emit(Unauthenticated()), (user) async {
        if (user == null) {
          emit(Unauthenticated());
          return;
        }

        final userDataResult = await _getUserDataUsecase(user.id!);
        userDataResult.fold(
          (failure) {
            if (failure is OfflineFailure) {
              return; // ✅ offline — keep cache state
            }

            emit(Unauthenticated()); // only emit unauth for real failures
          },
          (userData) {
            if (user.isEmailVerified) {
              emit(Authenticated(userData));
            } else {
              emit(UnverifiedEmail(userData));
            }
          },
        );
      });
    });
  }

  // offline: restores session from local cache
  Future<void> _checkCachedUser() async {
    final cached = await _getCachedUserUsecase();
    if (cached == null) return;
    if (cached.isEmailVerified) {
      emit(Authenticated(cached));
    } else {
      emit(UnverifiedEmail(cached));
    }
  }
  // ─── Authentication ────────────────────────────────────────────────────────

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading(action: AuthAction.signIn));
    final result = await _signInUsecase(email, password);
    result.fold((failure) => emit(AuthError(mapFailureToMessageKey(failure))), (
      user,
    ) {
      if (user.isEmailVerified) {
        emit(Authenticated(user));
      } else {
        emit(UnverifiedEmail(user));
      }
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(AuthLoading(action: AuthAction.signUp));
    final result = await _signUpUsecase(email, password, name);
    result.fold((failure) => emit(AuthError(mapFailureToMessageKey(failure))), (
      user,
    ) async {
      _sendEmailVerificationUsecase();
      emit(UnverifiedEmail(user));
    });
  }

  Future<void> signInWithProvider({required AppAuthProvider provider}) async {
    emit(AuthLoading(action: AuthAction.googleSignIn));
    final result = await _signInWithProviderUsecase(provider);
    result.fold((failure) {
      if (failure is SignInAbortedFailure) {
        emit(Unauthenticated());
      } else {
        emit(AuthError(mapFailureToMessageKey(failure)));
      }
    }, (user) => emit(Authenticated(user)));
  }

  Future<void> signOut() async {
    emit(AuthLoading(action: AuthAction.signOut));
    final result = await _signOutUsecase();
    result.fold(
      (failure) => emit(AuthError(mapFailureToMessageKey(failure))),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> sendEmailVerification() async {
    if (state is! UnverifiedEmail) return;
    final currentUser = (state as UnverifiedEmail).user;

    emit(AuthLoading(action: AuthAction.sendVerification));

    final result = await _sendEmailVerificationUsecase();

    result.fold(
      (failure) => emit(
        UnverifiedEmail(
          currentUser,
          messageKey: mapFailureToMessageKey(failure),
        ),
      ),
      (_) => emit(
        UnverifiedEmail(
          currentUser,
          messageKey: AuthMessageKey.emailVerificationSent,
        ),
      ),
    );
  }

  Future<void> checkEmailVerification() async {
    if (state is! UnverifiedEmail) return;
    final currentUser = (state as UnverifiedEmail).user;

    emit(AuthLoading(action: AuthAction.checkVerification));

    final result = await _isEmailVerifiedUsecase();

    result.fold(
      (failure) => emit(
        UnverifiedEmail(
          currentUser,
          messageKey: mapFailureToMessageKey(failure),
        ),
      ),
      (isVerified) {
        if (isVerified) {
          emit(Authenticated(currentUser));
        } else {
          emit(
            UnverifiedEmail(
              currentUser,
              messageKey: AuthMessageKey.emailNotVerified,
            ),
          );
        }
      },
    );
  }

  Future<void> resetPassword({required String email}) async {
    emit(AuthLoading(action: AuthAction.resetPassword));
    final result = await _resetPasswordUsecase(email);
    result.fold(
      (failure) => emit(AuthError(mapFailureToMessageKey(failure))),
      (_) => emit(PasswordResetSent()),
    );
  }

  // ─── Failure Mapper ────────────────────────────────────────────────────────

  AuthMessageKey mapFailureToMessageKey(Failure failure) {
    return switch (failure) {
      ServerFailure() => AuthMessageKey.server,
      OfflineFailure() => AuthMessageKey.offline,
      EmailAlreadyInUseFailure() => AuthMessageKey.emailAlreadyInUse,
      InvalidCredentialFailure() => AuthMessageKey.invalidCredential,
      NotAuthenticatedFailure() => AuthMessageKey.notAuthenticated,
      SignInAbortedFailure() => AuthMessageKey.signInAborted,
      EmailNotVerifiedFailure() => AuthMessageKey.emailNotVerified,
      TooManyRequestsFailure() => AuthMessageKey.tooManyRequests,
      _ => AuthMessageKey.unexpected,
    };
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
