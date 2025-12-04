import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart' show UnionShopApp;
import 'package:union_shop/pageswithoutproducts/aboutus_page.dart';
import 'package:union_shop/productpagetemplates/collections_list.dart';
import 'package:union_shop/pageswithoutproducts/signin.dart';

void main() {
  testWidgets('Named routes push the expected pages',
      (WidgetTester tester) async {
    await tester.pumpWidget(const UnionShopApp());

    // Wait for initial build
    await tester.pumpAndSettle();

    // Get a BuildContext from the app's Navigator so we can call pushNamed
    final navigatorFinder = find.byType(Navigator);
    expect(navigatorFinder, findsOneWidget);
    final navigatorContext = tester.element(navigatorFinder);

    // Helper to navigate and assert
    Future<void> pushAndExpect(String routeName, Type expectedType) async {
      Navigator.of(navigatorContext).pushNamed(routeName);
      await tester.pumpAndSettle();
      expect(find.byType(expectedType), findsOneWidget,
          reason: 'Route $routeName should show $expectedType');
      // Pop back to home for the next route test
      Navigator.of(navigatorContext).pop();
      await tester.pumpAndSettle();
    }

    // About page
    await pushAndExpect('/aboutus', AboutUsPage);

    // Collections page
    await pushAndExpect('/collection', Collections);

    // Sign-in page
    await pushAndExpect('/signin', SignInPage);

    await pushAndExpect('/collection/autumn-favourites',
        AutumnFavouritesPage); 

    await pushAndExpect('/collection/black-friday',
        BlackFridayPage);
    await pushAndExpect('/collection/clothing',
        ClothingPage);
    await pushAndExpect('/collection/graduation',
        GraduationPage);
    await pushAndExpect('/collection/merchandise',
        MerchandisePage);
    await pushAndExpect('/collection/personalisation',
        PersonalisationPage);
    
  });
}
