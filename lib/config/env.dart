import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Ortam değişkenleri (.env dosyasından yüklenir)
class Env {
  Env._();

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  static String get supabaseUrl =>
      dotenv.env['SUPABASE_URL'] ?? _throwMissing('SUPABASE_URL');

  static String get supabaseAnonKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ?? _throwMissing('SUPABASE_ANON_KEY');

  static Never _throwMissing(String key) {
    throw StateError(
      '$key ortam değişkeni bulunamadı. .env dosyasını kontrol edin.',
    );
  }
}
