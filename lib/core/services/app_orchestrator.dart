import 'dart:async';
import '../../features/auth/presentation/cubit/auth/auth_cubit.dart';
import '../../features/chat/domain/usecases/clear_chat_cache_usecase.dart';
import '../../features/chat/domain/usecases/preload_chat_data_usecase.dart';

/// AppOrchestrator (Mediator Pattern)
///
/// This service coordinates cross-feature actions triggered by state changes.
/// This is the "Clean Architecture" way to handle interactions between
/// isolated features (Auth and Chat) without them knowing about each other.
class AppOrchestrator {
  final AuthCubit authCubit;
  final PreloadChatDataUsecase preloadChatDataUsecase;
  final ClearChatCacheUsecase clearChatCacheUsecase;

  StreamSubscription? _authSubscription;

  AppOrchestrator({
    required this.authCubit,
    required this.preloadChatDataUsecase,
    required this.clearChatCacheUsecase,
  }) {
    _init();
  }

  void _init() {
    _authSubscription = authCubit.stream.listen((state) {
      if (state is Authenticated) {
        // Trigger chat preloading silently for the NEW user
        preloadChatDataUsecase(state.user.id!);
      } else if (state is Unauthenticated) {
        // Securely wipe chat history on logout to prevent any data traces
        clearChatCacheUsecase();
      }
    });
  }

  void dispose() {
    _authSubscription?.cancel();
  }
}
