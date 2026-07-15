import 'package:flutter/material.dart';

class GreenDivider extends StatelessWidget {
  const GreenDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, colorScheme.primary, Colors.transparent],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
