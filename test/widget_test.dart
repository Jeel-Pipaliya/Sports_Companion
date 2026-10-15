import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_companion/main.dart';

void main() {
  testWidgets('Practical 2: Splash to Login and Dashboard Navigation Test',
      (WidgetTester tester) async {
    // 1. Build our app and trigger a frame.
    await tester.pumpWidget(const SportsCompanionApp());
    await tester.pumpAndSettle();

    // 2. Verify Splash Screen
    expect(find.text('Sports Companion'), findsOneWidget);
    expect(find.text('CHARUSAT Athletic & Performance Hub'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // 3. Tap 'Get Started' to navigate to Login Screen
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // 4. Verify Login Screen elements
    expect(find.text('Welcome to Sports Hub'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
    expect(find.text('Register Now'), findsOneWidget);

    // 5. Trigger Form Validation by clearing and pressing Sign In
    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your Enrollment ID or Email'), findsOneWidget);

    // 6. Enter valid credentials and Sign In
    await tester.enterText(find.byType(TextFormField).first, '24AIML051');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle();

    // 7. Verify Dashboard displays student info and modules
    expect(find.text('Jeel Pipaliya'), findsOneWidget);
    expect(find.text('24AIML051 • Semester V'), findsOneWidget);
    expect(find.text('91% (Target: >=85%)'), findsOneWidget);
    expect(find.text('Sports Modules'), findsOneWidget);

    // 8. Navigate to Athlete Profile tab
    await tester.tap(find.text('Athlete Profile'));
    await tester.pumpAndSettle();

    // Verify Profile content
    expect(find.text('Primary Discipline'), findsOneWidget);
    expect(find.text('Football & Athletics'), findsOneWidget);
  });
}
