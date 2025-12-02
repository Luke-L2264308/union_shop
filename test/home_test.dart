import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/headerandfooter/header.dart';
import 'package:union_shop/headerandfooter/footer.dart';
import 'package:union_shop/main.dart' as app;

void main() {
  testWidgets('Home page builds and contains a Scaffold',
      (WidgetTester tester) async {
    // Launch the app's main entrypoint; it should call runApp(...)
    app.main();
    await tester.pumpAndSettle();

    // Verify that the home page has a Scaffold (typical for material apps)
    expect(find.byType(Scaffold), findsOneWidget);
  });
  testWidgets('Home page contains a header', (WidgetTester tester) async {
    // Launch the app
    app.main();
    await tester.pumpAndSettle();

    // Verify that there is an AppBar on the home page
    expect(find.byType(Header), findsOneWidget);
  });

  testWidgets('Home page contains a footer', (WidgetTester tester) async {
    // Launch the app
    app.main();
    await tester.pumpAndSettle();

    // Verify that there is a Footer on the home page
    expect(find.byType(Footer), findsOneWidget);
  });
}
