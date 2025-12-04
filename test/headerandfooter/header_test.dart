import 'package:flutter/material.dart';
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
  testWidgets('Header shows inline buttons when width > 800',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(size: Size(1200, 800)),
        child: const Scaffold(body: Header()),
      ),
    ));
    await tester.pumpAndSettle();

    // Expect the 5 header TextButtons to be present inline
    expect(find.byType(TextButton), findsNWidgets(5));
    expect(find.byType(PopupMenuButton), findsNothing);

    // Labels should be visible as Text widgets
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('The Print Shack'), findsOneWidget);
    expect(find.text('SALE!'), findsOneWidget);
    expect(find.text('About Us'), findsOneWidget);
  });

  testWidgets('Header collapses into PopupMenu when width <= 800',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(size: Size(600, 800)),
        child: const Scaffold(body: Header()),
      ),
    ));
    await tester.pumpAndSettle();

    // Inline TextButtons should not be present; menu should be present
    expect(find.byType(TextButton), findsNothing);
    expect(find.byType(PopupMenuButton<HeaderItem>), findsOneWidget);

    // Open the popup menu and verify items are present
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('The Print Shack'), findsOneWidget);
    expect(find.text('SALE!'), findsOneWidget);
    expect(find.text('About Us'), findsOneWidget);
  });

  testWidgets('Clicking Shop navigates to /product',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/start',
      routes: {
        '/start': (ctx) => MediaQuery(
              data: const MediaQueryData(size: Size(1200, 800)),
              child: const Scaffold(body: Header()),
            ),
        '/product': (ctx) =>
            const Scaffold(body: Center(child: Text('Product Page'))),
      },
    ));
    await tester.pumpAndSettle();

    expect(find.text('Shop'), findsOneWidget);
    await tester.tap(find.text('Shop'));
    await tester.pumpAndSettle();

    expect(find.text('Product Page'), findsOneWidget);
  });
  testWidgets('Clicking About Us navigates to /aboutus',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/start',
      routes: {
        '/start': (ctx) => MediaQuery(
              data: const MediaQueryData(size: Size(1200, 800)),
              child: const Scaffold(body: Header()),
            ),
        '/aboutus': (ctx) =>
            const Scaffold(body: Center(child: Text('About Us Page'))),
      },
    ));
    await tester.pumpAndSettle();

    expect(find.text('About Us'), findsOneWidget);
    await tester.tap(find.text('About Us'));
    await tester.pumpAndSettle();

    expect(find.text('About Us Page'), findsOneWidget);
  });
  testWidgets(
      'Clicking Home navigates to / (root) with pushNamedAndRemoveUntil',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/start',
      routes: {
        '/start': (ctx) => MediaQuery(
              data: const MediaQueryData(size: Size(1200, 800)),
              child: const Scaffold(body: Header()),
            ),
        '/': (ctx) => const Scaffold(body: Center(child: Text('Home Page'))),
      },
    ));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Home Page'), findsOneWidget);
  });

  testWidgets('Clicking Sign In icon navigates to /signin',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/start',
      routes: {
        '/start': (ctx) => MediaQuery(
              data: const MediaQueryData(size: Size(1200, 800)),
              child: const Scaffold(body: Header()),
            ),
        '/signin': (ctx) =>
            const Scaffold(body: Center(child: Text('Sign In Page'))),
      },
    ));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    expect(find.text('Sign In Page'), findsOneWidget);
  });

  testWidgets('Clicking Cart icon navigates to /cart',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/start',
      routes: {
        '/start': (ctx) => MediaQuery(
              data: const MediaQueryData(size: Size(1200, 800)),
              child: const Scaffold(body: Header()),
            ),
        '/cart': (ctx) =>
            const Scaffold(body: Center(child: Text('Cart Page'))),
      },
    ));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Cart Page'), findsOneWidget);
  });
}
