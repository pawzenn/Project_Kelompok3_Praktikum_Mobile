import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import '../../../core/notifications/local_notification_service.dart';

class NotificationDebugView extends GetView<NotificationController> {
  const NotificationDebugView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Debug')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text("FCM Token:\n${controller.token.value}")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                LocalNotificationService.showNotification(
                  title: 'Test Lalapan',
                  body: 'Custom sound aktif 🌶️',
                  payload: '{"type":"promo"}',
                );
              },
              child: const Text('Test Local Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
