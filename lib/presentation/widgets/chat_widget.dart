import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_gpt/constants/constants.dart';
import 'package:flutter_chat_gpt/presentation/blocs/chat/chat_bloc.dart';
import 'package:flutter_chat_gpt/presentation/blocs/model/model_bloc.dart';
import 'package:flutter_chat_gpt/presentation/widgets/text_widget.dart';

import '../../domain/models/chat_model.dart';
import '../../services/assets_manager.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.chat, required this.showResend});

  final ChatModel chat;
  final bool showResend;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chat.isFromHuman ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chat.isFromHuman
                      ? AssetsManager.userImage
                      : AssetsManager.botImage,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: chat.isFromHuman
                      ? TextWidget(label: chat.message)
                      : DefaultTextStyle(
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                          child: AnimatedTextKit(
                              totalRepeatCount: 1,
                              displayFullTextOnTap: true,
                              isRepeatingAnimation: false,
                              repeatForever: false,
                              animatedTexts: [
                                TyperAnimatedText(chat.message.trim())
                              ]),
                        ),
                ),
                showResend
                    ? IconButton(
                        onPressed: () {
                          var currentModel =
                              context.read<ModelBloc>().state.currentModel;
                          context
                              .read<ChatBloc>()
                              .add(ResendLast(currentModel));
                        },
                        icon: const Icon(Icons.refresh, color: Colors.red))
                    : const SizedBox.shrink(),
                chat.isFromHuman
                    ? const SizedBox.shrink()
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: Colors.white,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
