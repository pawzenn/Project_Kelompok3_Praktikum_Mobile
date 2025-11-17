import 'package:get/get.dart';

import '../../core/supabase/supabase_service.dart';
import '../../data/models/product.dart';
import '../../data/providers/cart_remote_provider.dart';
import '../../data/providers/order_remote_provider.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/order_repository.dart';

class CartItemLine {
  final Product product;
  int quantity;

  CartItemLine({required this.product, this.quantity = 1});
}

class CartController extends GetxController {
  final items = <CartItemLine>[].obs;

  late final CartRepository _cartRepository;
  late final OrderRepository _orderRepository;

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  @override
  void onInit() {
    super.onInit();
    final supabaseService = SupabaseService.instance;

    _cartRepository = CartRepository(
      cartRemoteProvider: CartRemoteProvider(supabaseService: supabaseService),
    );

    _orderRepository = OrderRepository(
      orderRemoteProvider: OrderRemoteProvider(
        supabaseService: supabaseService,
      ),
      cartRepository: _cartRepository,
    );
  }

  Future<void> addProduct(Product product) async {
    final user = SupabaseService.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'User tidak ditemukan, silakan login ulang.');
      return;
    }

    // Hitung quantity baru
    CartItemLine? line = items.firstWhereOrNull(
      (e) => e.product.id == product.id,
    );
    final int newQty = (line?.quantity ?? 0) + 1;

    try {
      // 1) Simpan ke Supabase (cek online di dalam repository)
      await _cartRepository.upsertCartItem(
        userId: user.id,
        productId: product.id,
        quantity: newQty,
      );

      // 2) Kalau berhasil → update state lokal
      if (line != null) {
        line.quantity = newQty;
        items.refresh();
      } else {
        items.add(CartItemLine(product: product, quantity: 1));
      }
    } on OfflineException catch (e) {
      Get.snackbar('Koneksi', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah ke keranjang: $e');
    }
  }

  Future<void> increment(CartItemLine line) async {
    final user = SupabaseService.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'User tidak ditemukan, silakan login ulang.');
      return;
    }

    final newQty = line.quantity + 1;

    try {
      await _cartRepository.upsertCartItem(
        userId: user.id,
        productId: line.product.id,
        quantity: newQty,
      );
      line.quantity = newQty;
      items.refresh();
    } on OfflineException catch (e) {
      Get.snackbar('Koneksi', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengubah jumlah: $e');
    }
  }

  Future<void> decrement(CartItemLine line) async {
    final user = SupabaseService.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'User tidak ditemukan, silakan login ulang.');
      return;
    }

    final newQty = line.quantity - 1;

    try {
      if (newQty > 0) {
        await _cartRepository.upsertCartItem(
          userId: user.id,
          productId: line.product.id,
          quantity: newQty,
        );
        line.quantity = newQty;
        items.refresh();
      } else {
        await _cartRepository.removeFromCart(
          userId: user.id,
          productId: line.product.id,
        );
        items.remove(line);
      }
    } on OfflineException catch (e) {
      Get.snackbar('Koneksi', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengubah jumlah: $e');
    }
  }

  Future<void> clearCart() async {
    final user = SupabaseService.instance.currentUser;
    if (user == null) {
      items.clear();
      return;
    }

    try {
      await _cartRepository.clearCart(user.id);
      items.clear();
    } on OfflineException catch (e) {
      Get.snackbar('Koneksi', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengosongkan keranjang: $e');
    }
  }

  Future<void> checkout() async {
    if (items.isEmpty) return;

    final user = SupabaseService.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'User tidak ditemukan, silakan login ulang.');
      return;
    }

    final payload = items
        .map(
          (e) => {
            'product_id': e.product.id,
            'quantity': e.quantity,
            'price': e.product.price,
          },
        )
        .toList();

    try {
      await _orderRepository.checkout(userId: user.id, items: payload);

      // OrderRepository akan memanggil cartRepository.clearCart(userId)
      items.clear();

      Get.snackbar('Sukses', 'Pesanan berhasil dibuat.');
    } on OfflineException catch (e) {
      Get.snackbar('Koneksi', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Gagal checkout: $e');
    }
  }
}
