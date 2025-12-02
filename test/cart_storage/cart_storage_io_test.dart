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

    channel.setMockMethodCallHandler((call) async {
      if (call.method == 'getApplicationDocumentsDirectory') {
        return tempDir.path;
      }
      return null;
    });
  });

  tearDown(() async {
    channel.setMockMethodCallHandler(null);
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
}
