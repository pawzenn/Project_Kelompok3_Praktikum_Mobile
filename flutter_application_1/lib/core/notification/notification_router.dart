import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'local_notification_service.dart';
import '../../routes/app_routes.dart';

class NotificationRouter {
  static void handle(RemoteMessage message) {
    final notif = message.notification;
    if (notif != null) {
      LocalNotificationService.show(
        title: notif.title ?? 'Notifikasi',
        body: notif.body ?? '',
      );
    }
  }

  static void route(Map<String, dynamic> data) {
    final type = data['type'];

    if (type == 'promo') {
      Get.toNamed(AppRoutes.home);
    } else if (type == 'order') {
      Get.toNamed(AppRoutes.order);
    }
  }
}
