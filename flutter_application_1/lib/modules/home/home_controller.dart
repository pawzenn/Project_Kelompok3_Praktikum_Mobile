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
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _productRepository.getChickenMenus();
      products.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProducts() => fetchProducts();
}
