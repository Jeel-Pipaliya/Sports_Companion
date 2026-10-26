// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development (Semester 5)
// PRACTICAL 5: Automated Verification & Unit/Widget Test Suite
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_companion/preferences_service.dart';
import 'package:sports_companion/practical5_navigation.dart';
import 'package:sports_companion/navigation_widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Setup in-memory mock values for SharedPreferences
    SharedPreferences.setMockInitialValues({
      PreferencesService.keyIsLoggedIn: false,
      PreferencesService.keyRememberMe: true,
      PreferencesService.keyUserEmail: 'rahul.patel@charusat.edu.in',
      PreferencesService.keyUserName: 'Rahul Patel',
      PreferencesService.keyEnrollmentNo: '24AIML051',
      PreferencesService.keyDepartment: 'Artificial Intelligence & Machine Learning',
      PreferencesService.keySelectedTheme: 'System',
      PreferencesService.keySelectedLanguage: 'English',
      PreferencesService.keySelectedSemester: 'Semester V',
      PreferencesService.keyNotificationsEnabled: true,
      PreferencesService.keyAttendanceThreshold: 85.0,
      PreferencesService.keySportsInterest: 'Athletics & Badminton',
    });
    await PreferencesService().init();
  });

  group('Practical 5: PreferencesService Unit Tests', () {
    test('Verifies default values upon initialization', () {
      final prefs = PreferencesService();
      expect(prefs.isLoggedIn, false);
      expect(prefs.rememberMe, true);
      expect(prefs.userEmail, 'rahul.patel@charusat.edu.in');
      expect(prefs.userName, 'Rahul Patel');
      expect(prefs.selectedTheme, 'System');
      expect(prefs.selectedLanguage, 'English');
      expect(prefs.selectedSemester, 'Semester V');
      expect(prefs.notificationsEnabled, true);
      expect(prefs.attendanceThreshold, 85.0);
    });

    test('Verifies saveUserSession persists authenticated status', () async {
      final prefs = PreferencesService();
      await prefs.saveUserSession(
        email: 'rahul.patel@charusat.edu.in',
        name: 'Rahul Patel',
        rememberMe: true,
      );
      expect(prefs.isLoggedIn, true);
      expect(prefs.userEmail, 'rahul.patel@charusat.edu.in');
      expect(prefs.userName, 'Rahul Patel');

      // Verify on disk mock
      final sp = await SharedPreferences.getInstance();
      expect(sp.getBool(PreferencesService.keyIsLoggedIn), true);
    });

    test('Verifies clearUserSession clears login session on Logout', () async {
      final prefs = PreferencesService();
      await prefs.saveUserSession(
        email: 'rahul.patel@charusat.edu.in',
        name: 'Rahul Patel',
        rememberMe: false,
      );
      expect(prefs.isLoggedIn, true);

      await prefs.clearUserSession();
      expect(prefs.isLoggedIn, false);

      final sp = await SharedPreferences.getInstance();
      expect(sp.getBool(PreferencesService.keyIsLoggedIn), false);
    });

    test('Verifies theme, language, and semester preference updates', () async {
      final prefs = PreferencesService();
      await prefs.setTheme('Dark');
      expect(prefs.selectedTheme, 'Dark');

      await prefs.setLanguage('Gujarati');
      expect(prefs.selectedLanguage, 'Gujarati');

      await prefs.setSemester('Semester VI');
      expect(prefs.selectedSemester, 'Semester VI');

      await prefs.setNotificationsEnabled(false);
      expect(prefs.notificationsEnabled, false);

      await prefs.setAttendanceThreshold(88.0);
      expect(prefs.attendanceThreshold, 88.0);
    });

    test('Verifies resetToDefaults restores university standard preferences', () async {
      final prefs = PreferencesService();
      await prefs.setTheme('Dark');
      await prefs.setLanguage('Hindi');
      await prefs.resetToDefaults();

      expect(prefs.selectedTheme, 'System');
      expect(prefs.selectedLanguage, 'English');
      expect(prefs.selectedSemester, 'Semester V');
      expect(prefs.notificationsEnabled, true);
      expect(prefs.attendanceThreshold, 85.0);
    });
  });

  group('Practical 5: Widget & Navigation UI Tests', () {
    testWidgets('Renders Practical5HubScreen and verifies TabBar & methods', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1024, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: const Practical5HubScreen(),
          routes: {
            '/dashboard': (_) => const Scaffold(body: Text('Dashboard View')),
            '/attendance': (_) => const Scaffold(body: Text('Attendance View')),
            '/profile': (_) => const Scaffold(body: Text('Profile View')),
            '/settings': (_) => const Scaffold(body: Text('Settings View')),
            '/login': (_) => const Scaffold(body: Text('Login View')),
          },
        ),
      );
      await tester.pumpAndSettle();

      // Verify title and Tab headers
      expect(find.text('Practical 5: Navigation & Routing Hub'), findsOneWidget);
      expect(find.text('Routing Methods'), findsOneWidget);
      expect(find.text('Shared Preferences'), findsOneWidget);
      expect(find.text('Flow Architecture'), findsOneWidget);

      // Verify Navigator method demonstrations
      expect(find.text('Navigator.pushNamed()'), findsOneWidget);
      expect(find.text('Navigator.pushReplacementNamed()'), findsOneWidget);
      expect(find.text('Navigator.pushNamedAndRemoveUntil()'), findsOneWidget);
    });

    testWidgets('Renders PersistentSettingsScreen and interacts with preferences', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1024, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: PersistentSettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Persistent User Preferences'), findsOneWidget);
      expect(find.text('Persistent Configuration Engine'), findsOneWidget);
      expect(find.text('1. Application Theme Mode (SharedPreferences)'), findsOneWidget);
      expect(find.text('2. Trilingual Localization (SharedPreferences)'), findsOneWidget);
      expect(find.text('3. Academic Enrollment Semester'), findsOneWidget);
      expect(find.text('4. System Notifications & Alerts'), findsOneWidget);

      // Tap Theme Radio
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      expect(PreferencesService().selectedTheme, 'Dark');

      // Tap Language Radio
      await tester.tap(find.text('Hindi'));
      await tester.pumpAndSettle();
      expect(PreferencesService().selectedLanguage, 'Hindi');

      // Toggle Notification Switch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(PreferencesService().notificationsEnabled, false);
    });

    testWidgets('Renders StudentProfileScreen and verifies session data', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1024, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: StudentProfileScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Student Academic Profile'), findsOneWidget);
      expect(find.text('Rahul Patel'), findsNWidgets(2));
      expect(find.text('rahul.patel@charusat.edu.in'), findsNWidgets(2));
      expect(find.text('24AIML051'), findsOneWidget);
      expect(find.text('Update Preferences in Settings'), findsOneWidget);
    });

    testWidgets('Renders AppNavigationDrawer and displays session headers', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1024, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            drawer: const AppNavigationDrawer(currentRoute: '/dashboard'),
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => Scaffold.of(ctx).openDrawer(),
                child: const Text('Open Drawer'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Drawer'));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard Hub'), findsOneWidget);
      expect(find.text('Attendance Summary'), findsOneWidget);
      expect(find.text('Academic Timetable'), findsOneWidget);
      expect(find.text('Practical 5 Navigation Hub'), findsOneWidget);
      expect(find.text('Persistent Settings'), findsOneWidget);
      expect(find.text('Logout Session'), findsOneWidget);
    });
  });
}
