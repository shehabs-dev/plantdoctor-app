import 'package:flutter/material.dart';
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
            child: Image.asset('assets/icons/p4_4.png'),
          ),

          SizedBox(height: AppSizes.spaceSm),

          Text("PlantDoctor", style: tt.headlineSmall),

          SizedBox(height: AppSizes.spaceXxs),

          Text("AI Plant Disease Detection", style: tt.labelMedium),
        ],
      ),
    );
  }
}
