// Basic widget test for First Steps app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:first_steps/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const FirstStepsApp());

    // Wait for async operations
    await tester.pumpAndSettle();

    // Verify that the app launches (checks for either loading indicator or profile registration)
    expect(
      find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
          find.text('プロフィール登録').evaluate().isNotEmpty,
      true,
    );
  });
}
