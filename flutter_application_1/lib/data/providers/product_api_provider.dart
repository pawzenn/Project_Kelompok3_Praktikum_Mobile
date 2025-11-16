// lib/data/providers/product_api_provider.dart
import 'package:dio/dio.dart';

import '../models/product.dart';

class ProductApiProvider {
  final Dio _dio;

  ProductApiProvider({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Product>> fetchProducts() async {
    // Ganti URL ini dengan API katalogmu (misal TheMealDB atau API lain)
    const String url = 'https://example.com/api/products';

    final response = await _dio.get(url);

    if (response.statusCode == 200) {
      final data = response.data;

      // Sesuaikan dengan struktur JSON API-mu
      if (data is List) {
        return data
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (data is Map && data['items'] is List) {
        return (data['items'] as List)
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Format data katalog tidak didukung');
      }
    } else {
      throw Exception('Gagal memuat katalog (status: ${response.statusCode})');
    }
  }
}
