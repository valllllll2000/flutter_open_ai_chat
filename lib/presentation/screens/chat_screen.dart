import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_gpt/constants/constants.dart';
import 'package:flutter_chat_gpt/presentation/blocs/chat/chat_bloc.dart';
import 'package:flutter_chat_gpt/presentation/blocs/model/model_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../services/assets_manager.dart';
import '../widgets/chat_widget.dart';
import '../widgets/model_drop_down.dart';
import '../widgets/text_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ChatBloc>().state;
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state.isError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Open AI failed to respond')),
            );
        }
      },
      child: Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: _ChatAppBar()),
        body: SafeArea(
          child: Column(
            children: [
              const _ChatContentWidget(),
              if (state.isSending) ...[
                SpinKitThreeBounce(
                  color: Colors.blueGrey.shade50,
                  size: 18,
                )
              ],
              const SizedBox(
                height: 16,
              ),
              const _ChatInputWidget()
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatContentWidget extends StatefulWidget {
  const _ChatContentWidget();

  @override
  State<_ChatContentWidget> createState() => _ChatContentWidgetState();
}

class _ChatContentWidgetState extends State<_ChatContentWidget> {
  late ScrollController _controller;

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.animateTo(_controller.position.maxScrollExtent,
            duration: const Duration(microseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<ChatBloc>().state.messages;
    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (previous, current) =>
          previous.messages.length < current.messages.length,
      listener: (context, state) {
        _scrollToEnd();
      },
      child: Flexible(
        child: ListView.builder(
            controller: _controller,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return ChatWidget(
                chat: messages[index],
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class _ChatInputWidget extends StatefulWidget {
  const _ChatInputWidget();

  @override
  State<_ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<_ChatInputWidget> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _sendMessage(BuildContext context, String value) {
    _textController.clear();
    _focusNode.unfocus();
    context.read<ChatBloc>().add(
        SendConversation(value, context.read<ModelBloc>().state.currentModel));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                controller: _textController,
                style: TextStyle(
                  color: Colors.blueGrey.shade50,
                ),
                decoration: const InputDecoration(
                    hintText: 'How can I help you?',
                    hintStyle: TextStyle(color: Colors.grey)),
                onSubmitted: (value) {
                  _sendMessage(context, value);
                },
              ),
            ),
            IconButton(
                onPressed: () {
                  _sendMessage(context, _textController.text);
                },
                icon: Icon(Icons.send, color: Colors.blueGrey.shade50))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class _ChatAppBar extends StatelessWidget {
  const _ChatAppBar();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.watch<ModelBloc>().state;
    return AppBar(
      elevation: 2,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.asset(AssetsManager.openAILogo)),
      ),
      title: const Text('ChatGPT'),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey.shade50,
      ),
      actions: [
        if (!state.isError && !state.isLoading)
          IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  )),
                  backgroundColor: scaffoldBackgroundColor,
                  context: context,
                  builder: (context) {
                    return const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TextWidget(
                              label: 'Chosen Model:',
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(flex: 2, child: ModelDropdown()),
                        ],
                      ),
                    );
                  });
            },
            icon: Icon(
              Icons.more_vert_rounded,
              color: Colors.blueGrey.shade50,
            ),
          )
      ],
    );
  }
}
