import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/localization/generated/l10n.dart';
import '../../../../core/helpers/error_message_key_x.dart';
import '../../../../core/theme/app_sizes.dart';
import '../cubit/auth/auth_cubit.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _canResend = true;
  int _countdown = 0;
  Timer? _timer;
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthCubit>().state;
    if (state is UnverifiedEmail) {
      _userEmail = state.user.email;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _canResend = false;
      _countdown = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
        if (mounted) setState(() => _canResend = true);
      } else {
        if (mounted) setState(() => _countdown--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state is UnverifiedEmail && state.messageKey?.tr(context) != null) {
          messenger
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(content: Text(state.messageKey!.tr(context))),
            );

          if (state.messageKey?.tr(context) ==
              S.of(context).emailVerificationSent) {
            _startCountdown();
          }
        }
      },
      builder: (context, state) {
        final isSending = state.isLoading(AuthAction.sendVerification);
        final isChecking = state.isLoading(AuthAction.checkVerification);

        return Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.screenPaddingH,
                vertical: AppSizes.screenPaddingV,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mark_email_read_rounded, size: AppSizes.avatarXl),
                  SizedBox(height: AppSizes.spaceLg),
                  Text(
                    S.of(context).verificationEmailSentTo(_userEmail),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: AppSizes.spaceXl),
                  ElevatedButton.icon(
                    onPressed: (!_canResend || isSending)
                        ? null
                        : () =>
                              context.read<AuthCubit>().sendEmailVerification(),
                    icon: isSending
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                    label: Text(
                      isSending
                          ? S.of(context).sending
                          : _canResend
                          ? S.of(context).resendEmail
                          : S.of(context).waitToResend(_countdown),
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceLg),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<AuthCubit>().checkEmailVerification(),
                    icon: isChecking
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_circle_outline),
                    label: Text(S.of(context).iVerifiedMyEmail),
                  ),
                  SizedBox(height: AppSizes.spaceXl),
                  TextButton.icon(
                    onPressed: () => context.read<AuthCubit>().signOut(),
                    icon: const Icon(Icons.logout),
                    label: Text(S.of(context).signOut),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
