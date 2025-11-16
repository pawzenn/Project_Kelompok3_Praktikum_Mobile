import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  SupabaseService._();

  /// Singleton instance
  static final SupabaseService instance = SupabaseService._();

  /// Client internal
  late final SupabaseClient _client;

  /// Getter instance-level
  SupabaseClient get client => _client;

  /// Getter static global (enak dipakai di Repository lain)
  static SupabaseClient get globalClient => instance._client;

  /// Panggil SEKALI di awal aplikasi (di main.dart)
  static Future<void> init() async {
    // load .env
    await dotenv.load(fileName: ".env");

    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (url == null || anonKey == null) {
      throw Exception(
        'SUPABASE_URL atau SUPABASE_ANON_KEY belum diset di .env',
      );
    }

    await Supabase.initialize(url: url, anonKey: anonKey);

    instance._client = Supabase.instance.client;
  }

  // ========== AUTH ==========

  Future<AuthResponse> signUp(String email, String password) {
    return _client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn(String email, String password) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  // ========== CART ==========

  /// Upsert item ke tabel `cart_items`
  /// Struktur tabel (saran):
  /// id (uuid), user_id (uuid), product_id (text), quantity (int), created_at (timestamp)
  Future<void> upsertCartItem({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    await _client.from('cart_items').upsert({
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
    });
  }

  Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    final result = await _client
        .from('cart_items')
        .select()
        .eq('user_id', userId);

    return List<Map<String, dynamic>>.from(result);
  }

  Future<void> deleteCartItem({
    required String userId,
    required String productId,
  }) async {
    await _client
        .from('cart_items')
        .delete()
        .eq('user_id', userId)
        .eq('product_id', productId);
  }

  Future<void> clearCart(String userId) async {
    await _client.from('cart_items').delete().eq('user_id', userId);
  }

  // ========== ORDER ==========

  /// Saran struktur tabel:
  /// orders: id (uuid), user_id (uuid), total (numeric), created_at (timestamp)
  /// order_items: id, order_id (uuid), product_id (text), quantity (int), price (numeric)
  Future<String> createOrder({
    required String userId,
    required double total,
  }) async {
    final inserted = await _client
        .from('orders')
        .insert({'user_id': userId, 'total': total})
        .select()
        .single();

    final orderId = inserted['id'] as String;
    return orderId;
  }

  Future<void> insertOrderItems({
    required String orderId,
    required List<Map<String, dynamic>> items,
  }) async {
    // items: [{ product_id, quantity, price }, ...]
    final payload = items
        .map(
          (item) => {
            'order_id': orderId,
            'product_id': item['product_id'],
            'quantity': item['quantity'],
            'price': item['price'],
          },
        )
        .toList();

    await _client.from('order_items').insert(payload);
  }
}
