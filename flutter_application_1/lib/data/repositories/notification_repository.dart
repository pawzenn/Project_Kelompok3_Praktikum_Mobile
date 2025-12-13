class NotificationRepository {
  final List<String> logs = [];

  void addLog(String log) {
    logs.add("${DateTime.now()} - $log");
  }

  List<String> getLogs() => logs;
}
