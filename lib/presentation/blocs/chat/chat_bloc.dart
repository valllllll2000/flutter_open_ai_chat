import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chat_gpt/domain/models/chat_model.dart';
import 'package:flutter_chat_gpt/domain/repositories/chat_repository.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this.chatRepository)
      : super(const ChatState(
            messages: [], isLoading: false, isError: false, isSending: true)) {
    on<LoadChats>(_loadChats);

    on<SendConversation>(_sendConversation);

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
    emit(state
        .copyWith(messages: [...state.messages, chatModel], isSending: true));
    try {
      final aiResponse =
          await chatRepository.sendChat(event.question, event.modelId);
      emit(state.copyWith(
          messages: [...state.messages, aiResponse], isSending: false));
    } catch (e) {
      print(e);
      emit(state.copyWith(isSending: false, isError: true));
    }
  }
}
