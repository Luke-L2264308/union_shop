import 'dart:convert';
import 'dart:html' as html;

const _cartKey = 'union_shop_cart';

Future<List<Map<String, dynamic>>> readCartItems() async {
  final raw = html.window.localStorage[_cartKey];
  if (raw == null || raw.trim().isEmpty) return <Map<String, dynamic>>[];
  final decoded = jsonDecode(raw);
  if (decoded is List) return decoded.cast<Map<String, dynamic>>();
  return <Map<String, dynamic>>[];
}

Future<void> writeCartItems(List<Map<String, dynamic>> items) async {
  html.window.localStorage[_cartKey] = const JsonEncoder.withIndent('  ').convert(items);
}

Future<void> appendCartItem(Map<String, dynamic> item) async {
  final items = await readCartItems();
  items.add(item);
  await writeCartItems(items);
}

Future<List<Map<String, dynamic>>> readCart() => readCartItems();