import 'package:flutter_chat_gpt/domain/models/chat_model.dart';

abstract class ChatRepository {
  List<ChatModel> loadSavedChats();
  Future<ChatModel> sendChat(String chat, String modelId);
}
