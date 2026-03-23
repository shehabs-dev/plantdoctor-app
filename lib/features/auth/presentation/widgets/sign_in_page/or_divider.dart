import 'package:flutter/material.dart';
import '../../../../../core/theme/app_sizes.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceSm),
          child: Text("or"),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}
