import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_chat_gpt/domain/models/chat_model.dart';

import '../../constants/constants.dart';
import '../../constants/environment.dart';
import '../../domain/datasources/chat_datasource.dart';
import 'package:http/http.dart' as http;

class ChatDatasourceImpl extends ChatDatasource {
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
      final body = jsonEncode({
        "model": modelId,
        "messages": [
          {"role": "system", "content": "You are a helpful assistant."},
          {"role": "user", "content": chat}
        ]
      });
      final response = await http.post(Uri.parse('${baseURL}chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${Environment.API_KEY}'
          },
          body: body);

      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      var error = jsonMap['error'];
      if (error != null) {
        throw HttpException(error['message']);
      }
      List<dynamic> choices = jsonMap['choices'] as List;
      Map<String, dynamic> firstChoice = choices[0] as Map<String, dynamic>;
      Map<String, dynamic> message =
          firstChoice['message'] as Map<String, dynamic>;
      String content = message['content'] as String;
      return ChatModel(message: content, user: User.ai);
    } catch (error) {
      if (kDebugMode) {
        print('sendChatError $error');
      }
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
}
