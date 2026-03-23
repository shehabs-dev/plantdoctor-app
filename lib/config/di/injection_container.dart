import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:plantdoctor/features/auth/data/datasources/user_local_data_source.dart';
import 'package:plantdoctor/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/network_info.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/providers/google_sign_in_provider.dart';
import '../../features/auth/data/datasources/user_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/repository.dart';
import '../../features/auth/domain/usecases/auth_state_changes_usecase.dart';
import '../../features/auth/domain/usecases/get_user_data_usecase.dart';
import '../../features/auth/domain/usecases/is_email_verified_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usercase.dart';
import '../../features/auth/domain/usecases/send_email_verification_usecase.dart';
import '../../features/auth/domain/usecases/set_user_data_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_with_provider_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/presentation/cubit/auth/auth_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ─── Features - Auth ───────────────────────────────────────────────────────

  // Cubit
  sl.registerLazySingleton(
    () => AuthCubit(
      isEmailVerifiedUsecase: sl(),
      resetPasswordUsecase: sl(),
      sendEmailVerificationUsecase: sl(),
      signInUsecase: sl(),
      signInWithProviderUsecase: sl(),
      signOutUsecase: sl(),
      signUpUsecase: sl(),
      authStateChangesUsecase: sl(),
      getUserDataUsecase: sl(),
      getCachedUserUsecase: sl(),
    ),
  );

  // Usecases
  sl.registerLazySingleton(() => AuthStateChangesUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetUserDataUsecase(repository: sl()));
  sl.registerLazySingleton(() => IsEmailVerifiedUsecase(repository: sl()));
  sl.registerLazySingleton(() => ResetPasswordUsercase(repository: sl()));
  sl.registerLazySingleton(
    () => SendEmailVerificationUsecase(repository: sl()),
  );
  sl.registerLazySingleton(() => SetUserDataUsecase(repository: sl()));
  sl.registerLazySingleton(() => SignInUsecase(repository: sl()));
  sl.registerLazySingleton(() => SignInWithProviderUsecase(repository: sl()));
  sl.registerLazySingleton(() => SignOutUsecase(repository: sl()));
  sl.registerLazySingleton(() => SignUpUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetCachedUserUsecase(repository: sl()));

  // Repository
  sl.registerLazySingleton<Repository>(
    () => AuthRepositoryImpl(
      authDataSource: sl(),
      userDataSource: sl(),
      networkInfo: sl(),
      localDataSource: sl(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => FirebaseAuthRemoteDataSource(
      firebaseAuth: sl(),
      googleSignInProvider: sl(),
    ),
  );

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(prefs: sl()),
  );

  // Providers
  sl.registerLazySingleton(() => GoogleSignInProvider(googleSignIn: sl()));

  // ─── Core ──────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: sl()),
  );

  // ─── External ──────────────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn.instance);
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerLazySingleton(() => sharedPreferences);
}
