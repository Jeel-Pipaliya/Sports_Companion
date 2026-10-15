// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// SUBJECT: AIUE302 - Mobile Application Development (Semester 5)
// PRACTICAL 1: Flutter Development Environment Setup & Project Initialization
// USE CASE: Sports Companion & Athlete Performance System
// ============================================================================

import 'package:flutter/material.dart';
import 'models/athlete.dart';

void main() {
  runApp(const SportsCompanionApp());
}

class SportsCompanionApp extends StatefulWidget {
  const SportsCompanionApp({super.key});

  @override
  State<SportsCompanionApp> createState() => _SportsCompanionAppState();
}

class _SportsCompanionAppState extends State<SportsCompanionApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sports Companion - Practical 1',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1), // Athletic Blue
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E676), // Sport Neon Green
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF10141D),
        cardTheme: CardThemeData(
          color: const Color(0xFF1A2130),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: PracticalOneHomeScreen(
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class PracticalOneHomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const PracticalOneHomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<PracticalOneHomeScreen> createState() => _PracticalOneHomeScreenState();
}

class _PracticalOneHomeScreenState extends State<PracticalOneHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Practical 1 Sample Data (Sports Domain)
  late FootballPlayer _footballPlayer;
  late TrackAthlete _trackAthlete;

  // Interactive Live Calculation state
  double _weightInput = 70.0;
  double _heightInput = 1.75;
  int _currentHeartRate = 145;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Initializing test data for Practical 1
    _footballPlayer = FootballPlayer(
      athleteId: '24SPT001',
      name: 'Rahul Patel',
      department: 'Computer Engineering (Football Team)',
      semester: 5,
      email: 'rahul.patel@charusat.edu.in',
      contactPhone: '+91 98765 43210',
      preferredPosition: 'Attacking Midfielder',
      initialFitness: 9.4,
      initialAttendance: 92.5,
      drills: const ['Sprint Endurance', 'Ball Control', 'Agility Ladders'],
      goalsScored: 14,
      assists: 9,
    );

    _trackAthlete = TrackAthlete(
      athleteId: '24SPT002',
      name: 'Ananya Sharma',
      department: 'Information Technology (Track & Field)',
      semester: 5,
      email: 'ananya.sharma@charusat.edu.in',
      contactPhone: '+91 98765 43211',
      primaryEvent: '100m Sprint',
      initialFitness: 9.1,
      initialAttendance: 95.0,
      personalBestSeconds: 11.45,
      drills: const ['Pace Intervals', 'Block Starts', 'Plyometrics'],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _logTrainingDrill() {
    setState(() {
      // Demonstrating Dart cascade operator (..) chaining multiple calls
      _footballPlayer
        ..performTrainingSession('Agility & High-Intensity Sprint', 30)
        ..performTrainingSession('Tactical Positioning Drills', 15);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Drill logged for ${_footballPlayer.name}! New Fitness Score: ${_footballPlayer.fitnessScore.toStringAsFixed(2)}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sports Companion',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'Practical 1: Environment Setup & Project Initialization',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle Theme',
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            tooltip: 'About Practical 1',
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(icon: Icon(Icons.build_circle_outlined), text: 'Setup & Arch'),
            Tab(icon: Icon(Icons.code_rounded), text: 'Dart Fundamentals'),
            Tab(icon: Icon(Icons.sports_soccer_rounded), text: 'OOP & Athletes'),
            Tab(icon: Icon(Icons.quiz_outlined), text: 'Viva & Q/A'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSetupAndArchitectureTab(),
          _buildDartFundamentalsTab(),
          _buildOopAndAthletesTab(),
          _buildVivaQuestionsTab(),
        ],
      ),
    );
  }

  // ==========================================================================
  // TAB 1: SETUP & FLUTTER ARCHITECTURE
  // ==========================================================================
  Widget _buildSetupAndArchitectureTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Environment Status Banner
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.check_circle, color: Colors.green),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Flutter Environment Configured',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Project: sports_companion | Org: com.charusat.sports',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow('Flutter SDK', '3.44.9 (Channel Stable)'),
                _buildInfoRow('Dart SDK', '3.12.2 (x64)'),
                _buildInfoRow('Engine Architecture', 'C++ Engine (Impeller / Skia)'),
                _buildInfoRow('Target OS', 'Windows 11 / Android / Web'),
                _buildInfoRow('Course Mapping', 'CO1 - Mobile Application Foundation'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Flutter 3-Tier Architecture
        const Text(
          'Flutter Framework Architecture (3 Tiers)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildArchitectureCard(
          title: '1. Framework (Dart Level)',
          color: Colors.blueAccent,
          icon: Icons.layers_outlined,
          description:
              'High-level reactive framework written in Dart. Includes Material & Cupertino widget libraries, Rendering layer, Animation, Painting, and Gestures.',
          details: 'Widgets -> Rendering -> Painting -> Animation/Gestures',
        ),
        const SizedBox(height: 10),
        _buildArchitectureCard(
          title: '2. Engine (C/C++ Level)',
          color: Colors.teal,
          icon: Icons.memory,
          description:
              'Core execution engine written in C/C++. Handles low-level rendering via Impeller/Skia, Dart runtime VM, text layout with LibTxt/HarfBuzz, and system events.',
          details: 'Impeller/Skia 2D Graphics • Dart VM • Platform Channels',
        ),
        const SizedBox(height: 10),
        _buildArchitectureCard(
          title: '3. Embedder (Platform Specific)',
          color: Colors.amber.shade800,
          icon: Icons.devices,
          description:
              'Platform-specific host (Android Java/Kotlin, iOS Obj-C/Swift, Windows C++). Initializes the surface, manages window shell, threads, and native plugins.',
          details: 'Android Surface • Native Activity • Hardware Acceleration',
        ),
        const SizedBox(height: 20),

        // Flutter Project Folder Structure Explanation
        const Text(
          'Project Folder Structure (Sports Companion)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildFolderItem('lib/', 'Main Dart source code (screens, models, widgets, business logic)'),
        _buildFolderItem('assets/', 'Static assets (data/athlete_data.json, images, custom icons)'),
        _buildFolderItem('android/', 'Native Android project, Gradle build scripts, AndroidManifest.xml'),
        _buildFolderItem('ios/', 'Native iOS Xcode project configuration, Runner, Info.plist'),
        _buildFolderItem('test/', 'Unit, widget, and integration tests for athletic modules'),
        _buildFolderItem('pubspec.yaml', 'Project metadata, dependencies (SDK, icons), asset declarations'),
      ],
    );
  }

  // ==========================================================================
  // TAB 2: DART PROGRAMMING FUNDAMENTALS
  // ==========================================================================
  Widget _buildDartFundamentalsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Dart Language Core Concepts',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // Concept 1: Variables vs Constants
        _buildConceptCard(
          title: 'Variables & Constants',
          icon: Icons.data_object,
          codeSnippet:
              '''// Inferred & explicit types\nvar sport = 'Football';\nint reps = 15;\ndouble stamina = 94.5;\n\n// const: compile-time immutable\nconst academyCode = 'CHARUSAT-SPT-2026';\n\n// final: runtime immutable\nfinal loginTime = DateTime.now();''',
        ),
        const SizedBox(height: 12),

        // Concept 2: Operators & Control Flow
        _buildConceptCard(
          title: 'Operators & Decision Making',
          icon: Icons.alt_route,
          codeSnippet:
              '''// Operators & Dart 3 Switch Pattern Matching\nString zone = switch (heartRate) {\n  < 100 => 'Warmup',\n  >= 100 && < 140 => 'Aerobic',\n  _ => 'Peak VO2',\n};\n\n// Null-coalescing\nString note = coachNote ?? 'Standard Drill';''',
        ),
        const SizedBox(height: 16),

        // Interactive Live Tool: Athlete BMI & Heart Rate Calculator
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calculate, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text(
                      'Live Dart Execution: Mixin & Functions',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Demonstrates higher-order function, mixin method calculateBmi(), and pattern-matching getHeartRateZone():',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Weight: ${_weightInput.toStringAsFixed(1)} kg'),
                          Slider(
                            value: _weightInput,
                            min: 40.0,
                            max: 110.0,
                            onChanged: (val) => setState(() => _weightInput = val),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Height: ${_heightInput.toStringAsFixed(2)} m'),
                          Slider(
                            value: _heightInput,
                            min: 1.40,
                            max: 2.10,
                            onChanged: (val) => setState(() => _heightInput = val),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Athlete Heart Rate: $_currentHeartRate BPM'),
                Slider(
                  value: _currentHeartRate.toDouble(),
                  min: 60,
                  max: 200,
                  divisions: 140,
                  activeColor: Colors.redAccent,
                  onChanged: (val) => setState(() => _currentHeartRate = val.toInt()),
                ),
                const Divider(),
                // Display calculated results from Mixin
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Calculated BMI', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          Text(
                            _footballPlayer
                                .calculateBmi(weightKg: _weightInput, heightM: _heightInput)
                                .toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Heart Rate Zone', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          Text(
                            _footballPlayer.getHeartRateZone(_currentHeartRate),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // TAB 3: OOP, CLASSES & ATHLETE ROSTER
  // ==========================================================================
  Widget _buildOopAndAthletesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Athlete Dataset (Practical 1)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.flash_on, size: 16),
              label: const Text('Log Drill (Cascade)'),
              onPressed: _logTrainingDrill,
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Athlete 1: Football Player (Rahul Patel)
        _buildAthleteCard(
          athlete: _footballPlayer,
          badgeColor: Colors.blueAccent,
          icon: Icons.sports_soccer,
          extraStats: 'Goals: ${_footballPlayer.goalsScored} | Assists: ${_footballPlayer.assists}',
        ),
        const SizedBox(height: 16),

        // Athlete 2: Track Athlete (Ananya Sharma)
        _buildAthleteCard(
          athlete: _trackAthlete,
          badgeColor: Colors.amber.shade700,
          icon: Icons.directions_run,
          extraStats: 'Event: ${_trackAthlete.primaryEvent} | PB: ${_trackAthlete.personalBestSeconds}s',
        ),
        const SizedBox(height: 16),

        // OOP Architecture Breakdown Box
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'OOP Concepts Implemented:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 8),
                _buildOopBullet('Encapsulation', 'Private _fitnessScore & _attendancePercentage with validation in setters.'),
                _buildOopBullet('Inheritance', 'Athlete base class extended by FootballPlayer & TrackAthlete.'),
                _buildOopBullet('Polymorphism', 'Overridden calculatePerformanceRating() with sport-specific algorithms.'),
                _buildOopBullet('Abstraction', 'Trainable interface implemented by Athlete model.'),
                _buildOopBullet('Mixins', 'PerformanceMetricsMixin for reusable BMI & heart rate formulas.'),
                _buildOopBullet('Constructors', 'Parameterized formals, Named .novice(), and Factory .fromJson().'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================================
  // TAB 4: VIVA & KEY ANALYSIS QUESTIONS
  // ==========================================================================
  Widget _buildVivaQuestionsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Practical 1: Key Questions & Viva Answers',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildVivaItem(
          '1. Features, Advantages, and Limitations of Flutter',
          '• Features: Single codebase for Android, iOS, Web, Windows; Hot Reload; Rich Material/Cupertino widgets.\n'
          '• Advantages: Fast development cycles, native ARM performance, pixel-perfect UI consistency.\n'
          '• Limitations: Initial app bundle size is larger than raw native, platform-specific APIs require platform channels.',
        ),
        _buildVivaItem(
          '2. Flutter Architecture & Rendering Engine',
          'Flutter follows a 3-tier reactive architecture:\n'
          '• Framework (Dart): UI widgets, animation, gestures, rendering trees.\n'
          '• Engine (C/C++): Impeller / Skia rendering engine, Dart VM, LibTxt.\n'
          '• Embedder: Platform-specific shell communicating via Platform Channels.',
        ),
        _buildVivaItem(
          '3. Purpose of Flutter Project Folders',
          '• lib/: Core Dart application source code.\n'
          '• assets/: Media, JSON datasets, custom fonts.\n'
          '• android/: Android native project (Gradle, Manifest, Kotlin).\n'
          '• ios/: iOS native project (Xcode workspace, Podfile, Info.plist).\n'
          '• test/: Automated unit, widget, and integration tests.\n'
          '• pubspec.yaml: Package manifest for metadata, dependencies, assets.',
        ),
        _buildVivaItem(
          '4. What is Dart & Why is it used for Flutter?',
          'Dart is an object-oriented, strongly-typed language developed by Google. It supports both:\n'
          '• JIT (Just-In-Time) compilation for rapid Hot Reload during development.\n'
          '• AOT (Ahead-Of-Time) compilation into native ARM/x64 machine code for production release builds with smooth 60/120 fps.',
        ),
        _buildVivaItem(
          '5. Variables, Constants, and Data Types in Dart',
          '• var: Type inferred at compile time.\n'
          '• final: Single-assignment variable evaluated at runtime.\n'
          '• const: Compile-time constant, deeply immutable.\n'
          '• Types: int, double, String, bool, List, Set, Map, Runes.',
        ),
        _buildVivaItem(
          '6. Decision-Making & Loops in Dart',
          '• Conditionals: if, if-else, conditional operator (? :), and modern Dart 3 switch expressions with pattern matching.\n'
          '• Loops: for, for-in, while, do-while, and higher-order .forEach().',
        ),
        _buildVivaItem(
          '7. Classes, Constructors, Inheritance, & Encapsulation',
          '• Classes & Objects: Blueprint and runtime instances.\n'
          '• Encapsulation: Prefixing with underscore (_) makes identifiers library-private, paired with getters/setters.\n'
          '• Constructors: Initializing formals (this.field), named constructors (.novice), factory constructors (.fromJson).\n'
          '• Inheritance: extends keyword, superclass constructor calling via super, polymorphic method overriding (@override).',
        ),
        _buildVivaItem(
          '8. How Flutter Apps Compile and Execute on Android',
          '• Debug mode: Dart code is run using the Dart VM with JIT compilation, allowing instant hot reload.\n'
          '• Release mode: Dart code is AOT compiled into native ARM machine code library (libapp.so). The Android embedder loads FlutterActivity/FlutterEngine and renders directly onto the SurfaceView via Impeller/Vulkan or OpenGL.',
        ),
      ],
    );
  }

  // Helper widget builders
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildArchitectureCard({
    required String title,
    required Color color,
    required IconData icon,
    required String description,
    required String details,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      details,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderItem(String folder, String purpose) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(Icons.folder_open, color: Theme.of(context).colorScheme.primary),
        title: Text(folder, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        subtitle: Text(purpose, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildConceptCard({
    required String title,
    required IconData icon,
    required String codeSnippet,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                codeSnippet,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xFF80D8FF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAthleteCard({
    required Athlete athlete,
    required Color badgeColor,
    required IconData icon,
    required String extraStats,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: badgeColor.withValues(alpha: 0.2),
                  child: Icon(icon, color: badgeColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            athlete.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: badgeColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              athlete.athleteId,
                              style: TextStyle(
                                color: badgeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${athlete.department} • Sem ${athlete.semester}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatPill('Fitness Score', '${athlete.fitnessScore.toStringAsFixed(2)}/10.0', Colors.green),
                _buildStatPill('Attendance', '${athlete.attendancePercentage.toStringAsFixed(1)}%', Colors.blue),
                _buildStatPill('Rating (Polymorphic)', '${athlete.calculatePerformanceRating().toStringAsFixed(2)}/10.0', Colors.orange),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              extraStats,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Drills: ${athlete.drills.join(", ")}',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            if (athlete.trainingLogs.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                'Recent Drill Log: ${athlete.trainingLogs.last}',
                style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatPill(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildOopBullet(String concept, String explanation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right, size: 18, color: Colors.greenAccent),
          const SizedBox(width: 4),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                children: [
                  TextSpan(
                    text: '$concept: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: explanation),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVivaItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        childrenPadding: const EdgeInsets.all(14),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(answer, style: const TextStyle(fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('CHARUSAT - FTE (MAD)'),
        content: const Text(
          'Subject: AIUE302 - Mobile Application Development\n'
          'Practical 1: Flutter Development Environment Setup and Project Initialization\n'
          'Domain: Sports Companion App\n\n'
          'Designed and implemented following all syllabus guidelines, CO1 mapping, and Dart/Flutter best practices.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
