import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GreenDivider extends StatelessWidget {
  const GreenDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, AppColors.green, Colors.transparent],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
