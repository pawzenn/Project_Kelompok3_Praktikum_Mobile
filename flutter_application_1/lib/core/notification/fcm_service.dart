import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_router.dart';

class FCMService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// INIT FCM
  static Future<void> init() async {
    // permission
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // token
    final token = await _fcm.getToken();
    print('🔥 FCM TOKEN: $token');

    // foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      NotificationRouter.handle(message);
    });

    // when app opened from notif
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      NotificationRouter.route(message.data);
    });
  }
}
