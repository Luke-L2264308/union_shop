import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// File name used for storing the cart
const _cartFilename = 'cart.json';

Future<File> _cartFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/$_cartFilename');
}

Future<List<Map<String, dynamic>>> readCartItems() async {
  final file = await _cartFile();
  if (!await file.exists()) return <Map<String, dynamic>>[];
  final contents = await file.readAsString();
  if (contents.trim().isEmpty) return <Map<String, dynamic>>[];
  final decoded = jsonDecode(contents);
  if (decoded is List) {
    return decoded.cast<Map<String, dynamic>>();
  }
  return <Map<String, dynamic>>[];
}

Future<void> writeCartItems(List<Map<String, dynamic>> items) async {
  final file = await _cartFile();
  final encoded = const JsonEncoder.withIndent('  ').convert(items);
  await file.writeAsString(encoded);
}

Future<void> appendCartItem(Map<String, dynamic> item) async {
  final items = await readCartItems();
  items.add(item);
  await writeCartItems(items);
}

// Convenience used by CartPage
Future<List<Map<String, dynamic>>> readCart() => readCartItems();