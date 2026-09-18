import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get baseUrl => dotenv.env['SUPABASE_URL']!;

  static String get apiKey => dotenv.env['SUPABASE_ANON_KEY']!;
}
