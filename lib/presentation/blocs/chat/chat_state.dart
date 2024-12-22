part of 'chat_bloc.dart';

class ChatState extends Equatable {
  const ChatState({
    required this.messages,
    required this.isLoading,
    required this.isError,
    required this.isSending,
  });

  final List<ChatModel> messages;
  final bool isLoading;
  final bool isError;
  final bool isSending;

  ChatState copyWith(
          {List<ChatModel>? messages,
          bool? isLoading,
          bool? isError,
          bool? isSending}) =>
      ChatState(
          messages: messages ?? this.messages,
          isLoading: isLoading ?? this.isLoading,
          isError: isError ?? this.isError,
          isSending: isSending ?? this.isSending);

  @override
  List<Object> get props => [messages, isLoading, isError, isSending];
}
