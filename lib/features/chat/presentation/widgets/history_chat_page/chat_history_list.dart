import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/di/injection_container.dart' as di;
import '../../../../../config/localization/generated/l10n.dart';
import '../../../../../config/routes/route_names.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../auth/presentation/cubit/auth/auth_cubit.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../cubit/chat/chat_cubit.dart';
import 'chat_history_tile.dart';

class ChatHistoryList extends StatelessWidget {
  const ChatHistoryList({
    super.key,
    required this.chats,
    this.deletingChatId,
  });

  final List<ChatEntity> chats;
  final String? deletingChatId;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final authState = di.sl<AuthCubit>().state;
        final userId = authState is Authenticated
            ? authState.user.id ?? ''
            : '';
        context.read<ChatCubit>().getChats(userId);
      },
      child: CustomScrollView(
        slivers: [
          // ── App Bar ───────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            title: Text(S.of(context).chatHistory),
          ),

          // ── List ──────────────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.screenPaddingHSm,
              vertical: AppSizes.screenPaddingV,
            ),
            sliver: SliverList.separated(
              itemCount: chats.length,
              separatorBuilder: (_, _) => SizedBox(height: AppSizes.spaceXs.h),
              itemBuilder: (context, index) {
                final chat = chats[index];
                final isDeleting = chat.id == deletingChatId;
                return ChatHistoryTile(
                  chat: chat,
                  isDeleting: isDeleting,
                  onTap: isDeleting
                      ? null
                      : () => context.pushNamed(
                          RoutesName.chat,
                          extra: {'chatId': chat.id, 'chatTitle': chat.title},
                        ),
                  onDelete: isDeleting
                      ? null
                      : () => _confirmDelete(context, chat),
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceXxl.h)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ChatEntity chat) {
    final cubit = context.read<ChatCubit>();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(S.of(context).deleteChat),
        content: Text(S.of(context).deleteChatConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              final authState = di.sl<AuthCubit>().state;
              final userId = authState is Authenticated
                  ? authState.user.id ?? ''
                  : '';
              cubit.deleteChat(chatId: chat.id, userId: userId);
            },
            child: Text(
              S.of(context).delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
