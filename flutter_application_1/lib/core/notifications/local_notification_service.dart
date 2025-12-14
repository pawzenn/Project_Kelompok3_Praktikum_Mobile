import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    bool playSound = true,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'lalapan_channel',
      'Lalapan Notification',
      importance: Importance.max,
      priority: Priority.high,
      playSound: playSound,
      sound: playSound
          ? const RawResourceAndroidNotificationSound('bang_aje')
          : null,
    );

    final details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }
}
