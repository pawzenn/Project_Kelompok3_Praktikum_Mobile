// lib/core/supabase/supabase_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

/// Service pembungkus Supabase supaya mudah diakses di seluruh app.
class SupabaseService {
  SupabaseService._(); // private constructor, biar tidak bisa di-instance

  /// Client global Supabase (setelah Supabase.initialize dipanggil di main()).
  static SupabaseClient get client => Supabase.instance.client;

  /// Opsional: kalau mau inisialisasi Supabase lewat sini, bisa pakai method ini.
  /// Kalau kamu sudah memanggil Supabase.initialize di main.dart,
  /// method ini tidak wajib dipakai.
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://sljlklzqxsxrtfmumnhd.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNsamxrbHpxeHN4cnRmbXVtbmhkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMyODk2NDMsImV4cCI6MjA3ODg2NTY0M30.aJxkidvL_4eY0C0YcBs29Prqus4A4jBcf_b7AQJ-DSk',
    );
  }
}
