import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/cart_storage/cart_storage_io.dart';
import 'package:union_shop/headerandfooter/header.dart';

void main() {
  testWidgets('Header.buildHeaderItems returns expected labels and callbacks',
      (WidgetTester tester) async {
    final header = Header();

    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        final items = header.buildHeaderItems(context);
        // Check labels
        expect(items.map((e) => e.label).toList(),
            ['Home', 'Shop', 'The Print Shack', 'SALE!', 'About Us']);
        // Ensure each item provides a non-null callback
        for (final it in items) {
          expect(it.onPressed, isNotNull);
          expect(it.onPressed, isA<Function>());
        }
        return const SizedBox.shrink();
      }),
    ));
  });
}
