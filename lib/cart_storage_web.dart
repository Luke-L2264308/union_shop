import 'dart:convert';
import 'dart:html' as html;

const _kCartKey = 'union_shop_cart_v1';

Future<void> appendCartItem(Map<String, dynamic> item) async {
  final stored = html.window.localStorage[_kCartKey];
  List<dynamic> cart = [];
  if (stored != null && stored.isNotEmpty) {
    try {
      final decoded = jsonDecode(stored);
      if (decoded is List) cart = decoded;
    } catch (_) {
      cart = [];
    }
  }
  cart.add(item);
  html.window.localStorage[_kCartKey] = jsonEncode(cart);
}

Future<List<Map<String, dynamic>>> readCart() async {
  final stored = html.window.localStorage[_kCartKey];
  if (stored == null || stored.isEmpty) return [];
  try {
    final decoded = jsonDecode(stored);
    if (decoded is List) return decoded.cast<Map<String, dynamic>>();
  } catch (_) {}
  return [];
}
