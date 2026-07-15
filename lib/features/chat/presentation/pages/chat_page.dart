import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/di/injection_container.dart' as di;
import '../../../../config/localization/generated/l10n.dart';
import '../../../../core/services/location/location_helper.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../auth/presentation/cubit/auth/auth_cubit.dart';
import '../cubit/chat/chat_cubit.dart';
import '../widgets/chat_page/chat_view.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, this.chatId, this.chatTitle});

  final String? chatId;
  final String? chatTitle;

  void _refreshChatHistory(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      context.read<ChatCubit>().getChats(authState.user.id ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Trigger loading messages if we are opening an existing chat
    if (chatId != null) {
      context.read<ChatCubit>().getMessages(chatId!);
    } else {
      context.read<ChatCubit>().resetChat();
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _refreshChatHistory(context);
      },
      child: Scaffold(
        appBar: buildAppBar(
          context,
          title: chatTitle ?? S.of(context).newChat,
          centerTitle: true,
        ),
        body: ChatView(
          chatId: chatId,
          chatTitle: chatTitle,
          locationHelper: di.sl<LocationHelper>(),
        ),
      ),
    );
  }
}
