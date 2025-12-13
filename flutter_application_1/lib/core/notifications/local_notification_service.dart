import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: android);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          print("Payload: ${response.payload}");
        }
      },
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'custom_channel',
      'Custom Notification',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('bang_aje'),
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }
}
