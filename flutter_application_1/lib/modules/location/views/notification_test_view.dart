import 'package:flutter/material.dart';
import '../../../core/notifications/local_notification_service.dart';

class NotificationTestView extends StatelessWidget {
  const NotificationTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('Custom Sound'),
            trailing: ElevatedButton(
              onPressed: () {
                LocalNotificationService.showNotification(
                  title: 'Custom Sound',
                  body: 'Suara lalapan aktif 🔔',
                );
              },
              child: const Text('Play'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Instant Notification'),
            trailing: ElevatedButton(
              onPressed: () {
                LocalNotificationService.showNotification(
                  title: 'Instant',
                  body: 'Notifikasi langsung muncul',
                  playSound: false,
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
