import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_companion/main.dart';

void main() {
  testWidgets('Practical 3: Responsive Layout Widgets & Multi-Screen Test',
      (WidgetTester tester) async {
    // 1. Build root app with a standard mobile viewport (width 400, height 850)
    tester.view.physicalSize = const Size(400, 850);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(const SportsCompanionApp());
    await tester.pumpAndSettle();

    // 2. Verify Splash Screen
    expect(find.text('Sports Companion'), findsOneWidget);
    expect(find.text('CHARUSAT Student Academic & Athletic Hub'), findsOneWidget);
    expect(find.text('Practical 3: Responsive Layout Widgets (CO2)'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // 3. Navigate from Splash to Login
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // 4. Verify Login Screen
    expect(find.text('Welcome to Sports Hub'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);

    // 5. Test validation trigger
    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle();
    expect(find.text('Please enter your Enrollment ID or Email'), findsOneWidget);

    // 6. Enter valid credentials and authenticate
    await tester.enterText(find.byType(TextFormField).first, '24AIML051');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle();

    // 7. MODULE 1: Course Dashboard Verification
    expect(find.text('Course & Sports Dashboard'), findsOneWidget);
    expect(find.text('Jeel Pipaliya'), findsOneWidget);
    expect(find.text('24AIML051 • Semester V'), findsOneWidget);
    expect(find.text('91.25%'), findsOneWidget);
    expect(find.text('DBMS'), findsOneWidget);
    expect(find.text('MAD'), findsOneWidget);
    expect(find.text('AI'), findsOneWidget);
    expect(find.text('CN'), findsOneWidget);

    // 8. MODULE 2: Attendance Summary Module Navigation
    await tester.tap(find.text('Attendance'));
    await tester.pumpAndSettle();
    expect(find.text('Cumulative Attendance'), findsOneWidget);
    expect(find.text('Database Management Systems'), findsOneWidget);
    expect(find.text('92%'), findsOneWidget);
    expect(find.text('88%'), findsOneWidget);
    expect(find.text('95%'), findsOneWidget);
    expect(find.text('90%'), findsOneWidget);

    // 9. MODULE 3: Timetable Module Navigation
    await tester.tap(find.text('Timetable'));
    await tester.pumpAndSettle();
    expect(find.text('Monday'), findsOneWidget);
    expect(find.text('Tuesday'), findsOneWidget);
    expect(find.text('Wednesday'), findsOneWidget);
    expect(find.text('MAD Practical Lab (P3)'), findsOneWidget);

    // 10. MODULE 4: Assignment List Navigation
    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();
    expect(find.text('Flutter UI Design (Practical 2)'), findsOneWidget);
    expect(find.text('Database CRUD & Normalization'), findsOneWidget);
    expect(find.text('REST API Integration & JSON Parsing'), findsOneWidget);

    // 11. MODULE 7: Event Gallery GridView Navigation
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('CHARUSAT Spoural 2026'), findsOneWidget);
    expect(find.text('National Flutter Hackathon'), findsOneWidget);
    expect(find.text('AI & Deep Learning Summit'), findsOneWidget);
    expect(find.text('Inter-Dept Football Cup'), findsOneWidget);

    // 12. Test Drawer Navigation for Faculty and Notifications
    final scaffoldState = tester.firstState<ScaffoldState>(find.byType(Scaffold).first);
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Faculty Information'), findsOneWidget);
    expect(find.text('Notifications & Alerts'), findsOneWidget);

    // Tap Faculty Information
    await tester.tap(find.text('Faculty Information'));
    await tester.pumpAndSettle();
    expect(find.text('Prof. Parth Patel'), findsOneWidget);
    expect(find.text('Dr. Sneha Sharma'), findsOneWidget);
    expect(find.text('Prof. Amit Shah'), findsOneWidget);

    // 13. Test Responsive Viewport Simulation Toggle & Tablet Breakpoint
    expect(find.text('Mobile Layout (<720px)'), findsOneWidget);
    tester.view.physicalSize = const Size(800, 1000);
    await tester.tap(find.text('Mobile Layout (<720px)'));
    await tester.pumpAndSettle();

    // Verify NavigationRail appeared in Tablet layout mode
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.text('Tablet Layout (>=720px)'), findsOneWidget);
  });
}
