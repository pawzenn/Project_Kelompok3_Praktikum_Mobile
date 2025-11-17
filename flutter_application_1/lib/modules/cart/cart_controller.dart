import 'package:get/get.dart';

import '../../core/supabase/supabase_service.dart';
import '../../data/models/product.dart';
import '../../data/providers/cart_remote_provider.dart';
import '../../data/providers/order_remote_provider.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/order_repository.dart';
import '../home/home_controller.dart';

class CartItemLine {
  final Product product;
  int quantity;

  CartItemLine({required this.product, this.quantity = 1});
}

class CartController extends GetxController {
  /// Daftar item di keranjang (produk + quantity)
  final items = <CartItemLine>[].obs;

  /// Untuk indikasi loading saat sync dari server (opsional dipakai di UI)
  final isLoading = false.obs;

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

    // Saat controller pertama kali dibuat, langsung sync keranjang
    // dari Supabase (supaya device B bisa melihat isi keranjang device A).
    _loadCartFromServer();
  }

  /// Ambil keranjang dari Supabase untuk currentUser,
  /// lalu mapping ke CartItemLine dengan mencocokkan product_id ke Product.
  Future<void> _loadCartFromServer() async {
    final user = SupabaseService.instance.currentUser;
    if (user == null) {
      items.clear();
      return;
    }

    try {
      isLoading.value = true;

      // 1) Ambil row cart_items dari repository (harus ada method ini di CartRepository)
      final remoteRows = await _cartRepository.getCartItems(userId: user.id);
      // remoteRows diasumsikan List<Map<String, dynamic>> dengan field
      // 'product_id' (String) dan 'quantity' (int).

      // 2) Ambil daftar produk yang sudah dimuat HomeController
      final home = Get.find<HomeController>();
      final allProducts = home.products; // RxList<Product> atau List<Product>

      final loaded = <CartItemLine>[];

      for (final row in remoteRows) {
        final String productId = row['product_id'] as String;
        final int qty = row['quantity'] as int;

        // Cari Product yang id-nya sama
        final product = allProducts.firstWhereOrNull((p) => p.id == productId);

        if (product != null && qty > 0) {
          loaded.add(CartItemLine(product: product, quantity: qty));
        }
      }

      items.assignAll(loaded);
    } on OfflineException catch (_) {
      // Kalau offline, biarkan saja items apa adanya (misal kosong).
      // Bisa juga kasih snackbar kalau mau.
    } catch (e) {
      // Bisa log / snackbar untuk debug, tapi jangan bikin app crash.
      Get.snackbar('Error', 'Gagal memuat keranjang: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Dipanggil dari UI kalau user tap "refresh" di halaman keranjang (opsional)
  Future<void> refreshFromServer() async {
    await _loadCartFromServer();
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
