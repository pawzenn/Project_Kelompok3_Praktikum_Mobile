// lib/core/local/local_prefs_service.dart

import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk menyimpan status login & info user secara lokal
/// menggunakan SharedPreferences.
class LocalPrefsService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyLastEmail = 'last_email';
  static const String _keyLastUsername = 'last_username';

  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  /// Simpan status apakah user sedang login
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  /// Cek apakah user pernah login dan belum logout
  static Future<bool> isLoggedIn() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Simpan email terakhir yang dipakai login
  static Future<void> setLastEmail(String email) async {
    final prefs = await _prefs;
    await prefs.setString(_keyLastEmail, email);
  }

  /// Simpan username terakhir yang dipakai login
  static Future<void> setLastUsername(String username) async {
    final prefs = await _prefs;
    await prefs.setString(_keyLastUsername, username);
  }

  /// Ambil email terakhir (kalau ada)
  static Future<String?> getLastEmail() async {
    final prefs = await _prefs;
    return prefs.getString(_keyLastEmail);
  }

  /// Ambil username terakhir (kalau ada)
  static Future<String?> getLastUsername() async {
    final prefs = await _prefs;
    return prefs.getString(_keyLastUsername);
  }

  /// Dipakai saat logout:
  /// - hapus status login
  /// - boleh juga sekalian hapus email/username kalau mau
  static Future<void> clearOnLogout() async {
    final prefs = await _prefs;
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyLastEmail);
    await prefs.remove(_keyLastUsername);
  }
}
