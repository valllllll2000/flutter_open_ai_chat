import 'dart:convert';
import 'dart:io';

import 'package:flutter_chat_gpt/constants/constants.dart';

import '../../domain/datasources/model_datasource.dart';
import 'package:flutter_chat_gpt/constants/environment.dart';
import 'package:http/http.dart' as http;

class ModelDatasourceImpl extends ModelDatasource {


  @override
  Future<List<String>> getModels() async {
    try {
      final response = await http.get(Uri.parse('${baseURL}models'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Environment.API_KEY}'
      });
      Map jsonResponse = jsonDecode(response.body);
      var error = jsonResponse['error'];
      if (error != null) {
        throw HttpException(error['message']);
      }
      var data = jsonResponse['data'];
      List<String> models = List<String>.from(data.map((e) => e["id"].toString()));
      return models;
    } catch (error) {
      print('Error $error');
      rethrow;
    }
  }
}
