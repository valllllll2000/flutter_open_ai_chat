import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/constants/constants.dart';
import 'package:flutter_chat_gpt/presentation/widgets/text_widget.dart';

import '../../domain/models/chat_model.dart';
import '../../services/assets_manager.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.chat});

  final ChatModel chat;

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
                Expanded(child: TextWidget(label: chat.message)),
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
