import 'package:flutter_chat_gpt/domain/models/chat_model.dart';
import 'package:flutter_chat_gpt/infrastructure/datasources/chat_datasource_local_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ChatDatasourceLocalImpl', () {
    late ChatDatasourceLocalImpl datasource;

    setUp(() {
      datasource = ChatDatasourceLocalImpl();
    });

    test('sendChat returns a ChatModel with correct content and user', () async {
      final chatModel = await datasource.sendChat('test chat', 'test model');
      expect(chatModel.message, 'Nested calls unfold,  \nEach step mirrors the last,  \nSelf\'s embrace repeats.  ');
      expect(chatModel.user, User.ai);
    });

    test('loadSavedChats returns a list of ChatModels', () {
      final chatModels = datasource.loadSavedChats();
      expect(chatModels, isNotEmpty);
      expect(chatModels.length, 6);
      expect(chatModels, isA<List<ChatModel>>());
    });
  });
}