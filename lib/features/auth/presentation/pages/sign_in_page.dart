import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/localization/generated/l10n.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/assets/app_assets.dart';
import '../../../../core/helpers/error_message_key_x.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/auth_provider.dart';
import '../cubit/auth/auth_cubit.dart';
import '../widgets/auth_button.dart';
import '../widgets/sign_in_page/or_divider.dart';
import '../widgets/sign_in_page/sign_in_logo.dart';
import '../widgets/sign_in_page/social_login_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _BuildBody());
  }
}

class _BuildBody extends StatefulWidget {
  const _BuildBody();

  @override
  State<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends State<_BuildBody> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: BlocConsumer<AuthCubit, AuthState>(
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
            return Column(
              children: [
                SignInLogo(),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPaddingH,
                  ),

                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).welcomeBack,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),

                        SizedBox(height: AppSizes.spaceMd),

                        // TextFields
                        AppTextFormField(
                          label: S.of(context).email,
                          fieldType: FieldType.email,
                          controller: _emailController,
                          isRequired: true,
                        ),

                        SizedBox(height: AppSizes.spaceMd),

                        AppTextFormField(
                          label: S.of(context).password,
                          fieldType: FieldType.password,
                          controller: _passwordController,
                          isRequired: true,
                        ),

                        SizedBox(height: AppSizes.spaceXs),

                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                            onPressed: () =>
                                context.pushNamed(RoutesName.forgotPassword),
                            child: Text(S.of(context).forgotPassword),
                          ),
                        ),

                        SizedBox(height: AppSizes.spaceSm),

                        AuthButton(
                          onPressed: state.isLoading(AuthAction.signIn)
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    context.read<AuthCubit>().signIn(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    );
                                  }
                                },
                          child: state.isLoading(AuthAction.signIn)
                              ? LoadingWidget()
                              : Text(S.of(context).signIn),
                        ),

                        SizedBox(height: AppSizes.spaceMd),
                        OrDivider(),
                        SizedBox(height: AppSizes.spaceXs),

                        SocialLoginButton(
                          text: S.of(context).signInWithGoogle,
                          icon: Image.asset(AppAssets.googleIcon),
                          onPressed: state.isLoading(AuthAction.googleSignIn)
                              ? null
                              : () => context
                                    .read<AuthCubit>()
                                    .signInWithProvider(
                                      provider: AppAuthProvider.google,
                                    ),
                        ),

                        SizedBox(height: AppSizes.spaceSm),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(S.of(context).dontHaveAnAccount),

                            TextButton(
                              onPressed: () =>
                                  context.pushNamed(RoutesName.signUp),
                              child: Text(S.of(context).signUp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
