import 'package:automaat_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders MaterialApp with router', (
    WidgetTester tester,
  ) async {
    // Build our app wrapped in ProviderScope and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: AutoMaatApp()));

    // Wait for initial frame
    await tester.pump();

    // App should render MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App shows AutoMaat title', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AutoMaatApp()));
    await tester.pumpAndSettle();

    // App title should be visible somewhere in the widget tree
    expect(find.text('AutoMaat'), findsWidgets);
  });
}
