import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_companion/practical4_state_management.dart';

void main() {
  testWidgets('Practical 4: State Management & Dynamic Preferences Test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final mgr = PreferencesManager();
    mgr.resetDefaults();

    // 1. Verify Default Application State
    expect(mgr.state.studentName, 'Jeel Pipaliya');
    expect(mgr.state.enrollmentId, '24AIML051');
    expect(mgr.state.semester, 'Semester V');
    expect(mgr.state.language, 'English');
    expect(mgr.state.notifyAssignments, true);
    expect(mgr.state.notifyExams, true);
    expect(mgr.state.notifyPlacement, true);
    expect(mgr.state.notifyEvents, false);
    expect(mgr.state.dailyStudyGoal, 4.5);
    expect(mgr.state.attendanceAlertThreshold, 85.0);

    // 2. Build Practical 4 Hub
    await tester.pumpWidget(
      MaterialApp(
        home: Practical4HubScreen(onToggleTheme: () {}),
      ),
    );
    await tester.pumpAndSettle();

    // 3. Verify TabBar headers exist
    expect(find.text('1. Profile'), findsOneWidget);
    expect(find.text('2. Theme'), findsOneWidget);
    expect(find.text('3. Alerts'), findsOneWidget);
    expect(find.text('4. Language'), findsOneWidget);
    expect(find.text('5. Courses'), findsOneWidget);
    expect(find.text('6. Sliders & Customization'), findsOneWidget);
    expect(find.text('7. State Inspector'), findsOneWidget);

    // 4. Test Profile Module (Tab 0)
    expect(find.text('Module 1: Student Profile & Semester Selection'), findsOneWidget);
    expect(find.byType(DropdownButton<String>), findsWidgets);

    // 5. Navigate to Tab 2: Alerts & Checkboxes
    await tester.tap(find.text('3. Alerts'));
    await tester.pumpAndSettle();
    expect(find.text('Module 3: Notification Preferences (Checkboxes)'), findsOneWidget);
    expect(find.text('Assignment Alerts'), findsOneWidget);
    expect(find.text('Examination Notifications'), findsOneWidget);

    // 6. Navigate to Tab 4: Language & Radios
    await tester.tap(find.text('4. Language'));
    await tester.pumpAndSettle();
    expect(find.text('Module 4: Language Selection (Radio Buttons)'), findsOneWidget);
    expect(find.text('English (Default)'), findsOneWidget);
    expect(find.text('Hindi (हिन्दी)'), findsOneWidget);
    expect(find.text('Gujarati (ગુજરાતી)'), findsOneWidget);

    // 7. Navigate to Tab 6: Sliders
    await tester.tap(find.text('6. Sliders & Customization'));
    await tester.pumpAndSettle();
    expect(find.text('Module 6: Dashboard Customization & Sliders'), findsOneWidget);
    expect(find.byType(Slider), findsNWidgets(2));
  });
}
