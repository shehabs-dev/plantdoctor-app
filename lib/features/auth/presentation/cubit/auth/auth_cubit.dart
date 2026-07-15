import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/helpers/failure_x.dart';
import '../../../../../core/services/notifications/notification_service.dart';
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
import '../../../../../core/helpers/error_message_key.dart';
import '../../../domain/usecases/update_picture_usecase.dart';

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
  final UpdatePictureUsecase _updatePictureUsecase;

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
    required UpdatePictureUsecase updatePictureUsecase,
  }) : _updatePictureUsecase = updatePictureUsecase,
       _getCachedUserUsecase = getCachedUserUsecase,
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
      if (state.isLoading(AuthAction.googleSignIn)) return;
      result.fold((failure) => emit(Unauthenticated()), (user) async {
        if (user == null) {
          emit(Unauthenticated());
          return;
        }

        final userDataResult = await _getUserDataUsecase(user.id!);
        userDataResult.fold(
          (failure) {
            if (failure is OfflineFailure) {
              return; //  offline — keep cache state
            }

            emit(Unauthenticated()); // only emit unauth for real failures
          },
          (userData) async {
            if (user.isEmailVerified) {
              await _handleNotificationSubscription(userData);
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
    result.fold((failure) => emit(AuthError(failure.toKey())), (user) async {
      if (user.isEmailVerified) {
        await _handleNotificationSubscription(user);
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
    result.fold((failure) => emit(AuthError(failure.toKey())), (user) async {
      _sendEmailVerificationUsecase();
      emit(UnverifiedEmail(user));
    });
  }

  Future<void> signInWithProvider({required AppAuthProvider provider}) async {
    final result = await _signInWithProviderUsecase(
      provider,
      onAccountSelected: () =>
          emit(AuthLoading(action: AuthAction.googleSignIn)),
    );

    result.fold(
      (failure) {
        if (failure is SignInAbortedFailure) {
          emit(Unauthenticated());
        } else {
          emit(AuthError(failure.toKey()));
        }
      },
      (user) async {
        await _handleNotificationSubscription(user);
        emit(Authenticated(user));
      },
    );
  }

  Future<void> signOut() async {
    emit(AuthLoading(action: AuthAction.signOut));
    final result = await _signOutUsecase();
    result.fold((failure) => emit(AuthError(failure.toKey())), (_) async {
      await NotificationService.instance.unsubscribeFromAllTopics();
      emit(Unauthenticated());
    });
  }

  Future<void> sendEmailVerification() async {
    if (state is! UnverifiedEmail) return;
    final currentUser = (state as UnverifiedEmail).user;

    emit(AuthLoading(action: AuthAction.sendVerification));

    final result = await _sendEmailVerificationUsecase();

    result.fold(
      (failure) =>
          emit(UnverifiedEmail(currentUser, messageKey: failure.toKey())),
      (_) => emit(
        UnverifiedEmail(
          currentUser,
          messageKey: ErrorMessageKey.emailVerificationSent,
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
      (failure) =>
          emit(UnverifiedEmail(currentUser, messageKey: failure.toKey())),
      (isVerified) {
        if (isVerified) {
          emit(Authenticated(currentUser));
        } else {
          emit(
            UnverifiedEmail(
              currentUser,
              messageKey: ErrorMessageKey.emailNotVerified,
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
      (failure) => emit(AuthError(failure.toKey())),
      (_) => emit(PasswordResetSent()),
    );
  }

  // ─── Profile ───────────────────────────────────────────────────────────────

  Future<void> updatePicture(File image) async {
    if (state is! Authenticated) return;
    final currentUser = (state as Authenticated).user;

    emit(AuthLoading(action: AuthAction.updatePicture));

    final result =
        await _updatePictureUsecase(
          userId: currentUser.id!,
          image: image,
        ).timeout(
          const Duration(seconds: 5),
          onTimeout: () => left(OfflineFailure()),
        );

    result.fold(
      (failure) =>
          emit(Authenticated(currentUser, pictureError: failure.toKey())),
      (updatedUser) => emit(Authenticated(updatedUser)),
    );
  }

  // ─── Failure Mapper ────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}

// ─── Notification Subscriptions ─────────────────────────────────
Future<void> _handleNotificationSubscription(UserEntity user) async {
  // ── Every user gets this — always subscribe to all_users ────────────────
  await NotificationService.instance.subscribeToTopic(NotificationTopics.all);
}
