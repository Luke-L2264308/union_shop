import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/cart_storage/cart_storage_io.dart';

void main() {
  const channelName = 'plugins.flutter.io/path_provider';
  final channel = const MethodChannel(channelName);

  late Directory tempDir;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('cart_storage_test_');

    TestDefaultBinaryMessengerBinding
        .instance
        .defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'getApplicationDocumentsDirectory') {
        return tempDir.path;
      }
      return null;
    });
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding
      .instance
      .defaultBinaryMessenger
      .setMockMethodCallHandler(channel, null);
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test(
      'write item to storage and read it back to test persistence and deserialization',
      () async {
    final items = [
      {
        'title': 'T-Shirt',
        'size': 'M',
        'colour': 'Red',
        'quantity': 2,
        'addedAt': DateTime.utc(2020).toIso8601String(),
      }
    ];
    await writeCartItems(items);
    final read = await readCartItems();
    expect(read, hasLength(1));
    expect(read.first['title'], 'T-Shirt');
    expect(read.first['quantity'], 2);
  });
  test('appendCartItem adds an item to existing list', () async {
    final initial = [
      {'title': 'Socks', 'size': 'L', 'colour': 'Black', 'quantity': 1}
    ];
    await writeCartItems(initial);
    await appendCartItem({
      'title': 'Hat',
      'size': 'One',
      'colour': 'Blue',
      'quantity': 1,
    });
    final read = await readCartItems();
    expect(read.map((e) => e['title']), containsAll(['Socks', 'Hat']));
    expect(read, hasLength(2));
  });

  test('decreaseCartItemQuantity decreases quantity and removes when <= 0',
      () async {
    final item = {
      'title': 'Jacket',
      'size': 'XL',
      'colour': 'Green',
      'quantity': 3,
      'addedAt': DateTime.utc(2020).toIso8601String(),
    };
    await writeCartItems([item]);

    // decrease by 1 => quantity becomes 2
    await decreaseCartItemQuantity(
      title: 'Jacket',
      size: 'XL',
      colour: 'Green',
      count: 1,
    );
    var read = await readCartItems();
    expect(read, hasLength(1));
    expect(read.first['quantity'], 2);
    expect(DateTime.tryParse(read.first['addedAt'] ?? ''), isNotNull);

    // decrease by 2 => item removed
    await decreaseCartItemQuantity(
      title: 'Jacket',
      size: 'XL',
      colour: 'Green',
      count: 2,
    );
    read = await readCartItems();
    expect(read, isEmpty);
  });

  test('removeCartItem removes the matching entry', () async {
    final items = [
      {'title': 'Bag', 'size': 'One', 'colour': 'Brown', 'quantity': 1},
      {'title': 'Bag', 'size': 'One', 'colour': 'Black', 'quantity': 1},
    ];
    await writeCartItems(items);
    await removeCartItem(title: 'Bag', size: 'One', colour: 'Brown');
    final read = await readCartItems();
    expect(read, hasLength(1));
    expect(read.first['colour'], 'Black');
  });

  test('increaseCartItemQuantity increases quantity for existing item',
      () async {
    final item = {
      'title': 'Shoes',
      'size': '42',
      'colour': 'White',
      'quantity': 2,
      'addedAt': DateTime.utc(2020).toIso8601String(),
    };
    await writeCartItems([item]);

    await increaseCartItemQuantity(
      title: 'Shoes',
      size: '42',
      colour: 'White',
      count: 3,
    );

    final read = await readCartItems();
    expect(read, hasLength(1));
    expect(read.first['quantity'], 5);
    expect(DateTime.tryParse(read.first['addedAt'] ?? ''), isNotNull);
  });

  test('readCart is an alias for readCartItems', () async {
    final items = [
      {'title': 'Cap', 'size': 'S', 'colour': 'Yellow', 'quantity': 1}
    ];
    await writeCartItems(items);
    final a = await readCartItems();
    final b = await readCart();
    expect(b, equals(a));
  });
  
}