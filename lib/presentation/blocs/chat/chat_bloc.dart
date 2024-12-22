import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_gpt/domain/models/chat_model.dart';
import 'package:flutter_chat_gpt/domain/repositories/chat_repository.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this.chatRepository)
      : super(const ChatState(
            messages: [],
            isLoading: false,
            errorMessage: '',
            isSending: true)) {
    on<LoadChats>(_loadChats);

    on<SendConversation>(_sendConversation);
    on<ResendLast>(_resendLastConversation);

    add(LoadChats());
  }

  final ChatRepository chatRepository;

  void _loadChats(LoadChats event, Emitter<ChatState> emit) {
    final List<ChatModel> messages = chatRepository.loadSavedChats();
    emit(state.copyWith(messages: messages, isSending: false));
  }

  Future<void> _sendConversation(
      SendConversation event, Emitter<ChatState> emit) async {
    final chatModel = ChatModel(message: event.question, user: User.human);
    emit(state.copyWith(
        messages: [...state.messages, chatModel],
        isSending: true,
        errorMessage: ''));
    await sendMessageToAPI(event.question, event.modelId, emit);
  }

  Future<void> sendMessageToAPI(
      String question, String modelId, Emitter<ChatState> emit) async {
    try {
      final aiResponse = await chatRepository.sendChat(question, modelId);
      emit(state.copyWith(
          messages: [...state.messages, aiResponse],
          isSending: false,
          errorMessage: ''));
    } on HttpException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(isSending: false, errorMessage: e.message));
    }
  }

  Future<void> _resendLastConversation(
      ResendLast event, Emitter<ChatState> emit) async {
    final lastUserMessage = state.messages.last.message;
    emit(state.copyWith(isSending: true, errorMessage: ''));
    await sendMessageToAPI(lastUserMessage, event.modelId, emit);
  }
}
