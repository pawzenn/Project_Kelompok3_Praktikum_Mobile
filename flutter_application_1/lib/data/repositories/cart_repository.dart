import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_application_1/data/providers/cart_remote_provider.dart';

/// Dipakai untuk mewakili kondisi offline
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

  /// Tambah / update item di keranjang (upsert)
  /// - Hanya boleh saat online (sesuai ketentuan kamu: add/checkout wajib online)
  Future<void> upsertCartItem({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    if (!await _isOnline()) {
      throw OfflineException('Menambah ke keranjang hanya bisa saat online');
    }

    await cartRemoteProvider.upsertCartItem(
      userId: userId,
      productId: productId,
      quantity: quantity,
    );
  }

  /// Ambil isi keranjang user dari Supabase
  Future<List<Map<String, dynamic>>> getCart(String userId) async {
    if (!await _isOnline()) {
      throw OfflineException('Melihat keranjang hanya bisa saat online');
    }

    return await cartRemoteProvider.getCartItems(userId);
  }

  /// Hapus 1 item dari keranjang
  Future<void> removeFromCart({
    required String userId,
    required String productId,
  }) async {
    if (!await _isOnline()) {
      throw OfflineException('Menghapus item keranjang hanya bisa saat online');
    }

    await cartRemoteProvider.deleteCartItem(
      userId: userId,
      productId: productId,
    );
  }

  /// Kosongkan keranjang user
  Future<void> clearCart(String userId) async {
    if (!await _isOnline()) {
      throw OfflineException('Kosongkan keranjang hanya bisa saat online');
    }

    await cartRemoteProvider.clearCart(userId);
  }
}
