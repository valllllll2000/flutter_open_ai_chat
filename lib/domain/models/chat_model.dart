import 'dart:math';

class ChatModel {
  final String message;
  final User user;

  ChatModel({required this.message, required this.user});

  bool get isFromHuman => user == User.human;

  bool get isFromAI => user == User.ai;

  @override
  String toString() {
    int last = min(message.length, 5);
    return '''
    { ChatModel: message: ${message.substring(0, last)}, user: $user }
    ''';
  }
}

enum User { ai, human }
