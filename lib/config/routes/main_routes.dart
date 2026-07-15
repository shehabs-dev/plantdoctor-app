import 'package:go_router/go_router.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/chat/presentation/pages/history_chat_page.dart';
import '../../features/ministry/presentation/pages/ministry_page.dart';
import '../../features/report/presentation/pages/report_page.dart';
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
        RouteTransitions.noTransition(const HistoryChatPage(), state),
  ),
  GoRoute(
    path: RoutesPath.report,
    name: RoutesName.report,
    pageBuilder: (_, state) =>
        RouteTransitions.noTransition(const ReportPage(), state),
  ),
  GoRoute(
    path: RoutesPath.ministry,
    name: RoutesName.ministry,
    pageBuilder: (_, state) =>
        RouteTransitions.noTransition(const MinistryPage(), state),
  ),

  GoRoute(
    path: RoutesPath.chat,
    name: RoutesName.chat,
    pageBuilder: (_, state) {
      // extra is passed when opening an existing chat from history
      // null extra means new chat
      final extra = state.extra as Map<String, String?>?;
      return RouteTransitions.sharedAxisHorizontal(
        ChatPage(chatId: extra?['chatId'], chatTitle: extra?['chatTitle']),
        state,
      );
    },
  ),
];
