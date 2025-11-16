import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_badge_client.dart';
import 'choice_controller.dart';

class ChoiceView extends StatelessWidget {
  const ChoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ChoiceController(), permanent: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Metode Koneksi'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Gunakan jalur jaringan:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          c.choose(ClientType.http);
                          // ✅ Pakai riwayat: back button akan muncul otomatis di Home
                          Get.toNamed(AppRoutes.home);
                        },
                        icon: const Icon(Icons.http),
                        label: const Text('HTTP'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          c.choose(ClientType.dio);
                          // ✅ Pakai riwayat juga di sini
                          Get.toNamed(AppRoutes.home);
                        },
                        icon: const Icon(Icons.cloud),
                        label: const Text('Dio'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const AppBadgeClient(), // menunjukkan pilihan terakhir
              ],
            ),
          ),
        ),
      ),
    );
  }
}
