import 'package:go_router/go_router.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/chat/presentation/pages/history_chat_page.dart';
import '../../features/diagnosis/presentation/pages/diagnosis_page.dart';
import '../../features/ministry/presentation/pages/ministry_page.dart';
import '../shell/app_shell.dart';
import 'route_names.dart';
import 'route_transitions.dart';
import 'routes_path.dart';

final mainRoutes = [
  GoRoute(
    path: RoutesPath.appShell,
    name: RoutesName.appShell,
    pageBuilder: (_, state) =>
        RouteTransitions.slideFade(const AppShell(), state),
  ),
  GoRoute(
    path: RoutesPath.historyChat,
    name: RoutesName.historyChat,
    pageBuilder: (_, state) =>
        RouteTransitions.slideFromRight(const HistoryChatPage(), state),
  ),
  GoRoute(
    path: RoutesPath.diagnosis,
    name: RoutesName.diagnosis,
    pageBuilder: (_, state) =>
        RouteTransitions.slideFromRight(const DiagnosisPage(), state),
  ),
  GoRoute(
    path: RoutesPath.ministry,
    name: RoutesName.ministry,
    pageBuilder: (_, state) =>
        RouteTransitions.slideFromRight(const MinistryPage(), state),
  ),

  GoRoute(
    path: RoutesPath.chat,
    name: RoutesName.chat,
    pageBuilder: (_, state) =>
        RouteTransitions.slideFade(const ChatPage(), state),
  ),
];
