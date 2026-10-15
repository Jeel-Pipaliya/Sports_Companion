// ignore_for_file: avoid_print

// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// SUBJECT: AIUE302 - Mobile Application Development (Semester 5)
// PRACTICAL 1: Flutter Development Environment Setup & Project Initialization
// DOMAIN USE CASE: Sports Companion & Athlete Performance System
//
// FILE: bin/dart_fundamentals.dart
// PURPOSE: Comprehensive demonstration of Dart Programming Fundamentals:
//   1. Variables, Constants, and Null Safety (var, final, const, late, ?)
//   2. Built-in Data Types (int, double, String, bool, List, Set, Map)
//   3. Operators (Arithmetic, Relational, Logical, Null-Aware, Cascade)
//   4. Control Flow (if-else, switch expressions with pattern matching)
//   5. Looping Constructs (for, for-in, forEach, while, do-while)
//   6. Functions & Closures (named params, optional, arrow, higher-order)
//   7. Object-Oriented Programming (Classes, Objects, Encapsulation)
//   8. Constructors (Parameterized, Named, Factory)
//   9. Inheritance & Polymorphism (Overriding, Abstract classes, Mixins)
// ============================================================================

import 'dart:math';

// ----------------------------------------------------------------------------
// 1. ABSTRACT CLASS & INTERFACE DEFINITION
// ----------------------------------------------------------------------------
abstract class Trainable {
  void performTrainingSession(String drillName, int durationMinutes);
  double get recoveryIndex;
}

// ----------------------------------------------------------------------------
// 2. MIXIN FOR PERFORMANCE ANALYTICS
// ----------------------------------------------------------------------------
mixin PerformanceAnalyticsMixin {
  double calculateBmi({required double weightKg, required double heightM}) {
    if (heightM <= 0) return 0.0;
    return weightKg / (heightM * heightM);
  }

  String assessHeartRateZone(int bpm) {
    return switch (bpm) {
      < 100 => 'Resting Zone (Warm-up)',
      >= 100 && < 130 => 'Fat Burn Zone (Low Intensity)',
      >= 130 && < 160 => 'Aerobic Zone (Moderate Cardio)',
      >= 160 && < 180 => 'Anaerobic Zone (High Performance)',
      _ => 'Peak / Maximum Effort Zone',
    };
  }
}

// ----------------------------------------------------------------------------
// 3. BASE CLASS DEMONSTRATING ENCAPSULATION & CONSTRUCTORS
// ----------------------------------------------------------------------------
abstract class Athlete with PerformanceAnalyticsMixin implements Trainable {
  // Constant metadata
  static const String institution = 'CHARUSAT Sports Academy';

  // Final immutable fields
  final String athleteId;
  final String name;
  final String department;
  final int semester;
  final String email;

  // Encapsulated private fields with getters/setters
  double _fitnessScore; // 0.0 to 10.0
  double _attendancePercentage; // 0.0 to 100.0
  final List<String> _trainingLogs = [];

  // Parameterized constructor with initializing formals and asserts
  Athlete({
    required this.athleteId,
    required this.name,
    required this.department,
    this.semester = 5,
    required this.email,
    double initialFitness = 8.0,
    double initialAttendance = 90.0,
  })  : _fitnessScore = initialFitness,
        _attendancePercentage = initialAttendance;

  // Named constructor for novice / academy recruits
  Athlete.novice({
    required this.athleteId,
    required this.name,
    required this.department,
    required this.email,
  })  : semester = 1,
        _fitnessScore = 7.0,
        _attendancePercentage = 85.0;

  // Factory constructor for creating instances dynamically from a Map/JSON
  factory Athlete.fromJson(Map<String, dynamic> json) {
    final sport = (json['sport'] as String? ?? '').toLowerCase();
    if (sport.contains('football') || sport.contains('soccer')) {
      return FootballPlayer(
        athleteId: json['athleteId'] as String? ?? 'SPT000',
        name: json['name'] as String? ?? 'Unknown',
        department: json['department'] as String? ?? 'General Athletics',
        email: json['email'] as String? ?? 'athlete@charusat.edu.in',
        preferredPosition: json['position'] as String? ?? 'Midfielder',
        initialFitness: (json['fitnessScore'] as num?)?.toDouble() ?? 8.0,
        initialAttendance: (json['attendance'] as num?)?.toDouble() ?? 90.0,
      );
    } else {
      return TrackAthlete(
        athleteId: json['athleteId'] as String? ?? 'SPT000',
        name: json['name'] as String? ?? 'Unknown',
        department: json['department'] as String? ?? 'General Athletics',
        email: json['email'] as String? ?? 'athlete@charusat.edu.in',
        primaryEvent: json['event'] as String? ?? '100m Sprint',
        initialFitness: (json['fitnessScore'] as num?)?.toDouble() ?? 8.0,
        initialAttendance: (json['attendance'] as num?)?.toDouble() ?? 90.0,
      );
    }
  }

