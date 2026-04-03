// app_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/chat/presentation/pages/history_chat_page.dart';
import '../../features/diagnosis/presentation/pages/diagnosis_page.dart';
import '../../features/ministry/presentation/pages/ministry_page.dart';
import '../localization/generated/l10n.dart';
import '../routes/route_names.dart';

class AppShell extends StatefulWidget {
  final int initialIndex;

  const AppShell({super.key, this.initialIndex = 0});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = const [
    HistoryChatPage(),
    DiagnosisPage(),
    MinistryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.chat),
          onPressed: () => context.pushNamed(RoutesName.chat),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) =>
              setState(() => _selectedIndex = index),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble),
              label: S.of(context).assistant,
            ),

            NavigationDestination(
              icon: Icon(Icons.report_gmailerrorred_outlined),
              selectedIcon: Icon(Icons.report_gmailerrorred),
              label: S.of(context).report,
            ),

            NavigationDestination(
              icon: Icon(Icons.account_balance_outlined),
              selectedIcon: Icon(Icons.account_balance),
              label: S.of(context).ministry,
            ),
          ],
        ),
      ),
    );
  }
}
