import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpClientService {
  final Duration timeout = const Duration(seconds: 15);

  Future<Map<String, dynamic>> getJson(String url) async {
    final res = await http.get(Uri.parse(url)).timeout(timeout);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP error ${res.statusCode}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
