import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/theme_controller.dart';
import '../../routes/app_routes.dart';
import '../../data/models/product.dart';
import '../cart/cart_controller.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final ThemeController _themeController = Get.find<ThemeController>();
  final CartController _cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    // MediaQuery: dipakai untuk orientasi dan ukuran layar
    final media = MediaQuery.of(context);
    final orientation = media.orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lalapan Bang Ajey'),
        actions: [
          IconButton(
            icon: const Icon(Icons.note),
            onPressed: () => Get.toNamed(AppRoutes.notes),
          ),
          IconButton(
            onPressed: () => controller.refreshProducts(),
            icon: const Icon(Icons.refresh),
          ),
          GetBuilder<ThemeController>(
            builder: (tc) {
              return IconButton(
                icon: Icon(tc.isDark ? Icons.dark_mode : Icons.light_mode),
                onPressed: () => tc.toggleTheme(),
              );
            },
          ),
          Obx(() {
            final count = _cartController.totalQuantity;
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => Get.toNamed(AppRoutes.cart),
                ),
                if (count > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          }),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed(AppRoutes.profile),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (controller.products.isEmpty) {
          return const Center(child: Text('Menu belum tersedia.'));
        }

        final products = controller.products;

        // LayoutBuilder: responsif berdasarkan lebar area konten
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            // Tentukan jumlah kolom berdasarkan lebar layar
            int crossAxisCount;
            if (width < 600) {
              // HP
              crossAxisCount = 2;
            } else if (width < 900) {
              // tablet kecil / hp landscape
              crossAxisCount = 3;
            } else {
              // tablet gede / layar lebar
              crossAxisCount = 4;
            }

            // ChildAspectRatio disesuaikan sedikit supaya di tablet
            // kartu tidak terlalu tinggi / terlalu gepeng
            double childAspectRatio;
            if (orientation == Orientation.portrait) {
              childAspectRatio = width < 600 ? 0.75 : 0.80;
            } else {
              // landscape cenderung lebih lebar
              childAspectRatio = width < 900 ? 1.0 : 1.1;
            }

            return Align(
              // Biar di tablet lebar, grid tidak melebar full sampai ujung
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1000, // batas max lebar grid di tablet/web
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return _ProductCard(
                      product: p,
                      onAdd: () => _cartController.addProduct(p),
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const _ProductCard({required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // gambar mengisi ruang atas card secara fleksibel
          Expanded(
            child: product.imageUrl != null
                ? Image.network(
                    product.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : const Icon(Icons.fastfood, size: 48),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Text(
              product.category ?? '',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rp ${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: onAdd,
                  tooltip: 'Tambah ke keranjang',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
