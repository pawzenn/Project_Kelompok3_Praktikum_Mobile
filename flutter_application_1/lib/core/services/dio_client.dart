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
        requestBody: false,
        responseBody: false,
        requestHeader: false,
        responseHeader: false,
        error: true,
        request: false,
      ),
    );
  }

  Future<Map<String, dynamic>> getJson(String url) async {
    final res = await dio.get(url);
    if (res.statusCode != null &&
        (res.statusCode! < 200 || res.statusCode! >= 300)) {
      throw Exception('Dio error ${res.statusCode}');
    }
    if (res.data is Map<String, dynamic>) {
      return res.data as Map<String, dynamic>;
    }
    throw Exception('Unexpected response type');
  }
}
