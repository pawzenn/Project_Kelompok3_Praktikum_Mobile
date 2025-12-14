import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/notification_controller.dart';
import '../../../core/notifications/local_notification_service.dart';

class NotificationTestView extends GetView<NotificationController> {
  const NotificationTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ====== TEST 1: Custom Sound ======
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('Custom Sound'),
            trailing: ElevatedButton(
              onPressed: () async {
                // 1) Tampilkan notifikasi lokal dengan suara custom
                await LocalNotificationService.showNotification(
                  title: 'Custom Sound',
                  body: 'Suara lalapan aktif 🔔',
                  playSound: true,
                );

                // 2) Simpan log ke Firebase
                await controller.logTestNotification(
                  type: 'custom_sound',
                  title: 'Custom Sound',
                  body: 'Suara lalapan aktif 🔔',
                  playSound: true,
                  source: 'tester_page',
                );
              },
              child: const Text('Play'),
            ),
          ),

          const SizedBox(height: 16),

          // ====== TEST 2: Instant Notification (tanpa sound) ======
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Instant Notification'),
            trailing: ElevatedButton(
              onPressed: () async {
                // 1) Notifikasi lokal tanpa suara
                await LocalNotificationService.showNotification(
                  title: 'Instant',
                  body: 'Notifikasi langsung muncul',
                  playSound: false,
                );

                // 2) Simpan log ke Firebase
                await controller.logTestNotification(
                  type: 'instant',
                  title: 'Instant',
                  body: 'Notifikasi langsung muncul',
                  playSound: false,
                  source: 'tester_page',
                );
              },
              child: const Text('Show'),
            ),
          ),
        ],
      ),
    );
  }
}
