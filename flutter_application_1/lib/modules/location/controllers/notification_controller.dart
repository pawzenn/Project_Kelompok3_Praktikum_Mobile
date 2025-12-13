import 'package:get/get.dart';

class NotificationController extends GetxController {
  final token = ''.obs;
  final lastMessage = ''.obs;

  void setToken(String value) {
    token.value = value;
  }

  void setLastMessage(String value) {
    lastMessage.value = value;
  }
}
