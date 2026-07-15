import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/di/injection_container.dart' as di;
import '../../../../../config/localization/generated/l10n.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../auth/presentation/cubit/auth/auth_cubit.dart';
import '../../cubit/chat/chat_cubit.dart';

class ChatHistoryEmpty extends StatelessWidget {
  const ChatHistoryEmpty({super.key});

  String _userId() {
    final authState = di.sl<AuthCubit>().state;
    return authState is Authenticated ? authState.user.id ?? '' : '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ChatCubit>().getChats(_userId());
      },
      child: CustomScrollView(
        slivers: [
          // ── App Bar ────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            title: Text(S.of(context).chatHistory),
          ),

          // ── Empty state ────────────────────────────────────────────
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPaddingH.w,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: AppSizes.avatarXxl.r,
                      height: AppSizes.avatarXxl.r,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: AppSizes.iconXl.r,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceMd.h),
                    Text(
                      S.of(context).noChatHistoryYet,
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSizes.spaceXs.h),
                    Text(
                      S.of(context).startAChatToGetPlantCareAdvice,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
