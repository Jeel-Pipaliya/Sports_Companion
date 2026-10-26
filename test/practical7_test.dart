// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development (Semester 5)
// PRACTICAL 7: RESTful API Integration & JSON Serialization Test Suite
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_companion/api_service.dart';
import 'package:sports_companion/practical7_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Practical 7: JSON Serialization & DTO Unit Tests', () {
    test('Verifies AcademicNotice.fromJson parses API payload correctly', () {
      final sampleJson = {
        'id': 10,
        'title': 'Mid-Semester Exam Timetable Published',
        'body': 'Examination cell announces dates for theory subjects.',
        'tags': ['exam', 'changa', 'charusat'],
        'reactions': {'likes': 42, 'dislikes': 2},
        'views': 450,
      };

      final notice = AcademicNotice.fromJson(sampleJson);

      expect(notice.id, 10);
      expect(notice.title, 'Mid-Semester Exam Timetable Published');
      expect(notice.category, 'Examinations');
      expect(notice.reactions, 44);
      expect(notice.views, 450);
      expect(notice.tags.contains('exam'), true);
    });

    test('Verifies AcademicNotice.toJson produces valid Map', () {
      final notice = AcademicNotice(
        id: 7,
        title: 'Sports Day 2026',
        body: 'Athletics tournament at university sports grounds.',
        category: 'Sports & Athletics',
        tags: ['sports', 'athletics'],
        reactions: 35,
        views: 310,
        date: '2026-10-26',
        organizer: 'Sports Department',
      );

      final jsonMap = notice.toJson();

      expect(jsonMap['id'], 7);
      expect(jsonMap['title'], 'Sports Day 2026');
      expect(jsonMap['category'], 'Sports & Athletics');
      expect(jsonMap['reactions'], 35);
    });

    test('Verifies EventRegistration.toJson generates valid POST body', () {
      final reg = EventRegistration(
        studentName: 'Jeel Pipaliya',
        enrollmentId: '24AIML051',
        email: 'jeel.pipaliya@charusat.edu.in',
        selectedEvent: 'AI & Mobile App Hackathon',
        department: 'B.Tech AI & ML',
        feedback: 'Excited to build Flutter apps with on-device SQLite.',
      );

      final payload = reg.toJson();

      expect(payload['studentName'], 'Jeel Pipaliya');
      expect(payload['enrollmentId'], '24AIML051');
      expect(payload['userId'], 51);
      expect(payload['body'], 'Excited to build Flutter apps with on-device SQLite.');
    });

    test('Verifies CampusEvent.fromJson maps user directory payload', () {
      final userJson = {
        'id': 1,
        'name': 'Prof. Leanne Graham',
        'company': {'name': 'CHARUSAT Research Lab'},
        'address': {'suite': 'Suite 556', 'city': 'Changa'},
      };

      final event = CampusEvent.fromJson(userJson);

      expect(event.id, 1);
      expect(event.title, 'Prof. Leanne Graham');
      expect(event.organizer, 'CHARUSAT Research Lab');
      expect(event.venue.contains('Changa'), true);
    });
  });

  group('Practical 7: ApiService Client Unit Tests', () {
    test('Verifies ApiService singleton returns notices with filtering', () async {
      final service = ApiService();
      final response = await service.fetchAcademicNotices();

      expect(response.isSuccess, true);
      expect(response.data, isNotNull);
      expect(response.data!.isNotEmpty, true);

      // Verify category filter
      final examResponse = await service.fetchAcademicNotices(
        categoryFilter: 'Examinations',
      );
      expect(examResponse.data!.every((n) => n.category == 'Examinations'), true);

      // Verify search query filter
      final queryResponse = await service.fetchAcademicNotices(
        searchQuery: 'TCS',
      );
      expect(queryResponse.data!.isNotEmpty, true);
      expect(queryResponse.data!.first.title.contains('TCS'), true);
    });

    test('Verifies submitRegistration returns HTTP 201 Created', () async {
      final service = ApiService();
      final reg = EventRegistration(
        studentName: 'Jeel Pipaliya',
        enrollmentId: '24AIML051',
        email: 'jeel.pipaliya@charusat.edu.in',
        selectedEvent: 'National AI Hackathon',
        department: 'AI & ML',
        feedback: 'Testing HTTP POST method.',
      );

      final response = await service.submitRegistration(reg);

      expect(response.isSuccess, true);
      expect(response.statusCode == 201 || response.statusCode == 200, true);
      expect(response.data, isNotNull);
    });
  });

  group('Practical 7: Widget & UI Integration Tests', () {
    testWidgets('Renders Practical7ApiHubScreen with 4 Tabs and Notices', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Practical7ApiHubScreen(onToggleTheme: () {}),
        ),
      );

      // Initial loading
      await tester.pumpAndSettle();

      expect(find.text('Practical 7: RESTful Web APIs'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Academic Notices'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Events Directory'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'HTTP POST Lab'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'API Contracts'), findsOneWidget);

      // Check search bar and filter chips
      expect(find.byType(TextField), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'All Categories'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Examinations'), findsOneWidget);
    });

    testWidgets('Switches to Events Directory tab', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Practical7ApiHubScreen(onToggleTheme: () {}, initialTabIndex: 1),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsWidgets);
    });

    testWidgets('Switches to HTTP POST Lab tab and checks Form controls', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Practical7ApiHubScreen(onToggleTheme: () {}, initialTabIndex: 2),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('HTTP POST Request Lab'), findsOneWidget);
      expect(find.text('Execute HTTP POST Request'), findsOneWidget);
      expect(find.text('Jeel Pipaliya'), findsOneWidget);
      expect(find.text('24AIML051'), findsOneWidget);
    });

    testWidgets('Switches to API Contracts tab and verifies documentation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Practical7ApiHubScreen(onToggleTheme: () {}, initialTabIndex: 3),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Practical 7 API Contracts & Endpoints'), findsOneWidget);
      expect(find.text('Postman cURL Command (HTTP POST Verification):'), findsOneWidget);
    });
  });
}
