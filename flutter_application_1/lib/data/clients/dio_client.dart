import 'package:dio/dio.dart';

class DioClientService {
  late final Dio dio;

  DioClientService() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    dio.interceptors.add(
      LogInterceptor(
        request: false,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
      ),
    );
  }

  Future<Map<String, dynamic>> getJson(String url) async {
    final res = await dio.get(url);
    if (res.statusCode != null &&
        (res.statusCode! < 200 || res.statusCode! >= 300)) {
      throw Exception('Dio error ${res.statusCode}');
    }
    final data = res.data;
    if (data is Map<String, dynamic>) return data;
    throw Exception('Unexpected response type');
  }
}
