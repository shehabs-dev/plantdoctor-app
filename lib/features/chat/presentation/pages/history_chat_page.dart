import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/localization/generated/l10n.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../auth/presentation/cubit/auth/auth_cubit.dart';

class HistoryChatPage extends StatelessWidget {
  const HistoryChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(S.of(context).noChatHistoryYet),
          SizedBox(height: AppSizes.spaceMd),
          SizedBox(
            width: 300.w,
            child: ElevatedButton(
              child: Text(S.of(context).signOut),
              onPressed: () => showDialogConfirm(context),
            ),
          ),
        ],
      ),
    );
  }

  void showDialogConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Sign Out'),
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
          ),
        ],
      ),
    );
  }
}
