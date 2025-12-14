import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../data/repositories/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository repo = NotificationRepository.instance;

  // Token FCM (untuk debugging)
  RxString token = ''.obs;

  // Riwayat notifikasi dari Firebase
  RxList<Map<String, dynamic>> history = <Map<String, dynamic>>[].obs;
  RxBool isLoadingHistory = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadToken();
    refreshLogs(); // boleh auto load saat halaman pertama kali dipakai
  }

  Future<void> _loadToken() async {
    token.value = await FirebaseMessaging.instance.getToken() ?? '';
  }

  /// Dipanggil dari NotificationTestView setiap kali user menekan Play / Show
  Future<void> logTestNotification({
    required String type,
    required String title,
    required String body,
    required bool playSound,
    required String source,
  }) async {
    await repo.logNotification(
      type: type,
      title: title,
      body: body,
      playSound: playSound,
      source: source,
    );
    // setelah log, refresh list di UI
    await refreshLogs();
  }

  /// Ambil riwayat dari Firebase dan tampilkan di view
  Future<void> refreshLogs() async {
    try {
      isLoadingHistory.value = true;
      final data = await repo.fetchHistory();
      history.assignAll(data);
    } catch (e) {
      // kalau mau bisa simpan error ke RxString
      // tapi untuk sekarang cukup diamkan
    } finally {
      isLoadingHistory.value = false;
    }
  }
}
