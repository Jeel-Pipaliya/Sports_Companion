// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// SUBJECT: AIUE302 - Mobile Application Development
// DOMAIN: Smart Sports Companion Application
//
// FILE: lib/models/athlete.dart
// PURPOSE: Object-Oriented Athlete domain model hierarchy demonstrating:
//   - Encapsulation (private fields, validation in setters, immutable getters)
//   - Abstract Classes & Interfaces (Trainable)
//   - Mixins (PerformanceMetricsMixin)
//   - Inheritance & Polymorphism (Athlete -> FootballPlayer, TrackAthlete)
//   - Multiple Constructors (Parameterized, Named, Factory)
// ============================================================================

import 'dart:math';

/// Interface defining trainable sports behavior
abstract class Trainable {
  void performTrainingSession(String drillName, int durationMinutes);
  double get recoveryIndex;
}

/// Mixin providing shared athletic performance metrics
mixin PerformanceMetricsMixin {
  /// Calculates Body Mass Index (BMI)
  double calculateBmi({required double weightKg, required double heightM}) {
    if (heightM <= 0) return 0.0;
    return weightKg / (heightM * heightM);
  }

  /// Classifies athlete heart rate into target cardiovascular training zones
  String getHeartRateZone(int bpm) {
    return switch (bpm) {
      < 100 => 'Warm-up / Recovery Zone',
      >= 100 && < 130 => 'Fat-Burn / Aerobic Base Zone',
      >= 130 && < 160 => 'Cardio Endurance Zone',
      >= 160 && < 180 => 'Anaerobic Threshold Zone',
      _ => 'Maximum Effort / Peak VO2 Zone',
    };
  }
}

/// Abstract base class for all sports participants
abstract class Athlete with PerformanceMetricsMixin implements Trainable {
  static const String institution = 'CHARUSAT Sports Academy';

  final String athleteId;
  final String name;
  final String department;
  final int semester;
  final String email;
  final String contactPhone;
  final List<String> drills;

  // Encapsulated private variables
  double _fitnessScore; // 0.0 to 10.0
  double _attendancePercentage; // 0.0 to 100.0
  final List<String> _trainingLogs = [];

  // Parameterized constructor
  Athlete({
    required this.athleteId,
    required this.name,
    required this.department,
    this.semester = 5,
    required this.email,
    required this.contactPhone,
    required this.drills,
    double initialFitness = 8.5,
    double initialAttendance = 90.0,
  })  : _fitnessScore = initialFitness,
        _attendancePercentage = initialAttendance;

  // Named constructor for novice recruits
  Athlete.novice({
    required this.athleteId,
    required this.name,
    required this.department,
    required this.email,
    required this.contactPhone,
  })  : semester = 1,
        drills = const ['Basic Conditioning', 'Stretching'],
        _fitnessScore = 7.0,
        _attendancePercentage = 85.0;

