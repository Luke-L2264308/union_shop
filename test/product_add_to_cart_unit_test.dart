import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/productpagetemplates/product_page.dart';
import 'package:union_shop/cart_storage/cart_storage_io.dart';

/// Unit-style test that invokes the ProductPage's `addToCart` logic
/// by calling the widget state directly. The test mocks
/// `path_provider` to write into a temporary directory and
/// polls `readCartItems()` to wait for the internal async write
/// to complete.
void main() {
  const channelName = 'plugins.flutter.io/path_provider';
  final channel = const MethodChannel(channelName);

  late Directory tempDir;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir =
        await Directory.systemTemp.createTemp('product_add_to_cart_unit_');

    channel.setMockMethodCallHandler((call) async {
      if (call.method == 'getApplicationDocumentsDirectory') {
        return tempDir.path;
      }
      return null;
    });

    // Ensure an empty cart file exists so writes do not race with creation
    final f = File('${tempDir.path}/cart.json');
    if (!await f.exists()) await f.writeAsString('[]');
  });

  tearDown(() async {
    channel.setMockMethodCallHandler(null);
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  testWidgets('addToCart (state) persists and merges correctly',
      (tester) async {
    final sample = {
      'title': 'Unit Shirt',
      'description': 'Unit test product',
      'imageLocation': 'assets/images/collections/black-friday.png',
      'price': '£5',
      'sizes': ['M'],
      'colours': ['Blue'],
    };

    await tester.pumpWidget(MaterialApp(home: ProductPage(data: [sample])));
    await tester.pumpAndSettle();

    // Obtain the private state and call addToCart directly
    final state = tester.state(find.byType(ProductPage)) as dynamic;

    // Call addToCart inside runAsync so platform channel/file I/O run in the
    // test's real async zone and don't block the widget binding.
    await tester.runAsync(() async {
      state.addToCart('Blue', 'M', 'Unit Shirt');

      // Wait for the internal async write to complete by polling readCartItems()
      for (var i = 0; i < 20; i++) {
        final items = await readCartItems();
        if (items.isNotEmpty) break;
        await Future.delayed(const Duration(milliseconds: 100));
      }
    });

    List<Map<String, dynamic>>? items = await tester.runAsync(() async => await readCartItems());
    expect(items, isNotEmpty);
    expect(items!.first['title'], 'Unit Shirt');
    expect(items.first['quantity'], 1);

    // Call again to test merging behavior; run inside runAsync for same reason
    await tester.runAsync(() async {
      state.addToCart('Blue', 'M', 'Unit Shirt');

      for (var i = 0; i < 20; i++) {
        final it = await readCartItems();
        if (it.isNotEmpty && (it.first['quantity'] as int) >= 2) break;
        await Future.delayed(const Duration(milliseconds: 100));
      }
    });

    items = await tester.runAsync(() async => await readCartItems());
    expect(items, hasLength(1));
    expect(items!.first['quantity'], 2);
  });
}
