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
  html.window.localStorage[_cartKey] =
      const JsonEncoder.withIndent('  ').convert(items);
}

Future<void> appendCartItem(Map<String, dynamic> item) async {
  final items = await readCartItems();
  items.add(item);
  await writeCartItems(items);
}

Future<List<Map<String, dynamic>>> readCart() => readCartItems();

Future<void> decreaseCartItemQuantity({
  required String title,
  required String size,
  required String colour,
  required int count,
}) async {
  final items = await readCartItems();
  final idx = items.indexWhere((e) =>
      (e['title'] ?? '') == title &&
      (e['size'] ?? '') == size &&
      (e['colour'] ?? '') == colour);
  if (idx == -1) return;
  final current = int.tryParse('${items[idx]['quantity']}') ?? 0;
  final newQty = current - count;
  if (newQty > 0) {
    items[idx]['quantity'] = newQty;
    items[idx]['addedAt'] = DateTime.now().toIso8601String();
  } else {
    items.removeAt(idx);
  }
  await writeCartItems(items);
}

Future<void> removeCartItem({
  required String title,
  required String size,
  required String colour,
}) async {
  final items = await readCartItems();
  items.removeWhere((e) =>
      (e['title'] ?? '') == title &&
      (e['size'] ?? '') == size &&
      (e['colour'] ?? '') == colour);
  await writeCartItems(items);
}

Future<void> increaseCartItemQuantity({
  required String title,
  required String size,
  required String colour,
  required int count,
}) async {
  final items = await readCartItems();
  final idx = items.indexWhere((e) =>
      (e['title'] ?? '') == title &&
      (e['size'] ?? '') == size &&
      (e['colour'] ?? '') == colour);

  final current = int.tryParse('${items[idx]['quantity']}') ?? 0;
  items[idx]['quantity'] = current + count;
  items[idx]['addedAt'] = DateTime.now().toIso8601String();

  await writeCartItems(items);
}
