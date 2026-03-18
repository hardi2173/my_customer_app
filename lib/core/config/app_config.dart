import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.insurance-core.com/v1';
}
