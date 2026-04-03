import 'package:flutter/material.dart';
import '../../../../../config/localization/generated/l10n.dart';
import '../../../../../core/assets/app_assets.dart';
import '../../../../../core/theme/app_sizes.dart';

class SignInLogo extends StatelessWidget {
  const SignInLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.all(AppSizes.screenPaddingV),
      child: Column(
        children: [
          Container(
            width: AppSizes.avatarXxl,
            height: AppSizes.avatarXxl,
            decoration: BoxDecoration(),
            child: Image.asset(AppAssets.authLogo),
          ),

          SizedBox(height: AppSizes.spaceSm),

          Text(S.of(context).appName, style: tt.headlineSmall),

          SizedBox(height: AppSizes.spaceXxs),

          Text(S.of(context).appTagline, style: tt.labelMedium),
        ],
      ),
    );
  }
}
