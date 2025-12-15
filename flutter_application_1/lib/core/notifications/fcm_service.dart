import 'package:firebase_messaging/firebase_messaging.dart';
import 'local_notification_service.dart';
import '../../data/models/notification_payload.dart';
import 'notification_router.dart';

class FcmService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    // Permission (iOS & Android 13+)
    await _fcm.requestPermission();

    // Token
    String? token = await _fcm.getToken();
    print("FCM Token: $token");

    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final payload = NotificationPayload.fromRemoteMessage(message);

      LocalNotificationService.showNotification(
        title: message.notification?.title ?? 'Notifikasi',
        body: message.notification?.body ?? '',
        payload: payload.toJson(),
      );
    });

    // Ketika notif ditekan (app background)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final payload = NotificationPayload.fromRemoteMessage(message);
      NotificationRouter.route(payload);
    });
  }

  /// Background handler
  static Future<void> backgroundHandler(RemoteMessage message) async {
    final payload = NotificationPayload.fromRemoteMessage(message);
    NotificationRouter.route(payload);
  }
}
