// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development (Semester 5)
// PRACTICAL 5: Implement Navigation, Routing, and Persistent User Preferences
// STUDENT: Jeel Pipaliya (24AIML051)
// MODULE: Practical 5 Master Screens (Hub, Persistent Settings, Profile)
// ============================================================================

import 'package:flutter/material.dart';
import 'preferences_service.dart';
import 'navigation_widgets.dart';

// ============================================================================
// 1. PRACTICAL 5 MASTER NAVIGATION & ROUTING HUB
// ============================================================================
class Practical5HubScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;

  const Practical5HubScreen({super.key, this.onToggleTheme});

  @override
  State<Practical5HubScreen> createState() => _Practical5HubScreenState();
}

class _Practical5HubScreenState extends State<Practical5HubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PreferencesService _prefs = PreferencesService();
  String _lastNavResult = 'None (Tap a test below to pop with result)';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _prefs.addListener(_onPrefsChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _prefs.removeListener(_onPrefsChanged);
    super.dispose();
  }

  void _onPrefsChanged() {
    if (mounted) setState(() {});
  }

  // Demonstration: Navigator.push with custom Animated Page Route
  void _navigateToWithAnimation(Widget destination) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  // Demonstration: Navigator.pushNamed with arguments and awaiting return result
  Future<void> _testPushNamedWithArguments() async {
    final result = await Navigator.pushNamed(
      context,
      '/settings',
      arguments: {
        'source': 'Practical5HubScreen',
        'timestamp': DateTime.now().toIso8601String(),
        'highlightSetting': 'Language',
      },
    );
    if (mounted && result != null) {
      setState(() {
        _lastNavResult = 'Returned from /settings: $result';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Result received: $result'),
          backgroundColor: const Color(0xFF0D47A1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Practical 5: Navigation & Routing Hub',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload SharedPreferences',
            onPressed: () async {
              await _prefs.init();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('SharedPreferences Reloaded from disk!')),
                );
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF0D47A1),
          tabs: const [
            Tab(icon: Icon(Icons.alt_route), text: 'Routing Methods'),
            Tab(icon: Icon(Icons.storage), text: 'Shared Preferences'),
            Tab(icon: Icon(Icons.schema), text: 'Flow Architecture'),
          ],
        ),
      ),
      drawer: AppNavigationDrawer(
        currentRoute: '/practical5',
        onToggleTheme: widget.onToggleTheme,
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/dashboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/dashboard');
              break;
            case 2:
              Navigator.pushNamed(context, '/attendance');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
            case 4:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRoutingMethodsTab(),
          _buildSharedPreferencesTab(),
          _buildFlowArchitectureTab(),
        ],
      ),
    );
  }

  Widget _buildRoutingMethodsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Result Display Card
        Card(
          color: const Color(0xFF0D47A1).withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF0D47A1), width: 1.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF0D47A1)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Navigator Return Value Awaiter',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        _lastNavResult,
                        style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Section: Fundamental Navigator Methods
        const Text(
          '1. Core Navigator Methods Demonstrated',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        _buildMethodTile(
          method: 'Navigator.pushNamed()',
          description: 'Pushes named route onto navigation stack with arguments passing.',
          icon: Icons.arrow_forward,
          color: Colors.blue.shade700,
          onTap: () => Navigator.pushNamed(context, '/attendance'),
          buttonLabel: 'Go to Attendance (/attendance)',
        ),
        _buildMethodTile(
          method: 'Navigator.push() + PageRouteBuilder',
          description: 'Pushes a route with custom slide & fade transition animations.',
          icon: Icons.animation,
          color: Colors.indigo.shade600,
          onTap: () => _navigateToWithAnimation(
            PersistentSettingsScreen(onToggleTheme: widget.onToggleTheme),
          ),
          buttonLabel: 'Animated Slide to Settings',
        ),
        _buildMethodTile(
          method: 'Navigator.pushNamed() with Result',
          description: 'Awaits asynchronous result payload returned when popped.',
          icon: Icons.call_missed_outgoing,
          color: Colors.teal.shade700,
          onTap: _testPushNamedWithArguments,
          buttonLabel: 'Pass Args & Await Result',
        ),
        _buildMethodTile(
          method: 'Navigator.pushReplacementNamed()',
          description: 'Discards current route and mounts destination without back navigation.',
          icon: Icons.swap_horiz,
          color: Colors.orange.shade800,
          onTap: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
          buttonLabel: 'Replace with Dashboard',
        ),
        _buildMethodTile(
          method: 'Navigator.pushNamedAndRemoveUntil()',
          description: 'Clears entire historical route stack and establishes new root (Logout flow).',
          icon: Icons.delete_sweep,
          color: Colors.red.shade700,
          onTap: () async {
            await _prefs.clearUserSession();
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
            }
          },
          buttonLabel: 'Simulate Logout & Clear Stack',
        ),

        const SizedBox(height: 20),
        const Text(
          '2. Quick Navigation Grid to All Application Modules',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.1,
          children: [
            _buildNavGridItem('Splash', Icons.timer, '/'),
            _buildNavGridItem('Login', Icons.login, '/login'),
            _buildNavGridItem('Register', Icons.how_to_reg, '/register'),
            _buildNavGridItem('Dashboard', Icons.dashboard, '/dashboard'),
            _buildNavGridItem('Profile', Icons.person, '/profile'),
            _buildNavGridItem('Attendance', Icons.fact_check, '/attendance'),
            _buildNavGridItem('Timetable', Icons.calendar_today, '/timetable'),
            _buildNavGridItem('Assignments', Icons.assignment, '/assignments'),
            _buildNavGridItem('Events Gallery', Icons.photo_library, '/gallery'),
            _buildNavGridItem('Faculty', Icons.badge, '/faculty'),
            _buildNavGridItem('Settings', Icons.settings, '/settings'),
            _buildNavGridItem('Logout Flow', Icons.logout, '/login', isLogout: true),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodTile({
    required String method,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String buttonLabel,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    method,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(description, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                icon: const Icon(Icons.play_arrow, size: 16),
                label: Text(buttonLabel),
                onPressed: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavGridItem(String title, IconData icon, String route, {bool isLogout = false}) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (isLogout) {
          _prefs.clearUserSession();
          Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      child: Card(
        color: isLogout ? Colors.red.shade50 : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isLogout ? Colors.red.shade200 : Colors.grey.shade300,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isLogout ? Colors.red : const Color(0xFF0D47A1), size: 26),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isLogout ? Colors.red : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSharedPreferencesTab() {
    final stateMap = _prefs.toMap();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Status Card
        Card(
          color: _prefs.isLoggedIn ? Colors.green.shade50 : Colors.amber.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: _prefs.isLoggedIn ? Colors.green.shade400 : Colors.amber.shade600,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(
                  _prefs.isLoggedIn ? Icons.verified_user : Icons.lock_outline,
                  color: _prefs.isLoggedIn ? Colors.green.shade700 : Colors.amber.shade800,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _prefs.isLoggedIn
                            ? 'AUTHENTICATED SESSION ACTIVE'
                            : 'NO ACTIVE SESSION (Logged Out)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _prefs.isLoggedIn ? Colors.green.shade900 : Colors.amber.shade900,
                        ),
                      ),
                      Text(
                        'Stored on device storage via SharedPreferences plugin. Splash Screen automatically routes to /dashboard when flag is true.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: _prefs.isLoggedIn ? Colors.green.shade800 : Colors.amber.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          'Live SharedPreferences Key-Value Store',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        ...stateMap.entries.map((entry) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              dense: true,
              leading: const Icon(Icons.key, size: 18, color: Color(0xFF0D47A1)),
              title: Text(
                entry.key,
                style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace'),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${entry.value}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.settings),
                label: const Text('Edit Preferences'),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.restore),
                label: const Text('Reset Defaults'),
                onPressed: () async {
                  await _prefs.resetToDefaults();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preferences reset to University defaults!')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFlowArchitectureTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Navigation Flow & Session Lifecycle',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'In Practical 5, the application manages the screen stack using Flutter Navigator 2.0 primitives '
          'combined with asynchronous session checks via SharedPreferences:',
          style: TextStyle(fontSize: 12.5),
        ),
        const SizedBox(height: 16),

        _buildStepCard(
          step: '1',
          title: 'Application Cold Boot (Splash Screen)',
          route: "Route: '/' -> SplashScreen",
          desc: '1. App initializes SharedPreferences plugin.\n'
              '2. Evaluates key "sp_is_logged_in".\n'
              '3. IF true -> Navigator.pushReplacementNamed("/dashboard")\n'
              '4. IF false -> Navigator.pushReplacementNamed("/login")',
          icon: Icons.power_settings_new,
          color: Colors.blue,
        ),
        _buildStepCard(
          step: '2',
          title: 'User Authentication (Login Screen)',
          route: "Route: '/login' -> LoginScreen",
          desc: '1. Validates test credentials (rahul.patel@charusat.edu.in / student@123).\n'
              '2. Persists email, user token, and rememberMe flag.\n'
              '3. Calls Navigator.pushReplacementNamed(context, "/dashboard"). Stack replaced cleanly.',
          icon: Icons.login,
          color: Colors.green,
        ),
        _buildStepCard(
          step: '3',
          title: 'Main Dashboard & Shell Navigation',
          route: "Route: '/dashboard' -> ResponsiveMainContainer",
          desc: '1. Hosts AppNavigationDrawer with active route highlighting.\n'
              '2. Integrates AppBottomNavigationBar for instant switching between Home, Courses, Attendance, Profile, and Settings.\n'
              '3. Supports deep-linked sub-routes via named routes.',
          icon: Icons.dashboard,
          color: Colors.purple,
        ),
        _buildStepCard(
          step: '4',
          title: 'User Preferences Customization',
          route: "Route: '/settings' -> PersistentSettingsScreen",
          desc: '1. Live synchronization with SharedPreferences for Theme, Language, Semester, and Notification channels.\n'
              '2. Changes immediately reflect across entire widget tree via ChangeNotifier.\n'
              '3. Supports Navigator.pop(context, result) to return values to caller.',
          icon: Icons.settings,
          color: Colors.amber.shade900,
        ),
        _buildStepCard(
          step: '5',
          title: 'Session Termination (Logout Flow)',
          route: 'Action: AppNavigationDrawer.Logout',
          desc: '1. Triggers confirmation AlertDialog.\n'
              '2. Clears "sp_is_logged_in" and session tokens.\n'
              '3. Executes Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false).\n'
              '4. Back button cannot return to authenticated screens.',
          icon: Icons.logout,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildStepCard({
    required String step,
    required String title,
    required String route,
    required String desc,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color,
              foregroundColor: Colors.white,
              radius: 14,
              child: Text(step, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      route,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 2. PERSISTENT SETTINGS SCREEN (SharedPreferences User Preferences)
// ============================================================================
class PersistentSettingsScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;

  const PersistentSettingsScreen({super.key, this.onToggleTheme});

  @override
  State<PersistentSettingsScreen> createState() => _PersistentSettingsScreenState();
}

class _PersistentSettingsScreenState extends State<PersistentSettingsScreen> {
  final PreferencesService _prefs = PreferencesService();

  late String _selectedTheme;
  late String _selectedLanguage;
  late String _selectedSemester;
  late bool _notificationsEnabled;
  late double _attendanceThreshold;

  final List<String> _themes = ['System', 'Light', 'Dark'];
  final List<String> _languages = ['English', 'Hindi', 'Gujarati'];
  final List<String> _semesters = [
    'Semester I',
    'Semester II',
    'Semester III',
    'Semester IV',
    'Semester V',
    'Semester VI',
    'Semester VII',
    'Semester VIII',
  ];

  @override
  void initState() {
    super.initState();
    _loadStateFromService();
    _prefs.addListener(_onPrefsUpdated);
  }

  @override
  void dispose() {
    _prefs.removeListener(_onPrefsUpdated);
    super.dispose();
  }

  void _loadStateFromService() {
    _selectedTheme = _prefs.selectedTheme;
    _selectedLanguage = _prefs.selectedLanguage;
    _selectedSemester = _prefs.selectedSemester;
    _notificationsEnabled = _prefs.notificationsEnabled;
    _attendanceThreshold = _prefs.attendanceThreshold;
  }

  void _onPrefsUpdated() {
    if (mounted) {
      setState(() {
        _loadStateFromService();
      });
    }
  }

  Future<void> _saveAllPreferences() async {
    await _prefs.setTheme(_selectedTheme);
    await _prefs.setLanguage(_selectedLanguage);
    await _prefs.setSemester(_selectedSemester);
    await _prefs.setNotificationsEnabled(_notificationsEnabled);
    await _prefs.setAttendanceThreshold(_attendanceThreshold);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preferences saved successfully to SharedPreferences!'),
          backgroundColor: Color(0xFF16A34A),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _popWithResult() {
    Navigator.pop(
      context,
      'Theme: $_selectedTheme | Lang: $_selectedLanguage | Sem: $_selectedSemester',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Persistent User Preferences',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Return Result to Caller',
            onPressed: _popWithResult,
          ),
        ],
      ),
      drawer: AppNavigationDrawer(
        currentRoute: '/settings',
        onToggleTheme: widget.onToggleTheme,
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/dashboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/dashboard');
              break;
            case 2:
              Navigator.pushNamed(context, '/attendance');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
            case 4:
              // already on settings
              break;
          }
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner card
          Card(
            color: const Color(0xFF0D47A1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.storage, color: Colors.white, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Persistent Configuration Engine',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'All settings modified on this screen are persisted to disk via the Flutter SharedPreferences package. '
                    'Configurations survive application restarts and device reboots.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 1. Theme Selection
          _buildSectionHeader('1. Application Theme Mode (SharedPreferences)'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: _themes.map((theme) {
                  // ignore: deprecated_member_use
                  return RadioListTile<String>(
                    title: Text(theme, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      theme == 'System'
                          ? 'Follow device OS light/dark schedule'
                          : 'Force $theme palette across all screens',
                      style: const TextStyle(fontSize: 11),
                    ),
                    value: theme,
                    // ignore: deprecated_member_use
                    groupValue: _selectedTheme,
                    activeColor: const Color(0xFF0D47A1),
                    // ignore: deprecated_member_use
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedTheme = val);
                        _prefs.setTheme(val);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Language Selection
          _buildSectionHeader('2. Trilingual Localization (SharedPreferences)'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: _languages.map((lang) {
                  // ignore: deprecated_member_use
                  return RadioListTile<String>(
                    title: Text(lang, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      lang == 'English'
                          ? 'Standard academic interface'
                          : lang == 'Hindi'
                              ? 'Hindi regional localization (हिंदी)'
                              : 'Gujarati regional localization (ગુજરાતી)',
                      style: const TextStyle(fontSize: 11),
                    ),
                    value: lang,
                    // ignore: deprecated_member_use
                    groupValue: _selectedLanguage,
                    activeColor: const Color(0xFF0D47A1),
                    // ignore: deprecated_member_use
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedLanguage = val);
                        _prefs.setLanguage(val);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3. Academic Semester Dropdown
          _buildSectionHeader('3. Academic Enrollment Semester'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.school, color: Color(0xFF0D47A1)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Enrolled Semester:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedSemester,
                    underline: const SizedBox(),
                    items: _semesters.map((sem) {
                      return DropdownMenuItem(
                        value: sem,
                        child: Text(sem, style: const TextStyle(fontWeight: FontWeight.w600)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedSemester = val);
                        _prefs.setSemester(val);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 4. Notifications Switch
          _buildSectionHeader('4. System Notifications & Alerts'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SwitchListTile(
              title: const Text(
                'Enable Push Notifications',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
              ),
              subtitle: const Text(
                'Receive reminders for exam schedules, sports drills, and assignments',
                style: TextStyle(fontSize: 11),
              ),
              value: _notificationsEnabled,
              // ignore: deprecated_member_use
              activeColor: const Color(0xFF0D47A1),
              onChanged: (val) {
                setState(() => _notificationsEnabled = val);
                _prefs.setNotificationsEnabled(val);
              },
            ),
          ),
          const SizedBox(height: 16),

          // 5. Attendance Threshold Slider
          _buildSectionHeader(
            '5. Attendance Safe-Zone Threshold (${_attendanceThreshold.toStringAsFixed(0)}%)',
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Minimum Mandatory Attendance',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        '${_attendanceThreshold.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _attendanceThreshold,
                    min: 70.0,
                    max: 95.0,
                    divisions: 25,
                    label: '${_attendanceThreshold.toStringAsFixed(0)}%',
                    activeColor: const Color(0xFF0D47A1),
                    onChanged: (val) {
                      setState(() => _attendanceThreshold = val);
                    },
                    onChangeEnd: (val) {
                      _prefs.setAttendanceThreshold(val);
                    },
                  ),
                  const Text(
                    'University threshold: Minimum 75% required to be eligible for end-semester examinations.',
                    style: TextStyle(fontSize: 11, color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text('Save to Storage'),
                  onPressed: _saveAllPreferences,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Return Result'),
                  onPressed: _popWithResult,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
      ),
    );
  }
}

// ============================================================================
// 3. STUDENT PROFILE SCREEN (Persistent User Session Data)
// ============================================================================
class StudentProfileScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;

  const StudentProfileScreen({super.key, this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final prefs = PreferencesService();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Academic Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Edit Preferences',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      drawer: AppNavigationDrawer(
        currentRoute: '/profile',
        onToggleTheme: onToggleTheme,
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/dashboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/dashboard');
              break;
            case 2:
              Navigator.pushNamed(context, '/attendance');
              break;
            case 3:
              // already on profile
              break;
            case 4:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF0D47A1),
                    child: Text(
                      prefs.userName.isNotEmpty ? prefs.userName[0] : 'R',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    prefs.userName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prefs.userEmail,
                    style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D47A1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${prefs.enrollmentNo} • ${prefs.selectedSemester}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Details List
          const Text(
            'Academic & Session Details (SharedPreferences)',
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          _buildInfoTile('Student Name', prefs.userName, Icons.person),
          _buildInfoTile('Enrollment Number', prefs.enrollmentNo, Icons.badge),
          _buildInfoTile('Institutional Email', prefs.userEmail, Icons.email),
          _buildInfoTile('Department', prefs.department, Icons.account_balance),
          _buildInfoTile('Academic Term', prefs.selectedSemester, Icons.calendar_month),
          _buildInfoTile('Sports & Athletic Interest', prefs.sportsInterest, Icons.fitness_center),
          _buildInfoTile('Preferred Language', prefs.selectedLanguage, Icons.translate),
          _buildInfoTile('Theme Preference', prefs.selectedTheme, Icons.palette),
          _buildInfoTile(
            'Attendance Safe-Zone',
            '${prefs.attendanceThreshold.toStringAsFixed(0)}% Minimum',
            Icons.verified,
          ),
          _buildInfoTile(
            'Push Notifications',
            prefs.notificationsEnabled ? 'Active (Enabled)' : 'Disabled',
            Icons.notifications_active,
          ),

          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D47A1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.settings),
            label: const Text('Update Preferences in Settings'),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: const Color(0xFF0D47A1), size: 20),
        title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
