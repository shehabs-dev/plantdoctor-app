import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plantdoctor/config/routes/routes_path.dart';

import '../../features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'go_router_refresh_stream.dart';
import 'auth_routes.dart';
import 'main_routes.dart';
import '../di/injection_container.dart' as di;

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(di.sl<AuthCubit>()),
    initialLocation: RoutesPath.splash,

    redirect: (context, state) {
      final authState = context.read<AuthCubit>().state;

      final isAuthenticated = authState is Authenticated;
      final isUnverified = authState is UnverifiedEmail;
      final isInitial = authState is AuthInitial;

      final isSplash = state.matchedLocation == RoutesPath.splash;

      final isAuthRoute =
          state.matchedLocation == RoutesPath.signIn ||
          state.matchedLocation == RoutesPath.signUp ||
          state.matchedLocation == RoutesPath.forgotPassword;

      // prevent redirect while loading
      if (isInitial) return isSplash ? null : RoutesPath.splash;

      // these actions determine navigation — show splash
      if (authState.isLoading(AuthAction.signOut)) {
        return isSplash ? null : RoutesPath.splash;
      }

      // these actions are in-page — stay put

      if (authState.isLoading(AuthAction.signIn) ||
          authState.isLoading(AuthAction.signUp) ||
          authState.isLoading(AuthAction.sendVerification) ||
          authState.isLoading(AuthAction.checkVerification) ||
          authState.isLoading(AuthAction.googleSignIn) ||
          authState.isLoading(AuthAction.resetPassword)) {
        return null;
      }

      if (!isAuthenticated && !isUnverified) {
        return isAuthRoute ? null : RoutesPath.signIn;
      }

      if (isUnverified) {
        return state.matchedLocation == RoutesPath.verify
            ? null
            : RoutesPath.verify;
      }

      if (isAuthenticated) {
        if (isAuthRoute ||
            state.matchedLocation == RoutesPath.verify ||
            isSplash) {
          return RoutesPath.appShell;
        }
        return null;
      }

      return null;
    },

    routes: [...authRoutes, ...mainRoutes],
  );
}
