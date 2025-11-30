import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

/// Append a cart item to a JSON array file stored in the app documents directory.
Future<void> appendCartItem(Map<String, dynamic> item) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/cart.json');

  List<dynamic> cart = [];
  if (await file.exists()) {
    final text = await file.readAsString();
    if (text.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(text);
        if (decoded is List) cart = decoded;
      } catch (_) {
        // ignore: avoid_print
        print('Failed to decode existing cart — starting fresh');
        cart = [];
      }
    }
  }

  cart.add(item);
  await file.writeAsString(jsonEncode(cart), flush: true);
}

/// Read cart as a list of maps. Returns empty list if missing or invalid.
Future<List<Map<String, dynamic>>> readCart() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/cart.json');
  if (!await file.exists()) return [];
  try {
    final text = await file.readAsString();
    final decoded = jsonDecode(text);
    if (decoded is List) {
      return decoded.cast<Map<String, dynamic>>();
    }
  } catch (_) {}
  return [];
}
