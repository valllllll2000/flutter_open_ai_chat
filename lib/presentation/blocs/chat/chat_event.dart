part of 'chat_bloc.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class LoadChats extends ChatEvent {}

class SendConversation extends ChatEvent {
  final String question;
  final String modelId;

  SendConversation(this.question, this.modelId);
}

class ResendLast extends ChatEvent {
  final String modelId;

  ResendLast(this.modelId);
}
