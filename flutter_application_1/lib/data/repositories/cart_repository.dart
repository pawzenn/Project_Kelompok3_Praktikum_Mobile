import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_application_1/data/providers/cart_remote_provider.dart';

class OfflineException implements Exception {
  final String message;
  OfflineException([this.message = 'Fitur ini memerlukan koneksi internet']);
}

class CartRepository {
  final CartRemoteProvider cartRemoteProvider;

  CartRepository({required this.cartRemoteProvider});

  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> addToCart({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    if (!await _isOnline()) {
      throw OfflineException('Tambah ke keranjang hanya bisa saat online');
    }

    await cartRemoteProvider.upsertCartItem(
      userId: userId,
      productId: productId,
      quantity: quantity,
    );
  }

  Future<List<Map<String, dynamic>>> getCart(String userId) async {
    if (!await _isOnline()) {
      throw OfflineException('Melihat keranjang hanya bisa saat online');
    }
    return cartRemoteProvider.getCartItems(userId);
  }

  Future<void> removeFromCart({
    required String userId,
    required String productId,
  }) async {
    if (!await _isOnline()) {
      throw OfflineException('Hapus item keranjang hanya bisa saat online');
    }

    await cartRemoteProvider.deleteCartItem(
      userId: userId,
      productId: productId,
    );
  }

  Future<void> clearCart(String userId) async {
    if (!await _isOnline()) {
      throw OfflineException('Kosongkan keranjang hanya bisa saat online');
    }

    await cartRemoteProvider.clearCart(userId);
  }
}
