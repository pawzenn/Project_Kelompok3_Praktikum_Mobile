import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  late final SupabaseClient client;

  Future<void> init() async {
    await dotenv.load(fileName: ".env");

    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (url == null || anonKey == null) {
      throw Exception('SUPABASE_URL atau SUPABASE_ANON_KEY belum diset di .env');
    }

    await Supabase.initialize(url: url, anonKey: anonKey);
    client = Supabase.instance.client;
  }

  // ========== AUTH ==========
  Future<AuthResponse> signUp(String email, String password) {
    return client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn(String email, String password) {
    return client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;

  // ========== CART ==========
  Future<void> upsertCartItem({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    try {
      await client.from('cart_items').upsert({
        'user_id': userId,
        'product_id': productId,
        'quantity': quantity,
      });
    } on PostgrestException catch (e) {
      throw Exception("${e.code ?? ''} ${e.message} ${e.details ?? ''}".trim());
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    try {
      final result =
          await client.from('cart_items').select().eq('user_id', userId);
      return List<Map<String, dynamic>>.from(result);
    } on PostgrestException catch (e) {
      throw Exception("${e.code ?? ''} ${e.message} ${e.details ?? ''}".trim());
    }
  }

  Future<void> deleteCartItem({
    required String userId,
    required String productId,
  }) async {
    try {
      await client
          .from('cart_items')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);
    } on PostgrestException catch (e) {
      throw Exception("${e.code ?? ''} ${e.message} ${e.details ?? ''}".trim());
    }
  }

  Future<void> clearCart(String userId) async {
    try {
      await client.from('cart_items').delete().eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw Exception("${e.code ?? ''} ${e.message} ${e.details ?? ''}".trim());
    }
  }

  // ========== ORDER ==========
  // FIX UTAMA: kolom total di schema kamu adalah "total" (bukan total_amount)
  Future<String> createOrder({
    required String userId,
    required double total,
  }) async {
    try {
      final result = await client
          .from('orders')
          .insert({
            'user_id': userId,
            'total': total, // <-- WAJIB sesuai schema kamu
          })
          .select('id')
          .single();

      return result['id'] as String;
    } on PostgrestException catch (e) {
      throw Exception("${e.code ?? ''} ${e.message} ${e.details ?? ''}".trim());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getOrders(String userId) async {
    try {
      final result = await client
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(result);
    } on PostgrestException catch (e) {
      throw Exception("${e.code ?? ''} ${e.message} ${e.details ?? ''}".trim());
    }
  }

  // Schema kamu: order_items.price = total per item (qty * harga)
  Future<void> insertOrderItems({
    required String orderId,
    required List<Map<String, dynamic>> items,
  }) async {
    final payload = items.map((item) {
      final qty = (item['quantity'] as num).toInt();
      final unitPrice = (item['price'] as num).toDouble();
      final totalPerItem = qty * unitPrice;

      return {
        'order_id': orderId,
        'product_id': item['product_id'],
        'quantity': qty,
        'price': totalPerItem, // <-- sesuai schema kamu
      };
    }).toList();

    try {
      await client.from('order_items').insert(payload);
    } on PostgrestException catch (e) {
      throw Exception("${e.code ?? ''} ${e.message} ${e.details ?? ''}".trim());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
