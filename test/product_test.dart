import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/headerandfooter/footer.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/productpagetemplates/product_page.dart';
import 'package:union_shop/productpagetemplates/collections_list.dart';
void main() {
  group('Product Page Tests', () {
    Widget createTestWidget() {
      return const MaterialApp(home: HomeScreen());
    }

    

    testWidgets('should display header icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that header icons are present
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should display footer', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Check that footer is present
      expect(find.byType(Footer), findsOneWidget);
    });
  });
}
