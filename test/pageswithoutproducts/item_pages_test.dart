import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/helpers/item_pages.dart';
import 'package:union_shop/productpagetemplates/product_page.dart';

void main() {
  testWidgets('CollectionItemPage finds item and returns ProductPage',
      (tester) async {
    // Use a route that exists in assets/collection_list.json
    const route = '/collection/autumn-favourites/autumn-knit-scarf';

    await tester.pumpWidget(
        const MaterialApp(home: CollectionItemPage(routeName: route)));

    // Wait for FutureBuilder to complete loading assets and building the ProductPage
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Expect a ProductPage to be built for the found item
    expect(find.byType(ProductPage), findsOneWidget);
  });
}