  // Getters
  double get fitnessScore => _fitnessScore;
  double get attendancePercentage => _attendancePercentage;
  List<String> get trainingLogs => List.unmodifiable(_trainingLogs);

  // Setters with validation logic
  set fitnessScore(double score) {
    if (score < 0.0 || score > 10.0) {
      throw ArgumentError('Fitness score must be between 0.0 and 10.0');
    }
    _fitnessScore = score;
  }

  set attendancePercentage(double percentage) {
    if (percentage < 0.0 || percentage > 100.0) {
      throw ArgumentError('Attendance must be between 0.0 and 100.0%');
    }
    _attendancePercentage = percentage;
  }

  // Implementation of Trainable interface
  @override
  void performTrainingSession(String drillName, int durationMinutes) {
    _trainingLogs.add('$drillName ($durationMinutes mins)');
    _fitnessScore = min(10.0, _fitnessScore + 0.05);
  }

  @override
  double get recoveryIndex => (_fitnessScore * 0.7) + (_attendancePercentage * 0.03);

  // Abstract methods to be overridden by subclasses (Polymorphism)
  String get sportType;
  double calculatePerformanceRating();
  void displayProfile();
}

// ----------------------------------------------------------------------------
// 4. SUBCLASSES DEMONSTRATING INHERITANCE AND POLYMORPHISM
// ----------------------------------------------------------------------------
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
    super.initialFitness,
    super.initialAttendance,
    required this.preferredPosition,
    this.goalsScored = 0,
    this.assists = 0,
  });

  @override
  String get sportType => 'Football (Soccer)';

  @override
  double calculatePerformanceRating() {
    // Custom algorithm for football performance
    final baseContribution = (goalsScored * 0.4) + (assists * 0.25);
    return min(10.0, (fitnessScore * 0.5) + (baseContribution * 0.5));
  }

  @override
  void displayProfile() {
    print('  [Football Player Profile]');
    print('  ID: $athleteId | Name: $name | Dept: $department');
    print('  Position: $preferredPosition | Goals: $goalsScored | Assists: $assists');
    print('  Fitness Score: ${fitnessScore.toStringAsFixed(1)}/10.0 | Attendance: ${attendancePercentage.toStringAsFixed(1)}%');
    print('  Performance Rating: ${calculatePerformanceRating().toStringAsFixed(2)}/10.0');
    print('  Recovery Index: ${recoveryIndex.toStringAsFixed(2)}');
  }
}

class TrackAthlete extends Athlete {
  final String primaryEvent; // e.g., "100m Sprint", "400m Hurdle"
  double personalBestSeconds;

  TrackAthlete({
    required super.athleteId,
    required super.name,
    required super.department,
    super.semester,
    required super.email,
    super.initialFitness,
    super.initialAttendance,
    required this.primaryEvent,
    this.personalBestSeconds = 11.2,
  });

  @override
  String get sportType => 'Track & Field';

  @override
  double calculatePerformanceRating() {
    // Sprint performance based on speed and fitness
    final speedFactor = personalBestSeconds > 0 ? (12.0 / personalBestSeconds) * 4.0 : 4.0;
    return min(10.0, (fitnessScore * 0.6) + min(4.0, speedFactor));
  }

  @override
  void displayProfile() {
    print('  [Track & Field Athlete Profile]');
    print('  ID: $athleteId | Name: $name | Dept: $department');
    print('  Event: $primaryEvent | Personal Best: ${personalBestSeconds}s');
    print('  Fitness Score: ${fitnessScore.toStringAsFixed(1)}/10.0 | Attendance: ${attendancePercentage.toStringAsFixed(1)}%');
    print('  Performance Rating: ${calculatePerformanceRating().toStringAsFixed(2)}/10.0');
    print('  Recovery Index: ${recoveryIndex.toStringAsFixed(2)}');
  }
}

// ----------------------------------------------------------------------------
// 5. HIGHER-ORDER FUNCTIONS AND CLOSURES
// ----------------------------------------------------------------------------
/// Returns a function (Closure) that calculates drill score scaled by difficulty
double Function(double baseRepetitions) createIntensityMultiplier(double multiplier) {
  return (double baseRepetitions) => baseRepetitions * multiplier;
}

