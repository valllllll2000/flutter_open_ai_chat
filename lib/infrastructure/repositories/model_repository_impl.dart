import 'package:flutter_chat_gpt/domain/datasources/model_datasource.dart';
import 'package:flutter_chat_gpt/domain/repositories/model_repository.dart';

class ModelRepositoryImpl extends ModelRepository {
  final ModelDatasource datasource;

  ModelRepositoryImpl(this.datasource);

  @override
  Future<List<String>> getModels() {
    //TODO: save models to database
    return datasource.getModels();
  }
}