  // Factory constructor to deserialize from Map/JSON
  factory Athlete.fromJson(Map<String, dynamic> json) {
    final sport = (json['sport'] as String? ?? '').toLowerCase();
    final drillsList = (json['drills'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        ['General Conditioning'];

    if (sport.contains('football') || sport.contains('soccer')) {
      return FootballPlayer(
        athleteId: json['athleteId'] as String? ?? 'SPT000',
        name: json['name'] as String? ?? 'Unknown Athlete',
        department: json['department'] as String? ?? 'General Athletics',
        semester: json['semester'] as int? ?? 5,
        email: json['email'] as String? ?? 'athlete@charusat.edu.in',
        contactPhone: json['phone'] as String? ?? '+91 9876543210',
        drills: drillsList,
        preferredPosition: json['position'] as String? ?? 'Midfielder',
        initialFitness: (json['fitnessScore'] as num?)?.toDouble() ?? 8.5,
        initialAttendance:
            (json['trainingAttendance'] as num?)?.toDouble() ?? 90.0,
        goalsScored: json['goals'] as int? ?? 14,
        assists: json['assists'] as int? ?? 9,
      );
    } else {
      return TrackAthlete(
        athleteId: json['athleteId'] as String? ?? 'SPT000',
        name: json['name'] as String? ?? 'Unknown Athlete',
        department: json['department'] as String? ?? 'General Athletics',
        semester: json['semester'] as int? ?? 5,
        email: json['email'] as String? ?? 'athlete@charusat.edu.in',
        contactPhone: json['phone'] as String? ?? '+91 9876543210',
        drills: drillsList,
        primaryEvent: json['event'] as String? ?? '100m Sprint',
        initialFitness: (json['fitnessScore'] as num?)?.toDouble() ?? 8.5,
        initialAttendance:
            (json['trainingAttendance'] as num?)?.toDouble() ?? 90.0,
        personalBestSeconds:
            (json['personalBestSeconds'] as num?)?.toDouble() ?? 11.45,
      );
    }
  }

  // Getters
  double get fitnessScore => _fitnessScore;
  double get attendancePercentage => _attendancePercentage;
  List<String> get trainingLogs => List.unmodifiable(_trainingLogs);

  // Setters with defensive input validation
  set fitnessScore(double score) {
    if (score < 0.0 || score > 10.0) {
      throw ArgumentError('Fitness score must be between 0.0 and 10.0');
    }
    _fitnessScore = score;
  }

  set attendancePercentage(double percentage) {
    if (percentage < 0.0 || percentage > 100.0) {
      throw ArgumentError('Attendance must be within 0.0% and 100.0%');
    }
    _attendancePercentage = percentage;
  }

  // Trainable interface implementation
  @override
  void performTrainingSession(String drillName, int durationMinutes) {
    _trainingLogs.add('$drillName ($durationMinutes mins)');
    _fitnessScore = min(10.0, _fitnessScore + 0.05);
  }

  @override
  double get recoveryIndex =>
      (_fitnessScore * 0.7) + (_attendancePercentage * 0.03);

  // Abstract polymorphic methods
  String get sportType;
  double calculatePerformanceRating();
  String get primaryRoleBadge;
}

/// Football player specialization
class FootballPlayer extends Athlete {
  final String preferredPosition;
  int goalsScored;
  int assists;

  FootballPlayer({
    required super.athleteId,
    required super.name,
    required super.department,
    super.semester,
    required super.email,
    required super.contactPhone,
    required super.drills,
    super.initialFitness,
    super.initialAttendance,
    required this.preferredPosition,
    this.goalsScored = 0,
    this.assists = 0,
  });

  @override
  String get sportType => 'Football (Soccer)';

  @override
  String get primaryRoleBadge => '$preferredPosition (#10)';

  @override
  double calculatePerformanceRating() {
    final offensiveContrib = (goalsScored * 0.35) + (assists * 0.25);
    return min(10.0, (fitnessScore * 0.5) + min(5.0, offensiveContrib));
  }
}

/// Track & Field athlete specialization
class TrackAthlete extends Athlete {
  final String primaryEvent;
  double personalBestSeconds;

  TrackAthlete({
    required super.athleteId,
    required super.name,
    required super.department,
    super.semester,
    required super.email,
    required super.contactPhone,
    required super.drills,
    super.initialFitness,
    super.initialAttendance,
    required this.primaryEvent,
    this.personalBestSeconds = 11.45,
  });

  @override
  String get sportType => 'Track & Field';

  @override
  String get primaryRoleBadge => '$primaryEvent (${personalBestSeconds}s)';

  @override
  double calculatePerformanceRating() {
    final speedIndex = personalBestSeconds > 0
        ? (12.0 / personalBestSeconds) * 4.5
        : 4.5;
    return min(10.0, (fitnessScore * 0.55) + min(4.5, speedIndex));
  }
}