/// Higher-order function taking a filtering predicate
List<Athlete> filterAthletes(List<Athlete> list, bool Function(Athlete) predicate) {
  return list.where(predicate).toList();
}

// ----------------------------------------------------------------------------
// 6. MAIN PROGRAM ENTRY POINT
// ----------------------------------------------------------------------------
void main() {
  print('====================================================================');
  print('  CHARUSAT - AIUE302 MOBILE APPLICATION DEVELOPMENT');
  print('  PRACTICAL 1: FLUTTER & DART PROGRAMMING FUNDAMENTALS');
  print('  DOMAIN: SMART SPORTS COMPANION APPLICATION');
  print('====================================================================\n');

  // --------------------------------------------------------------------------
  // SECTION 1: VARIABLES, CONSTANTS, AND DATA TYPES
  // --------------------------------------------------------------------------
  print('--- SECTION 1: VARIABLES, CONSTANTS, & DATA TYPES ---');
  
  // Variables with explicit and inferred types
  var appName = 'Sports Companion'; // Type inferred as String
  int totalAthletesRegistered = 142;
  double averageTeamStamina = 84.75;
  bool isSeasonActive = true;
  
  // Constants: compile-time (const) vs runtime (final)
  const String sportFederationCode = 'AIU-CHARUSAT-2026';
  final DateTime sessionStartTime = DateTime.now();

  // Late initialization variable
  late String matchVenue;
  matchVenue = 'CHARUSAT University Sports Complex Ground A';

  // Null safety features: nullable types and null-aware operators
  String? coachNotes; // nullable
  String effectiveNotes = coachNotes ?? 'Standard training regimen in effect.';

  print('App Name: $appName');
  print('Federation Code: $sportFederationCode (const)');
  print('Session Started (final): $sessionStartTime');
  print('Active Season: $isSeasonActive | Athletes: $totalAthletesRegistered');
  print('Average Team Stamina: $averageTeamStamina%');
  print('Match Venue (late): $matchVenue');
  print('Coach Notes (null-coalescing): $effectiveNotes');

  // Collections: List, Set, Map
  List<String> coreDisciplines = ['Football', 'Cricket', 'Athletics', 'Basketball', 'Badminton'];
  Set<String> uniqueFacilities = {'Gymnasium', 'Synthetic Track', 'Swimming Pool', 'Cricket Ground'};
  Map<String, double> qualifyingThresholds = {
    '100m Sprint': 11.5,
    'Cooper 12-min Run': 3000.0,
    'Beep Test Level': 12.5,
  };

  print('\nCore Sports Disciplines (List): $coreDisciplines');
  print('Unique Facilities Available (Set): $uniqueFacilities');
  print('Qualifying Standards (Map): $qualifyingThresholds\n');

  // --------------------------------------------------------------------------
  // SECTION 2: OPERATORS DEMONSTRATION
  // --------------------------------------------------------------------------
  print('--- SECTION 2: OPERATORS ---');
  int sprintReps = 10;
  int hurdleReps = 3;

  // Arithmetic
  int totalReps = sprintReps + hurdleReps;
  int quotient = sprintReps ~/ hurdleReps; // Truncating division
  int remainder = sprintReps % hurdleReps; // Modulo
  print('Arithmetic: $sprintReps + $hurdleReps = $totalReps | 10 ~/ 3 = $quotient (Rem: $remainder)');

  // Relational and Logical
  bool qualifiesForElite = (sprintReps >= 10) && (averageTeamStamina > 80.0);
  print('Relational & Logical Qualification Test: $qualifiesForElite');

  // Ternary Operator
  String readinessStatus = qualifiesForElite ? 'Match Ready (Elite)' : 'Requires Conditioning';
  print('Status (Ternary): $readinessStatus\n');

  // --------------------------------------------------------------------------
  // SECTION 3: DECISION-MAKING & SWITCH PATTERN MATCHING
  // --------------------------------------------------------------------------
  print('--- SECTION 3: DECISION-MAKING & PATTERN MATCHING ---');
  int athleteWeeklyDrillCount = 14;

  if (athleteWeeklyDrillCount >= 15) {
    print('Condition Check: Over-training alert! Recovery rest day recommended.');
  } else if (athleteWeeklyDrillCount >= 10) {
    print('Condition Check: Optimal training load maintained.');
  } else {
    print('Condition Check: Under-training notice. Increase drill frequency.');
  }

  // Modern Dart 3 Switch Expression with Pattern Matching
  String athleteTier = 'Senior Varsity';
  int trainingHoursPerWeek = switch (athleteTier) {
    'Academy Recruit' => 8,
    'Junior Varsity' => 12,
    'Senior Varsity' => 18,
    'Elite National' => 24,
    _ => 10,
  };
  print('Switch Expression: Tier "$athleteTier" trains $trainingHoursPerWeek hrs/week.\n');

  // --------------------------------------------------------------------------
  // SECTION 4: LOOPS AND ITERATION
  // --------------------------------------------------------------------------
  print('--- SECTION 4: LOOPS & ITERATION ---');
  print('For-in Loop over Core Disciplines:');
  for (var sport in coreDisciplines) {
    print('  -> Sport module active: $sport');
  }

  print('\nWhile Loop countdown to match sprint:');
  int countdown = 3;
  while (countdown > 0) {
    print('  Countdown: $countdown...');
    countdown--;
  }
  print('  GO! Match session started.');

  // --------------------------------------------------------------------------
  // SECTION 5: FUNCTIONS, OPTIONAL PARAMS, CLOSURES
  // --------------------------------------------------------------------------
  print('\n--- SECTION 5: FUNCTIONS & CLOSURES ---');
  // High-intensity training multiplier using closure
  var highAltitudeTraining = createIntensityMultiplier(1.35);
  double baselineScore = 50.0;
  double adjustedScore = highAltitudeTraining(baselineScore);
  print('Closure Multiplier: Baseline $baselineScore -> Adjusted $adjustedScore');

  // --------------------------------------------------------------------------
  // SECTION 6: OOP, CLASSES, CONSTRUCTORS & INHERITANCE
  // --------------------------------------------------------------------------
  print('\n--- SECTION 6: OBJECT-ORIENTED PROGRAMMING ---');

  // 1. Create Football Athlete instance using primary constructor
  final rahul = FootballPlayer(
    athleteId: '24SPT001',
    name: 'Rahul Patel',
    department: 'Computer Engineering (Varsity Squad)',
    semester: 5,
    email: 'rahul.patel@charusat.edu.in',
    initialFitness: 9.4,
    initialAttendance: 92.5,
    preferredPosition: 'Attacking Midfielder',
    goalsScored: 14,
    assists: 9,
  );

  // 2. Create Track Athlete instance using primary constructor
  final ananya = TrackAthlete(
    athleteId: '24SPT002',
    name: 'Ananya Sharma',
    department: 'Information Technology (Track Team)',
    semester: 5,
    email: 'ananya.sharma@charusat.edu.in',
    initialFitness: 9.1,
    initialAttendance: 95.0,
    primaryEvent: '100m Sprint',
    personalBestSeconds: 11.45,
  );

  // 3. Create Athlete via Factory constructor from JSON map
  final rookie = Athlete.fromJson({
    'sport': 'football',
    'athleteId': '24SPT088',
    'name': 'Devam Joshi',
    'department': 'Mechanical Engineering',
    'position': 'Goalkeeper',
    'fitnessScore': 8.2,
    'attendance': 88.0,
  });

  // Display profiles demonstrating Polymorphism
  print('\nDemonstrating Polymorphism with displayProfile():');
  rahul.displayProfile();
  print('');
  ananya.displayProfile();
  print('');
  rookie.displayProfile();

  // Demonstrate Mixin method
  double athleteBmi = rahul.calculateBmi(weightKg: 72.0, heightM: 1.78);
  String hrZone = rahul.assessHeartRateZone(165);
  print('\nMixin Performance Analytics for ${rahul.name}:');
  print('  Calculated BMI: ${athleteBmi.toStringAsFixed(1)} kg/m²');
  print('  Heart Rate Assessment (165 BPM): $hrZone');

  // Demonstrate Trainable interface method & Cascade operator (..)
  print('\nPerforming training session using cascade notation (..):');
  rahul
    ..performTrainingSession('Agility Ladder & Cone Drills', 45)
    ..performTrainingSession('Free Kick Precision', 30);
  print('  Updated Fitness Score: ${rahul.fitnessScore.toStringAsFixed(2)}/10.0');
  print('  Completed Drills: ${rahul.trainingLogs}');

  // Higher-order function filtering
  List<Athlete> roster = [rahul, ananya, rookie];
  final highPerformers = filterAthletes(roster, (ath) => ath.fitnessScore >= 9.0);
  print('\nFiltered High-Performing Athletes (Fitness >= 9.0):');
  for (var ath in highPerformers) {
    print('  - ${ath.name} (${ath.sportType}) - Fitness: ${ath.fitnessScore}');
  }

  print('\n====================================================================');
  print('  PRACTICAL 1 DART FUNDAMENTALS EXECUTION COMPLETED SUCCESSFULLY');
  print('====================================================================');
}
