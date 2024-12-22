import 'package:flutter_chat_gpt/constants/constants.dart';

import '../../domain/datasources/model_datasource.dart';

class ModelDatasourceLocal extends ModelDatasource {
  @override
  Future<List<String>> getModels() async {
    return models;
  }
}
