import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/pageswithoutproducts/signin.dart';

void main() {
  Widget makeTestableWidget() {
    return const MaterialApp(home: SignInPage());
  }

  testWidgets('shows email validation snackbar for invalid email', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    // Enter invalid email and a valid password
    await tester.enterText(find.bySemanticsLabel('Email'), 'invalid-email');
    await tester.enterText(find.bySemanticsLabel('Password'), 'validPass123');

    // Tap sign in
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pump(); // start animation
    await tester.pump(const Duration(seconds: 1)); // allow SnackBar to appear

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });

  testWidgets('shows password length snackbar for short password', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    // Enter valid email and short password
    await tester.enterText(find.bySemanticsLabel('Email'), 'user@example.com');
    await tester.enterText(find.bySemanticsLabel('Password'), '123');

    // Tap sign in
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  
}