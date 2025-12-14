import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: android,
      iOS: ios, // ✅ wajib saat run di iOS
    );

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
          ? const RawResourceAndroidNotificationSound('bang_ajeyy')
          : null,
    );

    const iosDetails = DarwinNotificationDetails(); // ✅ biar iOS ada config

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }
}
