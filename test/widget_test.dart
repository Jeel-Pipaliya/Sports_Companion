import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_companion/main.dart';

void main() {
  testWidgets('Sports Companion Dashboard renders athlete and metrics test', (
    WidgetTester tester,
  ) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const SportsCompanionApp());
    await tester.pumpAndSettle();

    // Verify dashboard elements
    expect(find.text('Sports Companion'), findsOneWidget);
    expect(find.text('Jeel Pipaliya'), findsOneWidget);
    expect(find.text('24AIML051'), findsOneWidget);
    expect(find.text('Drills Done'), findsOneWidget);

    // Tap the Log Drill FAB to open the drill selector sheet
    await tester.tap(find.widgetWithText(FloatingActionButton, 'Log Drill'));
    await tester.pumpAndSettle();

    // Verify bottom sheet appears
    expect(find.text('Select Training Drill to Log'), findsOneWidget);
  });
}
