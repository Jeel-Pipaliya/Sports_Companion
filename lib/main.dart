import 'package:flutter/material.dart';

void main() {
  runApp(const SportsCompanionApp());
}

class SportsCompanionApp extends StatefulWidget {
  const SportsCompanionApp({super.key});

  @override
  State<SportsCompanionApp> createState() => _SportsCompanionAppState();
}

class _SportsCompanionAppState extends State<SportsCompanionApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sports Companion',
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
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E676), // Sport Neon Green
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F141C),
        cardTheme: CardThemeData(
          color: const Color(0xFF19202E),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: SportsDashboardScreen(
        onToggleTheme: _toggleTheme,
        isDark: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class SportsDashboardScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const SportsDashboardScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<SportsDashboardScreen> createState() => _SportsDashboardScreenState();
}

class _SportsDashboardScreenState extends State<SportsDashboardScreen> {
  // Practical 1: Athlete Test Dataset & State
  final String _athleteName = 'Jeel Pipaliya';
  final String _athleteId = '24AIML051';
  final String _discipline = 'Handball & Table Tennis';
  final int _semester = 5;
  final String _department =
      'Artificial Intelligence and Machine Learning (CHARUSAT)';

  double _attendance = 92.5; // Training attendance %
  double _fitnessScore = 9.4; // 0.0 to 10.0 scale
  int _completedDrills = 8;

  // Recent training activity log
  final List<String> _recentActivities = [
    'Sprint Intervals (45 mins) - Completed',
    'Ball Control & Dribbling (30 mins) - Completed',
    'Core Strength & Conditioning (25 mins) - Completed',
  ];

  void _logNewDrill(String drillName, int duration) {
    setState(() {
      _completedDrills++;
      if (_fitnessScore < 9.9) {
        _fitnessScore = (_fitnessScore + 0.05).clamp(0.0, 10.0);
      }
      _attendance = (_attendance + 0.2).clamp(0.0, 100.0);
      _recentActivities.insert(0, '$drillName ($duration mins) - Just now');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        content: Text('Logged "$drillName"! Drills: $_completedDrills'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDrillSelectorDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Training Drill to Log',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.speed, color: Colors.blue),
                title: const Text('Speed & Agility Ladders'),
                subtitle: const Text('30 mins • High Intensity'),
                trailing: const Icon(Icons.add_circle_outline),
                onTap: () {
                  Navigator.pop(ctx);
                  _logNewDrill('Agility Ladders', 30);
                },
              ),
              ListTile(
                leading: const Icon(Icons.sports_soccer, color: Colors.green),
                title: const Text('Target Passing & Finishing'),
                subtitle: const Text('40 mins • Technical Skill'),
                trailing: const Icon(Icons.add_circle_outline),
                onTap: () {
                  Navigator.pop(ctx);
                  _logNewDrill('Target Passing', 40);
                },
              ),
              ListTile(
                leading: const Icon(Icons.fitness_center, color: Colors.orange),
                title: const Text('Weightroom & Power Drills'),
                subtitle: const Text('45 mins • Strength Base'),
                trailing: const Icon(Icons.add_circle_outline),
                onTap: () {
                  Navigator.pop(ctx);
                  _logNewDrill('Power Drills', 45);
                },
              ),
            ],
          ),
        );
      },
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
              'Practical 1 • Project Foundation',
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
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            tooltip: 'Student/Athlete Info',
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => _showAthleteInfoDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Athlete Hero Card
          _buildAthleteHeroCard(),

          const SizedBox(height: 16),

          // 2. Metrics Overview Grid
          const Text(
            'Performance Metrics (Practical 1 State)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildMetricsGrid(),

          const SizedBox(height: 20),

          // 3. Upcoming Practical Modules (Future Roadmap)
          const Text(
            'Sports Modules (Application Roadmap)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildModulesList(),

          const SizedBox(height: 20),

          // 4. Recent Activity Log
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Training Drills',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Log Drill'),
                onPressed: _showDrillSelectorDialog,
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildActivityLog(),

          const SizedBox(height: 20),

          // 5. Practical 1 Lab Environment Card
          _buildEnvironmentCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showDrillSelectorDialog,
        icon: const Icon(Icons.fitness_center),
        label: const Text('Log Drill'),
      ),
    );
  }

  // --- Sub-Widgets ---

  Widget _buildAthleteHeroCard() {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.7),
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(
                Icons.sports_soccer,
                size: 36,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _athleteName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _athleteId,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_discipline • Sem $_semester',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _department,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Drills Done',
            value: '$_completedDrills',
            icon: Icons.checklist_rounded,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricCard(
            title: 'Attendance',
            value: '${_attendance.toStringAsFixed(1)}%',
            icon: Icons.calendar_today,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetricCard(
            title: 'Fitness Index',
            value: '${_fitnessScore.toStringAsFixed(1)}/10',
            icon: Icons.speed_rounded,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModulesList() {
    final modules = [
      {
        'title': 'Training Attendance & Timetable',
        'subtitle': 'Practical 2-3 • Layouts & Forms',
        'icon': Icons.event_note,
        'tag': 'Next Practical',
      },
      {
        'title': 'Tactical Notes & Drill SQLite CRUD',
        'subtitle': 'Practical 6 • Local Database',
        'icon': Icons.storage,
        'tag': 'Upcoming',
      },
      {
        'title': 'Live Match API & Tournament Scores',
        'subtitle': 'Practical 7 • RESTful Services',
        'icon': Icons.cloud_sync,
        'tag': 'Upcoming',
      },
      {
        'title': 'AI Coach & Performance Assistant',
        'subtitle': 'Practical 8 • Google AI Edge & Gemini',
        'icon': Icons.smart_toy_outlined,
        'tag': 'Upcoming',
      },
    ];

    return Column(
      children: modules.map((mod) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                mod['icon'] as IconData,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(
              mod['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Text(
              mod['subtitle'] as String,
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                mod['tag'] as String,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActivityLog() {
    return Column(
      children: _recentActivities.map((activity) {
        return Card(
          margin: const EdgeInsets.only(bottom: 6),
          child: ListTile(
            dense: true,
            leading: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 20,
            ),
            title: Text(activity, style: const TextStyle(fontSize: 13)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEnvironmentCard() {
    return Card(
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: const Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified, color: Colors.blue, size: 18),
                SizedBox(width: 8),
                Text(
                  'Practical 1 Environment Status (CO1)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              '• Flutter SDK: 3.44.9 (Stable) • Dart SDK: 3.12.2\n'
              '• Architecture: Framework (Dart) -> Engine (Impeller/Skia) -> Embedder\n'
              '• Project initialized for iterative development across all 10 Practicals.',
              style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  void _showAthleteInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Athlete & Student Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogRow('Student / Athlete', _athleteName),
            _buildDialogRow('Enrollment / ID', _athleteId),
            _buildDialogRow('Discipline', _discipline),
            _buildDialogRow('Semester', 'Semester $_semester'),
            _buildDialogRow('University', 'CHARUSAT - FTE'),
            _buildDialogRow('Course Code', 'AIUE302 (MAD)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
