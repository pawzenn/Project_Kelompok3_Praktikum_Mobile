import 'package:get/get.dart';

import '../../core/supabase/supabase_service.dart';
import '../../data/models/product.dart';

class CartItemLine {
  final Product product;
  int quantity;

  CartItemLine({required this.product, this.quantity = 1});
}

class CartController extends GetxController {
  final items = <CartItemLine>[].obs;

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.product.price * item.quantity);

  void addProduct(Product product) async {
    CartItemLine? line;
    for (final item in items) {
      if (item.product.id == product.id) {
        line = item;
        break;
      }
    }

    if (line != null) {
      line.quantity++;
      items.refresh();
    } else {
      items.add(CartItemLine(product: product, quantity: 1));
    }

    // Simpan juga ke Supabase cart_items
    final user = SupabaseService.instance.currentUser;
    if (user != null) {
      await SupabaseService.instance.upsertCartItem(
        userId: user.id,
        productId: product.id,
        quantity: line?.quantity ?? 1,
      );
    }
  }

  void increment(CartItemLine line) {
    line.quantity++;
    items.refresh();
  }

  void decrement(CartItemLine line) async {
    if (line.quantity > 1) {
      line.quantity--;
      items.refresh();
    } else {
      items.remove(line);
    }

    final user = SupabaseService.instance.currentUser;
    if (user != null) {
      if (line.quantity > 0) {
        await SupabaseService.instance.upsertCartItem(
          userId: user.id,
          productId: line.product.id,
          quantity: line.quantity,
        );
      } else {
        await SupabaseService.instance.deleteCartItem(
          userId: user.id,
          productId: line.product.id,
        );
      }
    }
  }

  Future<void> clearCart() async {
    final user = SupabaseService.instance.currentUser;
    if (user != null) {
      await SupabaseService.instance.clearCart(user.id);
    }
    items.clear();
  }

  Future<void> checkout() async {
    if (items.isEmpty) return;

    final user = SupabaseService.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'User tidak ditemukan, silakan login ulang.');
      return;
    }

    final total = totalPrice;

    final orderId = await SupabaseService.instance.createOrder(
      userId: user.id,
      total: total,
    );

    await SupabaseService.instance.insertOrderItems(
      orderId: orderId,
      items: items
          .map(
            (e) => {
              'product_id': e.product.id,
              'quantity': e.quantity,
              'price': e.product.price,
            },
          )
          .toList(),
    );

    await clearCart();

    Get.snackbar('Sukses', 'Pesanan berhasil dibuat.');
  }
}
