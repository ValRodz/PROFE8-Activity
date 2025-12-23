import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class CartService {
  static const _cartKey = 'cart_items';

  static Future<List<Map<String, dynamic>>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cartKey);
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> data = jsonDecode(raw);
    return data.cast<Map<String, dynamic>>();
  }

  static Future<void> _saveCart(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cartKey, jsonEncode(items));
  }

  static Future<void> addToCart(Product product, int quantity) async {
    final items = await loadCart();
    final index = items.indexWhere((item) => item['product_id'] == product.id);
    if (index >= 0) {
      items[index]['quantity'] = (items[index]['quantity'] as int) + quantity;
    } else {
      items.add({
        'product_id': product.id,
        'name': product.name,
        'price': product.price,
        'quantity': quantity,
        'image_url': product.imageUrl,
        'stock': product.stock,
        'seller_id': product.sellerId,
      });
    }
    await _saveCart(items);
  }

  static Future<void> updateQuantity(int productId, int quantity) async {
    final items = await loadCart();
    final index = items.indexWhere((item) => item['product_id'] == productId);
    if (index >= 0) {
      items[index]['quantity'] = quantity;
      await _saveCart(items);
    }
  }

  static Future<void> removeItem(int productId) async {
    final items = await loadCart();
    items.removeWhere((item) => item['product_id'] == productId);
    await _saveCart(items);
  }

  static Future<void> clearCart() async {
    await _saveCart([]);
  }
}

