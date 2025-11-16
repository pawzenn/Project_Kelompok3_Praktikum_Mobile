// lib/modules/home/home_controller.dart
import 'package:get/get.dart';

import '../../data/models/product.dart';
import '../../data/repositories/product_repository.dart';

class HomeController extends GetxController {
  final ProductRepository _productRepository;

  HomeController({ProductRepository? productRepository})
    : _productRepository = productRepository ?? ProductRepository();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Product> products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _productRepository.getProducts();
      products.assignAll(result);
    } catch (e) {
      errorMessage.value =
          'Gagal memuat katalog. Pastikan pernah online minimal sekali. (${e.toString()})';
    } finally {
      isLoading.value = false;
    }
  }
}
