// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// SUBJECT: AIUE302 - Mobile Application Development
// PRACTICAL 1: Flutter Environment Setup & Project Initialization
// FILE: test/widget_test.dart
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:sports_companion/main.dart';
import 'package:sports_companion/models/athlete.dart';

void main() {
  group('Practical 1: Athlete OOP Model Tests', () {
    test('FootballPlayer calculates performance rating and handles cascade drill log', () {
      final player = FootballPlayer(
        athleteId: '24SPT001',
        name: 'Rahul Patel',
        department: 'Computer Engineering',
        semester: 5,
        email: 'rahul.patel@charusat.edu.in',
        contactPhone: '+91 9876543210',
        preferredPosition: 'Attacking Midfielder',
        initialFitness: 9.4,
        initialAttendance: 92.5,
        drills: ['Sprint Drills'],
        goalsScored: 14,
        assists: 9,
      );

      expect(player.athleteId, equals('24SPT001'));
      expect(player.sportType, equals('Football (Soccer)'));
      expect(player.calculatePerformanceRating(), greaterThan(8.0));

      // Test cascade notation and encapsulation
      player
        ..performTrainingSession('Speed Endurance', 45)
        ..performTrainingSession('Dribbling Cones', 30);

      expect(player.trainingLogs.length, equals(2));
      expect(player.fitnessScore, greaterThan(9.4));
    });

    test('TrackAthlete calculates polymorphic speed index and Mixin BMI', () {
      final trackAth = TrackAthlete(
        athleteId: '24SPT002',
        name: 'Ananya Sharma',
        department: 'Information Technology',
        email: 'ananya.sharma@charusat.edu.in',
        contactPhone: '+91 9876543211',
        primaryEvent: '100m Sprint',
        personalBestSeconds: 11.45,
        drills: ['Block Starts'],
      );

      expect(trackAth.sportType, equals('Track & Field'));
      expect(trackAth.calculatePerformanceRating(), greaterThan(9.0));

      // Test Mixin
      final bmi = trackAth.calculateBmi(weightKg: 60.0, heightM: 1.68);
      expect(bmi, closeTo(21.25, 0.1));

      final zone = trackAth.getHeartRateZone(155);
      expect(zone, contains('Cardio'));
    });
  });

  group('Practical 1: UI Smoke Tests', () {
    testWidgets('SportsCompanionApp renders setup tabs and athlete cards',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SportsCompanionApp());
      await tester.pumpAndSettle();

      // Verify app bar title
      expect(find.text('Sports Companion'), findsOneWidget);
      expect(find.text('Setup & Arch'), findsOneWidget);
      expect(find.text('Dart Fundamentals'), findsOneWidget);
      expect(find.text('OOP & Athletes'), findsOneWidget);
      expect(find.text('Viva & Q/A'), findsOneWidget);
    });
  });
}
