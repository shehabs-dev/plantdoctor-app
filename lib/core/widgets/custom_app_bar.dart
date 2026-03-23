import 'package:flutter/material.dart';
import '../theme/app_sizes.dart';
import 'green_divider.dart';

AppBar buildAppBar(
  BuildContext context, {
  required String title,
  bool showDivider = true,
  List<Widget>? actions,
  VoidCallback? onBack,
}) {
  return AppBar(
    titleSpacing: AppSizes.spaceSm,
    leading: BackButton(onPressed: onBack ?? () => Navigator.maybePop(context)),
    title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
    elevation: 0,
    centerTitle: false,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    actions: actions,
    bottom: showDivider
        ? const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: GreenDivider(),
          )
        : null,
  );
}
