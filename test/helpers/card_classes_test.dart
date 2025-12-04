import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/helpers/card_classes.dart';

void main() {
  testWidgets('ProductCard tap navigates to provided route', (tester) async {
    const routeName = '/product-page';
    final widget = MaterialApp(
      routes: {
        routeName: (context) =>
            const Scaffold(body: Center(child: Text('product page'))),
      },
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: ProductCard(
              title: 'Prod',
              price: '£1',
              imageUrl: 'assets/images/does-not-exist.png',
              routeName: routeName,
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    // The title text is visible inside the ProductCard; tapping it should navigate.
    expect(find.text('Prod'), findsOneWidget);

    await tester.tap(find.text('Prod'));
    await tester.pumpAndSettle();

    expect(find.text('product page'), findsOneWidget);
  });

  testWidgets('CollectionCard tap navigates to provided route', (tester) async {
    const routeName = '/collection-page';
    final widget = MaterialApp(
      routes: {
        routeName: (context) =>
            const Scaffold(body: Center(child: Text('collection page'))),
      },
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            height: 200,
            child: CollectionCard(
              title: 'Collection Title',
              description: 'desc',
              imageUrl: 'assets/images/does-not-exist.png',
              routeName: routeName,
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    expect(find.text('Collection Title'), findsOneWidget);

    await tester.tap(find.text('Collection Title'));
    await tester.pumpAndSettle();

    expect(find.text('collection page'), findsOneWidget);
  });
}
