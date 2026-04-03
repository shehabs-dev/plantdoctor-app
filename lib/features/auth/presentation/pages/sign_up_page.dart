import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/localization/generated/l10n.dart';
import '../../../../core/helpers/auth_message_key_x.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../cubit/auth/auth_cubit.dart';
import '../widgets/auth_button.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: S.of(context).createAccount),

      body: _SignUpBody(),
    );
  }
}

class _SignUpBody extends StatefulWidget {
  const _SignUpBody();
  @override
  State<_SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<_SignUpBody> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.screenPaddingH,
          vertical: AppSizes.screenPaddingV,
        ),

        child: SingleChildScrollView(
          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).joinPlantDoctor,
                  style: textTheme.headlineSmall,
                ),

                SizedBox(height: AppSizes.spaceSm),

                Text(
                  S.of(context).createAccountDescription,
                  style: textTheme.bodyMedium,
                ),

                SizedBox(height: AppSizes.spaceLg),

                // TextFields
                AppTextFormField(
                  label: S.of(context).fullName,
                  controller: _fullNameController,
                  fieldType: FieldType.name,
                ),

                SizedBox(height: AppSizes.spaceMd),

                AppTextFormField(
                  label: S.of(context).email,
                  controller: _emailController,
                  fieldType: FieldType.email,
                ),

                SizedBox(height: AppSizes.spaceMd),

                AppTextFormField(
                  label: S.of(context).password,
                  controller: _passwordController,
                  validateComplexity: true,
                  fieldType: FieldType.password,
                ),

                SizedBox(height: AppSizes.spaceMd),

                AppTextFormField(
                  label: S.of(context).confirmPassword,
                  matchController: _passwordController,
                  fieldType: FieldType.password,
                ),

                SizedBox(height: AppSizes.spaceLg),

                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(
                          SnackBar(content: Text(state.messageKey.tr(context))),
                        );
                    }
                  },
                  builder: (context, state) {
                    return AuthButton(
                      onPressed: state.isLoading(AuthAction.signUp)
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().signUp(
                                  name: _fullNameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                );
                              }
                            },
                      child: state.isLoading(AuthAction.signUp)
                          ? LoadingWidget()
                          : Text(S.of(context).signUp),
                    );
                  },
                ),
                SizedBox(height: AppSizes.spaceXs),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
