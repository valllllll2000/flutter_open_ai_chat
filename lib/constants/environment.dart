import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String API_KEY = dotenv.env['API_KEY'] ?? 'Key not found';
}