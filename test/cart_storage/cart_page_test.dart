import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/cart_storage/cart_page.dart';

void main() {
  

  testWidgets('CartPage shows empty state when no items', (tester) async {
    // readCart returns empty list
    Future<List<Map<String, dynamic>>> readCart() async =>
        <Map<String, dynamic>>[];

    await tester.pumpWidget(MaterialApp(home: CartPage(readCartFn: readCart)));

    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty'), findsOneWidget);
  });

  testWidgets('Tapping add/remove one/remove all calls provided callbacks',
      (tester) async {
    // initial cart with one item
    Future<List<Map<String, dynamic>>> readCart() async => [
          {
            'title': 'Test Item',
            'quantity': 2,
            'size': 'M',
            'colour': 'Blue',
          }
        ];

    var increaseCalls = 0;
    var decreaseCalls = 0;
    var removeCalls = 0;

    Future<void> increaseFn({
      required String title,
      required String size,
      required String colour,
      required int count,
    }) async {
      increaseCalls += 1;
    }

    Future<void> decreaseFn({
      required String title,
      required String size,
      required String colour,
      required int count,
    }) async {
      decreaseCalls += 1;
    }

    Future<void> removeFn({
      required String title,
      required String size,
      required String colour,
    }) async {
      removeCalls += 1;
    }

    await tester.pumpWidget(MaterialApp(
      home: CartPage(
        readCartFn: readCart,
        increaseFn: increaseFn,
        decreaseFn: decreaseFn,
        removeFn: removeFn,
      ),
    ));

    await tester.pumpAndSettle();

    // item is displayed
    expect(find.text('Test Item'), findsOneWidget);
    expect(find.textContaining('Qty:'), findsOneWidget);

    // tap add
    await tester.tap(find.byTooltip('Add one'));
    await tester.pumpAndSettle();
    expect(increaseCalls, 1);

    // tap remove one
    await tester.tap(find.byTooltip('Remove one'));
    await tester.pumpAndSettle();
    expect(decreaseCalls, 1);

    // tap delete (remove all) and confirm dialog
    await tester.tap(find.byTooltip('Remove all'));
    await tester.pumpAndSettle(); // show dialog
    expect(find.text('Remove this item from the cart?'), findsOneWidget);

    await tester.tap(find.text('Remove'));
    await tester.pumpAndSettle();
    expect(removeCalls, 1);
  });

}
