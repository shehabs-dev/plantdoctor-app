import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
import 'route_names.dart';
import 'route_transitions.dart';
import 'routes_path.dart';

final authRoutes = [
  GoRoute(
    path: RoutesPath.signIn,
    name: RoutesName.signIn,
    pageBuilder: (_, state) =>
        RouteTransitions.fadeScale(const SignInPage(), state),
  ),
  GoRoute(
    path: RoutesPath.signUp,
    name: RoutesName.signUp,
    pageBuilder: (_, state) =>
        RouteTransitions.slideFromRight(const SignUpPage(), state),
  ),
  GoRoute(
    path: RoutesPath.verify,
    name: RoutesName.verify,
    pageBuilder: (_, state) =>
        RouteTransitions.slideFromRight(const VerifyEmailPage(), state),
  ),

  GoRoute(
    path: RoutesPath.forgotPassword,
    name: RoutesName.forgotPassword,
    pageBuilder: (_, state) =>
        RouteTransitions.slideFromRight(const ForgotPasswordPage(), state),
  ),

  GoRoute(
    path: RoutesPath.splash,
    name: RoutesName.splash,
    pageBuilder: (_, state) => RouteTransitions.fade(const SplashPage(), state),
    //pageBuilder: (_, state) => const NoTransitionPage(child: SplashPage()),
  ),
];
