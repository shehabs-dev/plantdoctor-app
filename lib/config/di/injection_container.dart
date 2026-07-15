import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import '../../core/config/env_config.dart';
import '../../core/services/app_orchestrator.dart';
import '../../core/services/location/location_helper.dart';
import '../../core/services/location/location_service.dart';
import '../../core/services/storage/hive_encryption_service.dart';
import '../../core/services/storage/local_image_storage_service.dart';
import '../../core/services/token/token_provider.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/providers/google_sign_in_provider.dart';
import '../../features/auth/data/datasources/user_local_data_source.dart';
import '../../features/auth/data/datasources/user_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/repository.dart';
import '../../features/auth/domain/usecases/auth_state_changes_usecase.dart';
import '../../features/auth/domain/usecases/get_cached_user_usecase.dart';
import '../../features/auth/domain/usecases/get_user_data_usecase.dart';
import '../../features/auth/domain/usecases/is_email_verified_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usercase.dart';
import '../../features/auth/domain/usecases/send_email_verification_usecase.dart';
import '../../features/auth/domain/usecases/set_user_data_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_with_provider_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/auth/domain/usecases/update_picture_usecase.dart';
import '../../features/auth/presentation/cubit/auth/auth_cubit.dart';
import '../../features/chat/data/datasources/auto_report_local_data_source.dart';
import '../../features/chat/data/datasources/auto_report_remote_data_source.dart';
import '../../features/chat/data/datasources/chat_local_data_source.dart';
import '../../features/chat/data/datasources/chat_remote_data_source.dart';
import '../../features/chat/data/datasources/cloudinary_data_source.dart';
import '../../features/chat/data/datasources/rag_data_source.dart';
import '../../features/chat/data/datasources/tflite_data_source.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/classify_image_usecase.dart';
import '../../features/chat/domain/usecases/clear_chat_cache_usecase.dart';
import '../../features/chat/domain/usecases/create_chat_usecase.dart';
import '../../features/chat/domain/usecases/delete_chat_usecase.dart';
import '../../features/chat/domain/usecases/get_cached_chats_usecase.dart';
import '../../features/chat/domain/usecases/get_cached_messages_usecase.dart';
import '../../features/chat/domain/usecases/get_chats_usecase.dart';
import '../../features/chat/domain/usecases/get_messages_usecase.dart';
import '../../features/chat/domain/usecases/preload_chat_data_usecase.dart';
import '../../features/chat/domain/usecases/save_report_usecase.dart';
import '../../features/chat/domain/usecases/send_message_usecase.dart';
import '../../features/chat/domain/usecases/send_to_rag_usecase.dart';
import '../../features/chat/domain/usecases/sync_pending_messages_usecase.dart';
import '../../features/chat/domain/usecases/sync_pending_reports_usecase.dart';
import '../../features/chat/domain/usecases/upload_image_usecase.dart';
import '../../features/chat/presentation/cubit/chat/chat_cubit.dart';
import '../../features/network_system/data/datasources/connectivity_service.dart';
import '../../features/network_system/data/repositories/network_info_impl.dart';
import '../../features/network_system/domain/repositories/network_info.dart';
import '../../features/network_system/presentation/cubit/connectivity/connectivity_cubit.dart';
import '../../features/patch_update/data/datasources/patch_local_data_source.dart';
import '../../features/patch_update/data/datasources/patch_remote_data_source.dart';
import '../../features/patch_update/data/repositories/patch_repository_impl.dart';
import '../../features/patch_update/domain/repositories/patch_repository.dart';
import '../../features/patch_update/domain/usecases/check_for_new_patch_usecase.dart';
import '../../features/patch_update/domain/usecases/mark_patch_seen_usecase.dart';
import '../../features/patch_update/presentation/cubit/patch_cubit.dart';
import '../../features/report/data/datasources/report_cloudinary_data_source.dart';
import '../../features/report/data/datasources/report_local_data_source.dart';
import '../../features/report/data/datasources/report_remote_data_source.dart';
import '../../features/report/data/repositories/report_repository_impl.dart';
import '../../features/report/domain/repositories/report_repository.dart';
import '../../features/report/domain/usecases/get_pending_reports_usecase.dart';
import '../../features/report/domain/usecases/submit_report_usecase.dart';
import '../../features/report/domain/usecases/sync_reports_usecase.dart';
import '../../features/report/domain/usecases/upload_report_image_usecase.dart';
import '../../features/report/presentation/cubit/report_cubit.dart';
import '../../features/settings/presentation/cubit/cubit/settings_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ─── Initialize External/Core ──────────────────────────────────────────────
  const secureStorage = FlutterSecureStorage();
  final encryptionService = HiveEncryptionService(secureStorage);
  final encryptionCipher = await encryptionService.getEncryptionKey();

  final messagesBox = await Hive.openBox<Map<dynamic, dynamic>>(
    'pending_messages',
    encryptionCipher: encryptionCipher,
  );
  final chatsBox = await Hive.openBox<Map<dynamic, dynamic>>(
    'pending_chats',
    encryptionCipher: encryptionCipher,
  );
  final autoReportsBox = await Hive.openBox<Map<dynamic, dynamic>>(
    'auto_reports',
    encryptionCipher: encryptionCipher,
  );
  final reportsBox = await Hive.openBox<Map<dynamic, dynamic>>(
    'reports',
    encryptionCipher: encryptionCipher,
  );
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<Box<Map<dynamic, dynamic>>>(
    () => messagesBox,
    instanceName: 'messages_box',
  );
  sl.registerLazySingleton<Box<Map<dynamic, dynamic>>>(
    () => chatsBox,
    instanceName: 'chats_box',
  );
  sl.registerLazySingleton<Box<Map<dynamic, dynamic>>>(
    () => autoReportsBox,
    instanceName: 'auto_reports_box',
  );
  sl.registerLazySingleton<Box<Map<dynamic, dynamic>>>(
    () => reportsBox,
    instanceName: 'reports_box',
  );
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(
    () => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    ),
  );
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 90),
        sendTimeout: const Duration(seconds: 30),
      ),
    ),
    instanceName: 'rag_dio',
  );

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
      updatePictureUsecase: sl(),
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
  sl.registerLazySingleton(() => UpdatePictureUsecase(sl()));

  // Repository
  sl.registerLazySingleton<Repository>(
    () => AuthRepositoryImpl(
      authDataSource: sl(),
      userDataSource: sl(),
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
    () => UserRemoteDataSourceImpl(
      firestore: sl(),
      dio: sl(),
      cloudinaryCloudName: EnvConfig.cloudinaryCloudName,
      cloudinaryProfilePreset: EnvConfig.cloudinaryProfilePreset,
      cloudinaryProfileFolder: EnvConfig.cloudinaryProfileFolder,
    ),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(prefs: sl()),
  );
  sl.registerLazySingleton(() => GoogleSignInProvider(googleSignIn: sl()));

  // ─── Features - Chat ───────────────────────────────────────────────────────

  // Cubits
  sl.registerLazySingleton(
    () => ConnectivityCubit(
      sl<ConnectivityService>(),
      sl<NetworkInfo>(),
      sl<SyncPendingReportsUsecase>(),
      sl<SyncPendingMessagesUsecase>(),
      sl<SyncReportsUsecase>(),
    ),
  );

  sl.registerLazySingleton(
    () => ChatCubit(
      createChatUsecase: sl(),
      getChatsUsecase: sl(),
      preloadChatDataUsecase: sl(),
      getCachedChatsUsecase: sl(),
      getCachedMessagesUsecase: sl(),
      deleteChatUsecase: sl(),
      sendMessageUsecase: sl(),
      getMessagesUsecase: sl(),
      classifyImageUsecase: sl(),
      uploadImageUsecase: sl(),
      sendToRagUsecase: sl(),
      saveReportUsecase: sl(),
      syncPendingReportsUsecase: sl(),
      networkInfo: sl(),
      localImageStorageService: sl(),
      locationService: sl(),
    ),
  );

  // Usecases
  sl.registerLazySingleton(() => CreateChatUsecase(sl()));
  sl.registerLazySingleton(() => GetChatsUsecase(sl()));
  sl.registerLazySingleton(() => GetCachedChatsUsecase(sl()));
  sl.registerLazySingleton(() => GetCachedMessagesUsecase(sl()));
  sl.registerLazySingleton(() => DeleteChatUsecase(sl()));
  sl.registerLazySingleton(() => SendMessageUsecase(sl()));
  sl.registerLazySingleton(() => GetMessagesUsecase(sl()));
  sl.registerLazySingleton(() => ClassifyImageUsecase(sl()));
  sl.registerLazySingleton(() => UploadImageUsecase(sl()));
  sl.registerLazySingleton(() => SendToRagUsecase(sl()));
  sl.registerLazySingleton(() => SaveReportUsecase(sl()));
  sl.registerLazySingleton(() => SyncPendingReportsUsecase(sl()));
  sl.registerLazySingleton(() => SyncPendingMessagesUsecase(sl()));
  sl.registerLazySingleton(() => PreloadChatDataUsecase(sl()));
  sl.registerLazySingleton(() => ClearChatCacheUsecase(sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl(),
      reportRemoteDataSource: sl(),
      reportLocalDataSource: sl(),
      tfliteDataSource: sl(),
      cloudinaryDataSource: sl(),
      ragDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
      locationService: sl(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(
      firestore: sl(),
      dio: sl(),
      localImageStorageService: sl(),
    ),
  );
  sl.registerLazySingleton<AutoReportRemoteDataSource>(
    () => AutoReportRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<AutoReportLocalDataSource>(
    () => AutoReportLocalDataSourceImpl(
      box: sl(instanceName: 'auto_reports_box'),
    ),
  );
  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(
      messagesBox: sl(instanceName: 'messages_box'),
      chatsBox: sl(instanceName: 'chats_box'),
    ),
  );
  sl.registerLazySingleton<TFLiteDataSource>(
    () => TFLiteDataSourceImpl(
      labelPath: EnvConfig.tfliteLabelPath,
      fp16ModelPath: EnvConfig.tfliteModelFp16Path,
      int8ModelPath: EnvConfig.tfliteModelInt8Path,
    ),
  );
  sl.registerLazySingleton<CloudinaryDataSource>(
    () => CloudinaryDataSourceImpl(
      dio: sl(),
      cloudName: EnvConfig.cloudinaryCloudName,
      uploadPreset: EnvConfig.cloudinaryDiseasePreset,
      diseaseFolder: EnvConfig.cloudinaryDiseaseFolder,
    ),
  );
  sl.registerLazySingleton<RagDataSource>(
    () => RagDataSourceImpl(
      dio: sl<Dio>(instanceName: 'rag_dio'),
      baseUrl: EnvConfig.ragBaseUrl,
      tokenProvider: sl(),
    ),
  );

  // ─── Features - Report ─────────────────────────────────────────────────────

  sl.registerFactory(
    () => ReportCubit(
      submitReportUsecase: sl(),
      uploadReportImageUsecase: sl(),
      getPendingReportsUsecase: sl(),
      syncReportsUsecase: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => SubmitReportUsecase(sl()));
  sl.registerLazySingleton(() => UploadReportImageUsecase(sl()));
  sl.registerLazySingleton(() => GetPendingReportsUsecase(sl()));
  sl.registerLazySingleton(() => SyncReportsUsecase(sl()));
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      cloudinaryDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<ReportRemoteDataSource>(
    () => ReportRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<ReportLocalDataSource>(
    () => ReportLocalDataSourceImpl(box: sl(instanceName: 'reports_box')),
  );
  sl.registerLazySingleton<ReportCloudinaryDataSource>(
    () => ReportCloudinaryDataSourceImpl(
      dio: sl(),
      cloudinaryCloudName: EnvConfig.cloudinaryCloudName,
      cloudinaryReportPreset: EnvConfig.cloudinaryReportPreset,
      cloudinaryReportFolder: EnvConfig.cloudinaryReportFolder,
    ),
  );

  // ─── Core Services ─────────────────────────────────────────────────────────

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectivity: sl<Connectivity>(),
      dio: sl(),
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton<ConnectivityService>(
    () => ConnectivityServiceImpl(connectivity: sl<Connectivity>()),
  );
  sl.registerLazySingleton<LocationService>(() => LocationServiceImpl());
  sl.registerLazySingleton<LocationHelper>(
    () => LocationHelper(locationService: sl()),
  );
  sl.registerLazySingleton<TokenProvider>(
    () => TokenProviderImpl(firebaseAuth: sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<LocalImageStorageService>(
    () => LocalImageStorageServiceImpl(),
  );
  sl.registerLazySingleton<SettingsCubit>(() => SettingsCubit());

  // ─── Features - Patch ──────────────────────────────────────────────────────

  sl.registerLazySingleton(
    () => PatchCubit(checkForNewPatchUsecase: sl(), markPatchSeenUsecase: sl()),
  );
  sl.registerLazySingleton(() => CheckForNewPatchUsecase(sl()));
  sl.registerLazySingleton(() => MarkPatchSeenUsecase(sl()));
  sl.registerLazySingleton<PatchRepository>(
    () => PatchRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<PatchRemoteDataSource>(
    () => PatchRemoteDataSourceImpl(updater: sl()),
  );
  sl.registerLazySingleton<PatchLocalDataSource>(
    () => PatchLocalDataSourceImpl(prefs: sl()),
  );

  // ─── External ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn.instance);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => ShorebirdUpdater());

  // ─── App Orchestration (Mediator) ──────────────────────────────────────────
  sl.registerLazySingleton(
    () => AppOrchestrator(
      authCubit: sl(),
      preloadChatDataUsecase: sl(),
      clearChatCacheUsecase: sl(),
    ),
  );

  // WARM-UP: Trigger constructors of background services (Mediators)
  sl<AppOrchestrator>();
}
