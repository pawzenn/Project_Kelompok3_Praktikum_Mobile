import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../login/login_supabase.dart';
import '../../routes/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  Future<void> _handleLogout() async {
    await LoginSupabaseService.signOut();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lalapan Bang Ajey'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Ini halaman utama setelah login.\n'
          'Nanti bisa kamu isi dengan daftar menu, keranjang, dll.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
