import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/localization/generated/l10n.dart';
import '../../../../core/theme/app_sizes.dart';
import '../cubit/patch_cubit.dart';

class PatchDialog {
  static void showPatchDialog(BuildContext context, int patchNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        icon: Icon(
          Icons.system_update_rounded,
          color: Theme.of(dialogContext).colorScheme.primary,
          size: AppSizes.iconXxl,
        ),
        title: Text(
          S.of(dialogContext).patchDialogTitle,
          textAlign: TextAlign.center,
          style: Theme.of(dialogContext).textTheme.titleLarge,
        ),
        content: Text(
          S.of(dialogContext).patchDialogMessage,
          textAlign: TextAlign.center,
          style: Theme.of(dialogContext).textTheme.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              context.read<PatchCubit>().markCurrentPatchAsSeen(patchNumber);
              Navigator.of(dialogContext).pop();
            },
            child: Text(S.of(dialogContext).patchDialogButton),
          ),
        ],
      ),
    );
  }
}
