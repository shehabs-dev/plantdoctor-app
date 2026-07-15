import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/chat/presentation/pages/history_chat_page.dart';
import '../../features/ministry/presentation/pages/ministry_page.dart';
import '../../features/patch_update/presentation/cubit/patch_cubit.dart';
import '../../features/patch_update/presentation/widgets/patch_dialog.dart';
import '../../features/report/presentation/pages/report_page.dart';
import '../localization/generated/l10n.dart';
import '../routes/route_names.dart';
import '../../core/widgets/app_drawer.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatchCubit, PatchState>(
      listener: (context, state) {
        if (state is PatchAvailable) {
          PatchDialog.showPatchDialog(context, state.patchNumber);
        }
      },
      child: SafeArea(
        child: Scaffold(
          drawer: const AppDrawer(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.pushNamed(RoutesName.chat),
            child: const Icon(Icons.add_comment_rounded),
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: const [HistoryChatPage(), ReportPage(), MinistryPage()],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.chat_bubble_outline),
                selectedIcon: const Icon(Icons.chat_bubble),
                label: S.of(context).assistant,
              ),
              NavigationDestination(
                icon: const Icon(Icons.report_gmailerrorred_outlined),
                selectedIcon: const Icon(Icons.report_gmailerrorred),
                label: S.of(context).report,
              ),
              NavigationDestination(
                icon: const Icon(Icons.account_balance_outlined),
                selectedIcon: const Icon(Icons.account_balance),
                label: S.of(context).ministry,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
