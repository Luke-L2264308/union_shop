import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/headerandfooter/header.dart';
import 'package:union_shop/headerandfooter/footer.dart';
import 'package:union_shop/productpagetemplates/collections_list.dart';


void main() {
  testWidgets('Home page builds and contains a Scaffold',
      (WidgetTester tester) async {
    // Build HomeScreen directly rather than calling app.main()
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pump();

    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('Home page contains a header', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pump();

    expect(find.byType(Header), findsOneWidget);
  });

  testWidgets('Home page contains a footer', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pump();

    expect(find.byType(Footer), findsOneWidget);
  });

  
}
