import 'package:get/get.dart';
import '../../../data/repositories/notification_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationController extends GetxController {
  final repo = NotificationRepository();

  RxString token = ''.obs;
  RxString lastMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadToken();
  }

  Future<void> _loadToken() async {
    token.value = await FirebaseMessaging.instance.getToken() ?? '';
    repo.addLog("Token loaded");
  }
}
