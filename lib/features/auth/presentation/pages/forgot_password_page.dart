import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantdoctor/core/constants/success_messages.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../cubit/auth/auth_cubit.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isCountingDown = false;
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _isCountingDown = true;
      _secondsRemaining = 30;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        if (mounted) setState(() => _isCountingDown = false);
      } else {
        if (mounted) setState(() => _secondsRemaining--);
      }
    });
  }

  void _sendResetLink() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().resetPassword(
      email: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);

        if (state is AuthError) {
          messenger
            ..clearSnackBars() // prevent multiple snack bar
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is PasswordResetSent && !_isCountingDown) {
          messenger
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(content: Text(SuccessMessages.passwordResetSent)),
            );

          _startCountdown();
        }
      },
      builder: (context, state) {
        final isLoading = state.isLoading(AuthAction.resetPassword);
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.lock_reset_rounded, size: AppSizes.avatarXl),
                  SizedBox(height: AppSizes.spaceMd),
                  Text(
                    'Forgot your password?',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSizes.spaceXs),
                  Text(
                    'Enter your email address and we will send you a link to reset your password.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: AppSizes.spaceXl),
                  AppTextFormField(
                    controller: _emailController,
                    label: 'Email Address',
                    fieldType: FieldType.email,
                  ),
                  SizedBox(height: AppSizes.spaceLg),
                  ElevatedButton(
                    onPressed: (isLoading || _isCountingDown)
                        ? null
                        : _sendResetLink,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : _isCountingDown
                        ? Text('Resend in $_secondsRemaining s')
                        : const Text('Send Reset Link'),
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
