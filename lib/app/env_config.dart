import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://default.api.com';
  static String get solanaUrl =>
      dotenv.env['SOLANA_URL'] ?? 'https://api.mainnet-beta.solana.com';
}
