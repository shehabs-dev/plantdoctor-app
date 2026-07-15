import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/localization/generated/l10n.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/cubit/auth/auth_cubit.dart';
import '../../features/settings/presentation/cubit/cubit/settings_cubit.dart';
import '../theme/app_sizes.dart';
import 'app_avatar.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  // ── Keep last known user so name/email never disappear during loading ──────
  UserEntity? _lastKnownUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      child: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (_, curr) => curr is AuthError,
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.messageKey.name)));
            }
          },
          builder: (context, authState) {
            // ── Preserve user across loading states ────────────────
            if (authState is Authenticated) {
              _lastKnownUser = authState.user;
            }
            final user = _lastKnownUser;
            final isUpdatingPicture = authState.isLoading(
              AuthAction.updatePicture,
            );

            return Column(
              children: [
                // ── Avatar + name + email — centered ──────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceMd.w,
                    vertical: AppSizes.spaceLg.h,
                  ),
                  child: Column(
                    children: [
                      AppAvatar(
                        imageUrl: user?.picture,
                        name: user?.name,
                        size: AppSizes.avatarXl,
                        editable: true,
                        isLoading: isUpdatingPicture,
                        onImagePicked: (file) =>
                            context.read<AuthCubit>().updatePicture(file),
                      ),
                      SizedBox(height: AppSizes.spaceSm.h),
                      Text(
                        user?.name ?? '',
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        user?.email ?? '',
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                Divider(color: colorScheme.outline),

                // ── Settings ──────────────────────────────────────
                BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, settings) {
                    final isDark = settings.themeMode == ThemeMode.dark;
                    final isAr = settings.locale.languageCode == 'ar';

                    return Column(
                      children: [
                        // ── Theme toggle ───────────────────────────
                        ListTile(
                          leading: Icon(
                            isDark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            color: colorScheme.primary,
                          ),
                          title: Text(
                            isDark
                                ? S.of(context).darkMode
                                : S.of(context).lightMode,
                            style: theme.textTheme.bodyLarge,
                          ),
                          trailing: Switch(
                            value: isDark,
                            onChanged: (_) =>
                                context.read<SettingsCubit>().toggleTheme(),
                          ),
                        ),

                        // ── Language selector ──────────────────────
                        ListTile(
                          leading: Icon(
                            Icons.language_rounded,
                            color: colorScheme.primary,
                          ),
                          title: Text(
                            S.of(context).language,
                            style: theme.textTheme.bodyLarge,
                          ),
                          trailing: _LanguageSelector(
                            isAr: isAr,
                            onChanged: (_) =>
                                context.read<SettingsCubit>().toggleLocale(),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const Spacer(),

                Divider(color: colorScheme.outline),

                // ── Logout ────────────────────────────────────────
                ListTile(
                  leading: Icon(Icons.logout_rounded, color: colorScheme.error),
                  title: Text(
                    S.of(context).signOut,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                  onTap: () => _SignOutDialog.show(context),
                ),

                SizedBox(height: AppSizes.spaceSm.h),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SignOutDialog extends StatelessWidget {
  const _SignOutDialog();

  static void show(BuildContext context) {
    showDialog(context: context, builder: (_) => _SignOutDialog());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final s = S.of(context);

    return AlertDialog(
      title: Text(s.signOutConfirmTitle),
      content: Text(s.signOutConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // close dialog
            Navigator.of(context).pop(); // close drawer
            context.read<AuthCubit>().signOut();
          },
          style: TextButton.styleFrom(foregroundColor: colorScheme.error),
          child: Text(s.signOut),
        ),
      ],
    );
  }
}

// ── Language selector dropdown ─────────────────────────────────────────────────

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({required this.isAr, required this.onChanged});

  final bool isAr;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DropdownButtonHideUnderline(
      child: DropdownButton<bool>(
        value: isAr,
        isDense: true,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd.r),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        items: [
          DropdownMenuItem(value: false, child: Text(S.of(context).english)),
          DropdownMenuItem(value: true, child: Text(S.of(context).arabic)),
        ],
        onChanged: (value) {
          if (value != null && value != isAr) onChanged(value);
        },
      ),
    );
  }
}
