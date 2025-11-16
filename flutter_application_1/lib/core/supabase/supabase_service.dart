// lib/core/supabase/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service pembungkus Supabase supaya mudah diakses di seluruh app.
class SupabaseService {
  SupabaseService._(); // private constructor, biar tidak bisa di-instance

  /// Client global Supabase (setelah Supabase.initialize dipanggil di main()).
  static SupabaseClient get client => Supabase.instance.client;

  /// Inisialisasi Supabase.
  /// Panggil sekali di main(), setelah dotenv.load().
  static Future<void> init() async {
    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (url == null || anonKey == null) {
      throw Exception(
        'SUPABASE_URL atau SUPABASE_ANON_KEY belum di-set di .env',
      );
    }

    await Supabase.initialize(url: url, anonKey: anonKey);
  }
}
