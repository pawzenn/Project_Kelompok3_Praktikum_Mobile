class NotificationRepository {
  static final List<Map<String, dynamic>> _logs = [];

  static void save(Map<String, dynamic> data) {
    _logs.add({...data, 'time': DateTime.now().toIso8601String()});
  }

  static List<Map<String, dynamic>> get logs => _logs;
}
