import 'dart:convert';

import 'package:flutter_chat_gpt/domain/models/chat_model.dart';

import '../../constants/constants.dart';
import '../../domain/datasources/chat_datasource.dart';
import 'package:flutter/services.dart' show rootBundle;

class ChatDatasourceLocalImpl extends ChatDatasource {
  @override
  List<ChatModel> loadSavedChats() {
    //TODO: save chats to DB
    return chatMessages
        .map((e) => ChatModel(message: _getMessage(e), user: _getUser(e)))
        .toList();
  }

  @override
  Future<ChatModel> sendChat(String chat, String modelId) async {
    try {
      String content = await readJsonAndGetContent();
      return ChatModel(message: content, user: User.ai);
    } catch (error) {
      print('sendChatError $error');
      rethrow;
    }
  }

  String _getMessage(Map<String, Object> map) {
    return map['msg'].toString();
  }

  User _getUser(Map<String, Object> map) {
    final chatIndex = int.parse(map['chatIndex'].toString());
    return chatIndex == 0 ? User.human : User.ai;
  }

  Future<String> readJsonAndGetContent() async {
    final jsonString = await rootBundle.loadString('assets/json/response_arabic.json');
    final jsonMap = jsonDecode(jsonString);
    final choices = jsonMap['choices'] as List;
    final message = choices[0]['message'] as Map<String, dynamic>;
    final content = message['content'] as String;
    return content;
  }
}
