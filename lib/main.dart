import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_gpt/constants/constants.dart';
import 'package:flutter_chat_gpt/infrastructure/datasources/chat_datasource_impl.dart';
import 'package:flutter_chat_gpt/infrastructure/datasources/chat_datasource_local_impl.dart';
import 'package:flutter_chat_gpt/infrastructure/datasources/model_datasource_local.dart';
import 'package:flutter_chat_gpt/infrastructure/repositories/chat_repository_impl.dart';
import 'package:flutter_chat_gpt/presentation/blocs/chat/chat_bloc.dart';
import 'package:flutter_chat_gpt/presentation/blocs/model/model_bloc.dart';
import 'package:flutter_chat_gpt/presentation/screens/chat_screen.dart';
import 'package:flutter_chat_gpt/services/simple_bloc_observer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'infrastructure/datasources/model_datasource_impl.dart';
import 'infrastructure/repositories/model_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final bool useLocalDb = true;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ModelBloc(ModelRepositoryImpl(
              useLocalDb ? ModelDatasourceLocal() : ModelDatasourceImpl()))
            ..add(LoadModels()),
        ),
        BlocProvider(
            create: (_) => ChatBloc(ChatRepositoryImpl(
                useLocalDb ? ChatDatasourceLocalImpl() : ChatDatasourceImpl())))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            appBarTheme: AppBarTheme(color: cardColor)),
        home: const ChatScreen(),
      ),
    );
  }
}
