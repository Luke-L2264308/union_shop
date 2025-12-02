import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/cart_storage/cart_page.dart';

void main() {
  testWidgets('CartPage shows empty state when no items', (tester) async {
    // readCart returns empty list
    Future<List<Map<String, dynamic>>> readCart() async => <Map<String, dynamic>>[];

    await tester.pumpWidget(MaterialApp(home: CartPage(readCartFn: readCart)));

    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty'), findsOneWidget);
  });
