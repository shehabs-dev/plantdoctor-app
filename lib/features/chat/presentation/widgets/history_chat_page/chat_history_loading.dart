import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../config/localization/generated/l10n.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../domain/entities/chat_entity.dart';
import 'chat_history_tile.dart';

class ChatHistoryLoading extends StatelessWidget {
  const ChatHistoryLoading({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate dummy chats for the skeleton
    final dummyChats = List.generate(
      8,
      (index) => ChatEntity(
        id: index.toString(),
        userId: '1',
        title: 'Loading chat history...',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isSynced: true,
      ),
    );

    return Skeletonizer(
      enabled: true,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // ── App Bar ─────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: null,
            ),
            title: Text(S.of(context).chatHistory),
          ),

          // ── Skeleton tiles ───────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.screenPaddingHSm,
              vertical: AppSizes.screenPaddingV,
            ),
            sliver: SliverList.separated(
              itemCount: dummyChats.length,
              separatorBuilder: (_, _) => SizedBox(height: AppSizes.spaceXs.h),
              itemBuilder: (_, index) => ChatHistoryTile(
                chat: dummyChats[index],
                onTap: () {},
                onDelete: () {},
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceXxl.h)),
        ],
      ),
    );
  }
}
