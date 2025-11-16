import 'package:get/get.dart';

import '../data/repositories/auth_repository.dart';
import 'package:flutter_application_1/core/local/local_prefs_services.dart';
import '../routes/app_routes.dart';

/// Controller / logic untuk login & registrasi ke Supabase.
///
/// - login_page.dart cukup fokus UI:
///   TextField → set value ke RxString di sini
///   Button → panggil login() / register()
class LoginSupabase extends GetxController {
  final AuthRepository _authRepository;

  LoginSupabase({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository();

  // ===== STATE FORM =====
  /// input "Email / Username"
  final RxString identifier = ''.obs;

  /// input password
  final RxString password = ''.obs;

  /// input username khusus registrasi
  final RxString username = ''.obs;

  /// mode: true = login, false = register (kalau nanti mau dipakai toggle)
  final RxBool isLoginMode = true.obs;

  // ===== STATE UI =====
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// Helper untuk set field dari UI
  void setIdentifier(String value) => identifier.value = value;
  void setPassword(String value) => password.value = value;
  void setUsername(String value) => username.value = value;
  void setModeLogin(bool value) => isLoginMode.value = value;

  /// Registrasi user baru:
  /// - wajib online (Supabase)
  /// - simpan ke auth + tabel profiles
  /// - set flag login di LocalPrefsService
  Future<void> register() async {
    final email = identifier.value.trim();
    final uname = username.value.trim();
    final pass = password.value;

    errorMessage.value = '';

    if (email.isEmpty || uname.isEmpty || pass.isEmpty) {
      errorMessage.value = 'Email, username, dan password wajib diisi.';
      return;
    }

    isLoading.value = true;
    try {
      await _authRepository.registerUser(
        email: email,
        username: uname,
        password: pass,
      );

      // Setelah registrasi, langsung anggap user login.
      await LocalPrefsService.setLastEmail(email);
      await LocalPrefsService.setLastUsername(uname);
      await LocalPrefsService.setLoggedIn(true);

      // Arahkan ke halaman home (sesuaikan dengan AppRoutes milikmu)
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  /// Login dengan identifier (email atau username) + password.
  /// - Kalau login sukses → simpan info di LocalPrefsService
  /// - Kalau gagal → tampilkan pesan error
  Future<void> login() async {
    final id = identifier.value.trim();
    final pass = password.value;

    errorMessage.value = '';

    if (id.isEmpty || pass.isEmpty) {
      errorMessage.value = 'Email/username dan password wajib diisi.';
      return;
    }

    isLoading.value = true;
    try {
      // 1) Login via AuthRepository (handle email/username)
      await _authRepository.loginWithIdentifier(identifier: id, password: pass);

      // 2) Ambil profil user (email & username) untuk disimpan lokal
      final profile = await _authRepository.getCurrentProfile();

      final email =
          profile?['email'] as String? ?? (id.contains('@') ? id : '');
      final uname =
          profile?['username'] as String? ?? (!id.contains('@') ? id : '');

      if (email.isNotEmpty) {
        await LocalPrefsService.setLastEmail(email);
      }
      if (uname.isNotEmpty) {
        await LocalPrefsService.setLastUsername(uname);
      }

      await LocalPrefsService.setLoggedIn(true);

      // 3) Arahkan ke home
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout user:
  /// - panggil signOut ke Supabase
  /// - bersihkan flag di LocalPrefsService
  /// - arahkan ke halaman login
  Future<void> logout() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _authRepository.signOut();
      await LocalPrefsService.clearOnLogout();

      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}
