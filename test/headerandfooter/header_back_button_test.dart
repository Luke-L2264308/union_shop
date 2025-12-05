import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/headerandfooter/header.dart';

void main() {
  testWidgets('Header does not show back button on home route',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Header(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Assert there is no back arrow icon rendered on the home route
    expect(find.byIcon(Icons.arrow_back_ios), findsNothing);
    // Navigate to another page that also uses Header
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(MaterialPageRoute(builder: (_) => Scaffold(body: Header())));
    await tester.pumpAndSettle();

    // On the pushed page Header should show a back arrow
    expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);

    // Navigate back to home
    navigator.pop();
    await tester.pumpAndSettle();

    // Back on home the back arrow should not be present
    expect(find.byIcon(Icons.arrow_back_ios), findsNothing);
  });
  testWidgets('Header back button pops to previous route',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      initialRoute: '/first',
      routes: {
        '/first': (ctx) => MediaQuery(
              data: const MediaQueryData(size: Size(1200, 800)),
              child: Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(ctx, '/second'),
                    child: const Text('Go to Second'),
                  ),
                ),
              ),
            ),
        '/second': (ctx) => MediaQuery(
              data: const MediaQueryData(size: Size(1200, 800)),
              child: const Scaffold(body: Header()),
            ),
      },
    ));
    await tester.pumpAndSettle();

    // Start on first page
    expect(find.text('Go to Second'), findsOneWidget);

    // Navigate to second page which contains the Header
    await tester.tap(find.text('Go to Second'));
    await tester.pumpAndSettle();

    // Back button should be visible on the Header (top banner)
    expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);

    // Tap back icon and ensure we return to the first page
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    expect(find.text('Go to Second'), findsOneWidget);
  });

}
