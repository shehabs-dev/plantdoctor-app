import 'package:flutter/material.dart';

class DiagnosisPage extends StatelessWidget {
  const DiagnosisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Diagnosis Page',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
