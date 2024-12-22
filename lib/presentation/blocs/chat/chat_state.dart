part of 'chat_bloc.dart';

class ChatState extends Equatable {
  const ChatState({
    required this.messages,
    required this.isLoading,
    required this.errorMessage,
    required this.isSending,
  });

  final List<ChatModel> messages;
  final bool isLoading;
  final String errorMessage;
  final bool isSending;

  ChatState copyWith(
          {List<ChatModel>? messages,
          bool? isLoading,
          String? errorMessage,
          bool? isSending}) =>
      ChatState(
          messages: messages ?? this.messages,
          isLoading: isLoading ?? this.isLoading,
          errorMessage: errorMessage ?? this.errorMessage,
          isSending: isSending ?? this.isSending);

  @override
  List<Object> get props => [messages, isLoading, errorMessage, isSending];
}
