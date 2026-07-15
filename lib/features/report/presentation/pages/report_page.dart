import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/di/injection_container.dart' as di;
import '../cubit/report_cubit.dart';
import '../widgets/report_view.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ReportCubit>(),
      child: const ReportView(),
    );
  }
}
