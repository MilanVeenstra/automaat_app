import 'package:automaat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App shows home screen with welcome message', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AutoMaatApp());

    // Wait for any animations to complete
    await tester.pumpAndSettle();

    // Verify that the app title is displayed
    expect(find.text('AutoMaat'), findsOneWidget);

    // Verify that the welcome message is displayed
    expect(find.text('Welcome to AutoMaat'), findsOneWidget);
    expect(find.text('Your car rental app'), findsOneWidget);

    // Verify the car icon is present
    expect(find.byIcon(Icons.directions_car), findsOneWidget);
  });

  testWidgets('App renders without errors', (WidgetTester tester) async {
    // This is a simple smoke test to ensure the app starts
    await tester.pumpWidget(const AutoMaatApp());
    await tester.pumpAndSettle();

    // App should render without throwing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
