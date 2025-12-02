import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart' as app;

void main() {
  

  
    testWidgets('Home page builds and contains a Scaffold', (WidgetTester tester) async {
      // Launch the app's main entrypoint; it should call runApp(...)
      app.main();
      await tester.pumpAndSettle();

      // Verify that the home page has a Scaffold (typical for material apps)
      expect(find.byType(Scaffold), findsOneWidget);
    });
  
}
