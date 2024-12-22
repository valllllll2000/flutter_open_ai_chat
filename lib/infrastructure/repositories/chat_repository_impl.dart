import 'package:flutter_chat_gpt/domain/datasources/chat_datasource.dart';
import 'package:flutter_chat_gpt/domain/models/chat_model.dart';

import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatDatasource datasource;

  ChatRepositoryImpl(this.datasource);

  @override
  List<ChatModel> loadSavedChats() {
    return datasource.loadSavedChats();
  }

  @override
  Future<ChatModel> sendChat(String chat, String modelId) {
    return datasource.sendChat(chat, modelId);
  }
}
