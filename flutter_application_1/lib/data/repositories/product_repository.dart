import '../models/product.dart';
import '../../core/local/hive_service.dart';
import '../providers/product_api_provider.dart';

class ProductRepository {
  final ProductApiProvider _apiProvider;

  ProductRepository({ProductApiProvider? apiProvider})
    : _apiProvider = apiProvider ?? ProductApiProvider();

  /// Ambil katalog produk:
  /// - Prioritas: ambil dari API (online), lalu cache ke Hive.
  /// - Kalau gagal (misal offline): ambil dari cache Hive.
  Future<List<Product>> getProducts() async {
    try {
      // 1) Coba ambil dari API (online)
      final remoteProducts = await _apiProvider.fetchProducts();

      // 2) Cache ke Hive
      await HiveService.cacheProducts(remoteProducts);

      // 3) Kembalikan hasil online
      return remoteProducts;
    } catch (e) {
      // 4) Kalau gagal (offline / error), fallback ke Hive
      final cached = HiveService.getCachedProducts();
      if (cached.isNotEmpty) {
        return cached;
      }

      // 5) Kalau cache juga kosong, lempar error
      rethrow;
    }
  }
}
