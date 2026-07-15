import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../config/routes/routes_path.dart';
import '../../../../core/helpers/error_message_key_x.dart';
import '../../../auth/presentation/cubit/auth/auth_cubit.dart';
import '../cubit/chat/chat_cubit.dart';
import '../widgets/history_chat_page/chat_history_empty.dart';
import '../widgets/history_chat_page/chat_history_list.dart';
import '../widgets/history_chat_page/chat_history_loading.dart';

class HistoryChatPage extends StatefulWidget {
  const HistoryChatPage({super.key});

  @override
  State<HistoryChatPage> createState() => _HistoryChatPageState();
}

class _HistoryChatPageState extends State<HistoryChatPage> {
  @override
  void initState() {
    super.initState();
    // Trigger initial fetch using the global instance
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<ChatCubit>().getChats(authState.user.id ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      buildWhen: (previous, current) {
        // Only rebuild this list for chat-list related states.
        // We ignore ChatInitial to prevent infinite loading on back navigation.
        return current is ChatsLoaded ||
            (current is ChatLoading &&
                current.action == ChatAction.loadingChats);
      },
      listener: (context, state) {
        if (state is ChatError &&
            GoRouterState.of(context).uri.path != RoutesPath.chat) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.key.tr(context))));
        }
      },
      builder: (context, state) {
        // 1. Initial or First-time Loading
        if (state is ChatInitial ||
            (state is ChatLoading && state.isFirstTime)) {
          return const ChatHistoryLoading();
        }

        // 2. Loaded State (Cache or Remote)
        if (state is ChatsLoaded) {
          if (state.chats.isEmpty &&
              !state.isRefreshing &&
              !state.isFromCache) {
            return const ChatHistoryEmpty();
          }

          return Skeletonizer(
            enabled: state.isRefreshing,
            child: ChatHistoryList(
              chats: state.chats,
              deletingChatId: state.deletingChatId,
            ),
          );
        }

        // Fallback (e.g. deleting state)
        if (state is ChatLoading) {
          return const ChatHistoryLoading();
        }

        return const SizedBox.shrink();
      },
    );
  }
}
