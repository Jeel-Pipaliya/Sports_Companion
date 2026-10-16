// ignore_for_file: deprecated_member_use
// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development (Semester 5)
// PRACTICAL 4: Implement State Management for Dynamic Application Features
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';

// ============================================================================
// SHARED APPLICATION STATE MODEL (Application-Level State)
// ============================================================================
class StudentPreferencesModel {
  String studentName;
  String enrollmentId;
  String department;
  String semester;
  bool isDarkMode;
  String selectedThemeMode; // 'System', 'Light', 'Dark'
  String language; // 'English', 'Hindi', 'Gujarati'

  // Notification Preferences (Checkboxes)
  bool notifyAssignments;
  bool notifyExams;
  bool notifyPlacement;
  bool notifyEvents;

  // Course Preferences (FilterChips / Checkboxes)
  Set<String> selectedCourses;

  // Dashboard Customization (Sliders & Switches)
  double dailyStudyGoal; // 1.0 to 12.0 hours
  double attendanceAlertThreshold; // 70.0% to 98.0%
  bool showKpiMetrics;
  bool showQuickShortcuts;
  bool enableHapticFeedback;

  StudentPreferencesModel({
    this.studentName = 'Jeel Pipaliya',
    this.enrollmentId = '24AIML051',
    this.department = 'Artificial Intelligence & Machine Learning',
    this.semester = 'Semester V',
    this.isDarkMode = false,
    this.selectedThemeMode = 'System',
    this.language = 'English',
    this.notifyAssignments = true,
    this.notifyExams = true,
    this.notifyPlacement = true,
    this.notifyEvents = false,
    Set<String>? courses,
    this.dailyStudyGoal = 4.5,
    this.attendanceAlertThreshold = 85.0,
    this.showKpiMetrics = true,
    this.showQuickShortcuts = true,
    this.enableHapticFeedback = true,
  }) : selectedCourses = courses ?? {
          'Mobile Application Development (MAD)',
          'Artificial Intelligence (AI)',
          'Database Management Systems (DBMS)',
          'Computer Networks (CN)',
        };
}

// Global shared state container for the session
class PreferencesManager {
  static final PreferencesManager _instance = PreferencesManager._internal();
  factory PreferencesManager() => _instance;
  PreferencesManager._internal();

  StudentPreferencesModel state = StudentPreferencesModel();
  final List<VoidCallback> _listeners = [];

  void addListener(VoidCallback listener) => _listeners.add(listener);
  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  void notify() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void resetDefaults() {
    state = StudentPreferencesModel();
    notify();
  }
}

// ============================================================================
// 1. PRACTICAL 4 MASTER HUB SCREEN (Interactive TabBar & Direct Page Links)
// ============================================================================
class Practical4HubScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final int initialTabIndex;

  const Practical4HubScreen({
    super.key,
    required this.onToggleTheme,
    this.initialTabIndex = 0,
  });

  @override
  State<Practical4HubScreen> createState() => _Practical4HubScreenState();
}

class _Practical4HubScreenState extends State<Practical4HubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PreferencesManager _mgr = PreferencesManager();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 7, vsync: this, initialIndex: widget.initialTabIndex);
    _mgr.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _mgr.removeListener(_onStateChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Practical 4: State Management Hub',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'Dynamic Features via setState() • CHARUSAT CO2',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset State Defaults',
            onPressed: () {
              _mgr.resetDefaults();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Preferences reset to default values using setState()'),
                  duration: Duration(seconds: 1),
                  backgroundColor: Color(0xFF0D47A1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme Mode',
            onPressed: widget.onToggleTheme,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: const Color(0xFF0D47A1),
          labelColor: const Color(0xFF0D47A1),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          tabs: const [
            Tab(icon: Icon(Icons.person_pin_rounded, size: 20), text: '1. Profile'),
            Tab(icon: Icon(Icons.dark_mode_rounded, size: 20), text: '2. Theme'),
            Tab(icon: Icon(Icons.notifications_active_rounded, size: 20), text: '3. Alerts'),
            Tab(icon: Icon(Icons.translate_rounded, size: 20), text: '4. Language'),
            Tab(icon: Icon(Icons.menu_book_rounded, size: 20), text: '5. Courses'),
            Tab(icon: Icon(Icons.tune_rounded, size: 20), text: '6. Sliders & Customization'),
            Tab(icon: Icon(Icons.assessment_rounded, size: 20), text: '7. State Inspector'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StudentProfileSettingsScreen(embedded: true, onToggleTheme: widget.onToggleTheme),
          ThemeSettingsScreen(embedded: true, onToggleTheme: widget.onToggleTheme),
          NotificationPreferencesScreen(embedded: true, onToggleTheme: widget.onToggleTheme),
          LanguagePreferencesScreen(embedded: true, onToggleTheme: widget.onToggleTheme),
          CoursePreferencesScreen(embedded: true, onToggleTheme: widget.onToggleTheme),
          DashboardCustomizationScreen(embedded: true, onToggleTheme: widget.onToggleTheme),
          StateManagementSummaryScreen(embedded: true, onToggleTheme: widget.onToggleTheme),
        ],
      ),
    );
  }
}

// ============================================================================
// 2. PAGE 1: STUDENT PROFILE & SEMESTER SETTINGS (DropdownButton & Text)
// ============================================================================
class StudentProfileSettingsScreen extends StatefulWidget {
  final bool embedded;
  final VoidCallback onToggleTheme;

  const StudentProfileSettingsScreen({
    super.key,
    this.embedded = false,
    required this.onToggleTheme,
  });

  @override
  State<StudentProfileSettingsScreen> createState() =>
      _StudentProfileSettingsScreenState();
}

class _StudentProfileSettingsScreenState
    extends State<StudentProfileSettingsScreen> {
  final PreferencesManager _mgr = PreferencesManager();
  late TextEditingController _nameController;
  late TextEditingController _idController;

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

  final List<String> _departments = [
    'Artificial Intelligence & Machine Learning',
    'Computer Engineering',
    'Information Technology',
    'Electronics & Communication',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _mgr.state.studentName);
    _idController = TextEditingController(text: _mgr.state.enrollmentId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    setState(() {
      _mgr.state.studentName = _nameController.text.trim();
      _mgr.state.enrollmentId = _idController.text.trim();
      _mgr.notify();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Profile updated dynamically via setState(): ${_mgr.state.studentName} (${_mgr.state.semester})'),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Informational State Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0D47A1).withValues(alpha: 0.12),
                  const Color(0xFF1E88E5).withValues(alpha: 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: const Color(0xFF0D47A1).withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFF0D47A1),
                  child: Icon(Icons.person_pin_rounded,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Module 1: Student Profile & Semester Selection',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Uses DropdownButton & TextEditingController with dynamic setState() rebuilds.',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Live Student Identity Card (Reflects State Instantly)
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xFF0D47A1),
                        child: Text(
                          _nameController.text.isNotEmpty
                              ? _nameController.text[0].toUpperCase()
                              : 'S',
                          style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nameController.text.isEmpty
                                  ? 'Student Name'
                                  : _nameController.text,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_idController.text} • ${_mgr.state.semester}',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF0D47A1),
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _mgr.state.department,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade400),
                        ),
                        child: const Text('Live State',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Form Controls
          const Text('Profile Details & Academic State',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),

          // Full Name Input
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Student Full Name',
              prefixIcon: const Icon(Icons.person_outline),
              suffixIcon: IconButton(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: _saveProfile,
              ),
            ),
            onChanged: (val) {
              setState(() {
                _mgr.state.studentName = val;
                _mgr.notify();
              });
            },
          ),
          const SizedBox(height: 16),

          // Enrollment ID Input
          TextField(
            controller: _idController,
            decoration: InputDecoration(
              labelText: 'Enrollment / Student ID',
              prefixIcon: const Icon(Icons.badge_outlined),
              suffixIcon: IconButton(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: _saveProfile,
              ),
            ),
            onChanged: (val) {
              setState(() {
                _mgr.state.enrollmentId = val;
                _mgr.notify();
              });
            },
          ),
          const SizedBox(height: 16),

          // Semester DropdownButton
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Select Academic Semester (DropdownButton)',
              prefixIcon: Icon(Icons.school_outlined),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _mgr.state.semester,
                isDense: true,
                isExpanded: true,
                items: _semesters.map((sem) {
                  return DropdownMenuItem<String>(
                    value: sem,
                    child: Text(sem,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                  );
                }).toList(),
                onChanged: (String? newSem) {
                  if (newSem != null) {
                    setState(() {
                      _mgr.state.semester = newSem;
                      _mgr.notify();
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Department DropdownButton
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Select Department / Program',
              prefixIcon: Icon(Icons.account_balance_outlined),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _mgr.state.department,
                isDense: true,
                isExpanded: true,
                items: _departments.map((dept) {
                  return DropdownMenuItem<String>(
                    value: dept,
                    child: Text(dept,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13)),
                  );
                }).toList(),
                onChanged: (String? newDept) {
                  if (newDept != null) {
                    setState(() {
                      _mgr.state.department = newDept;
                      _mgr.notify();
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D47A1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.save_rounded),
            label: const Text('Save Profile State',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            onPressed: _saveProfile,
          ),
        ],
      ),
    );

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: body,
    );
  }
}

// ============================================================================
// 3. PAGE 2: THEME SELECTION & DISPLAY PREFERENCES (Switch & Radio)
// ============================================================================
class ThemeSettingsScreen extends StatefulWidget {
  final bool embedded;
  final VoidCallback onToggleTheme;

  const ThemeSettingsScreen({
    super.key,
    this.embedded = false,
    required this.onToggleTheme,
  });

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  final PreferencesManager _mgr = PreferencesManager();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final body = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withValues(alpha: 0.12),
                  Colors.deepPurple.withValues(alpha: 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.palette_rounded,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Module 2: Theme Selection & Display Controls',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Uses SwitchListTile & RadioListTile for live application-wide theme updates.',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Theme Preview Card
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    size: 38,
                    color: isDark
                        ? const Color(0xFF00E676)
                        : const Color(0xFF0D47A1),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDark ? 'Dark Theme Active' : 'Light Theme Active',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          isDark
                              ? 'High-contrast athletic dark palette (0xFF0B111E)'
                              : 'Clean athletic royal blue palette (0xFFF8FAFC)',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isDark,
                    activeThumbColor: const Color(0xFF00E676),
                    onChanged: (bool val) {
                      widget.onToggleTheme();
                      setState(() {
                        _mgr.state.isDarkMode = val;
                        _mgr.state.selectedThemeMode = val ? 'Dark' : 'Light';
                        _mgr.notify();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text('Theme Mode (Radio Selection)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),

          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('System Default Theme'),
                  subtitle: const Text(
                      'Follows operating system dark/light configuration'),
                  secondary: const Icon(Icons.settings_suggest_rounded),
                  value: 'System',
                  groupValue: _mgr.state.selectedThemeMode,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _mgr.state.selectedThemeMode = val;
                        _mgr.notify();
                      });
                    }
                  },
                ),
                const Divider(height: 1),
                RadioListTile<String>(
                  title: const Text('Light Mode (Athletic Royal)'),
                  subtitle: const Text(
                      'Bright surface with royal blue primary accents'),
                  secondary: const Icon(Icons.light_mode_outlined),
                  value: 'Light',
                  groupValue: _mgr.state.selectedThemeMode,
                  onChanged: (val) {
                    if (val != null) {
                      if (isDark) widget.onToggleTheme();
                      setState(() {
                        _mgr.state.selectedThemeMode = val;
                        _mgr.state.isDarkMode = false;
                        _mgr.notify();
                      });
                    }
                  },
                ),
                const Divider(height: 1),
                RadioListTile<String>(
                  title: const Text('Dark Mode (Athletic Neon)'),
                  subtitle:
                      const Text('Deep navy background with neon green accents'),
                  secondary: const Icon(Icons.dark_mode_outlined),
                  value: 'Dark',
                  groupValue: _mgr.state.selectedThemeMode,
                  onChanged: (val) {
                    if (val != null) {
                      if (!isDark) widget.onToggleTheme();
                      setState(() {
                        _mgr.state.selectedThemeMode = val;
                        _mgr.state.isDarkMode = true;
                        _mgr.notify();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Additional Display Switches
          const Text('Accessibility & Feedback (Switches)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),

          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.vibration_rounded),
                  title: const Text('Haptic Vibration Feedback'),
                  subtitle: const Text(
                      'Tactile response on button taps and card swipes'),
                  value: _mgr.state.enableHapticFeedback,
                  onChanged: (bool val) {
                    setState(() {
                      _mgr.state.enableHapticFeedback = val;
                      _mgr.notify();
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.speed_rounded),
                  title: const Text('High-Performance Animation Mode'),
                  subtitle: const Text(
                      'Enables 60fps card transitions & circular gauges'),
                  value: _mgr.state.showKpiMetrics,
                  onChanged: (bool val) {
                    setState(() {
                      _mgr.state.showKpiMetrics = val;
                      _mgr.notify();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme & Display Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: body,
    );
  }
}

// ============================================================================
// 4. PAGE 3: NOTIFICATION PREFERENCES (Checkbox & CheckboxListTile)
// ============================================================================
class NotificationPreferencesScreen extends StatefulWidget {
  final bool embedded;
  final VoidCallback onToggleTheme;

  const NotificationPreferencesScreen({
    super.key,
    this.embedded = false,
    required this.onToggleTheme,
  });

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  final PreferencesManager _mgr = PreferencesManager();

  bool get _allSelected =>
      _mgr.state.notifyAssignments &&
      _mgr.state.notifyExams &&
      _mgr.state.notifyPlacement &&
      _mgr.state.notifyEvents;

  void _toggleAll(bool? value) {
    setState(() {
      final v = value ?? false;
      _mgr.state.notifyAssignments = v;
      _mgr.state.notifyExams = v;
      _mgr.state.notifyPlacement = v;
      _mgr.state.notifyEvents = v;
      _mgr.notify();
    });
  }

  @override
  Widget build(BuildContext context) {
    final int activeCount = [
      _mgr.state.notifyAssignments,
      _mgr.state.notifyExams,
      _mgr.state.notifyPlacement,
      _mgr.state.notifyEvents,
    ].where((e) => e).length;

    final body = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.withValues(alpha: 0.12),
                  Colors.orange.withValues(alpha: 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.notifications_active_rounded,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Module 3: Notification Preferences (Checkboxes)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Features CheckboxListTile for multi-selection university alert channels.',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Active Channels Status Badge
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D47A1).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.campaign_rounded,
                        color: Color(0xFF0D47A1), size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$activeCount of 4 Alert Categories Active',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          activeCount == 4
                              ? 'Receiving all university announcements'
                              : 'Custom filtered notifications enabled',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Master Checkbox: Select / Deselect All
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: CheckboxListTile(
              secondary: const Icon(Icons.select_all_rounded,
                  color: Color(0xFF0D47A1)),
              title: const Text('Select All Notification Categories',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle:
                  const Text('Toggle all academic and sports alerts at once'),
              value: _allSelected,
              tristate: activeCount > 0 && activeCount < 4,
              activeColor: const Color(0xFF0D47A1),
              onChanged: _toggleAll,
            ),
          ),
          const SizedBox(height: 16),

          // Individual Checkbox List
          const Text('Syllabus Notification Channels',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),

          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                CheckboxListTile(
                  secondary: const Icon(Icons.assignment_turned_in_rounded,
                      color: Colors.blue),
                  title: const Text('Assignment Alerts'),
                  subtitle: const Text(
                      'Submission deadlines, evaluation scores, rubric uploads'),
                  value: _mgr.state.notifyAssignments,
                  activeColor: const Color(0xFF0D47A1),
                  onChanged: (bool? val) {
                    setState(() {
                      _mgr.state.notifyAssignments = val ?? false;
                      _mgr.notify();
                    });
                  },
                ),
                const Divider(height: 1),
                CheckboxListTile(
                  secondary: const Icon(Icons.event_note_rounded,
                      color: Colors.redAccent),
                  title: const Text('Examination Notifications'),
                  subtitle: const Text(
                      'Internal tests, practical exams, university timetable releases'),
                  value: _mgr.state.notifyExams,
                  activeColor: const Color(0xFF0D47A1),
                  onChanged: (bool? val) {
                    setState(() {
                      _mgr.state.notifyExams = val ?? false;
                      _mgr.notify();
                    });
                  },
                ),
                const Divider(height: 1),
                CheckboxListTile(
                  secondary: const Icon(Icons.work_outline_rounded,
                      color: Colors.teal),
                  title: const Text('Placement & Internship Updates'),
                  subtitle: const Text(
                      'Campus recruitment drives, training workshops, interview schedules'),
                  value: _mgr.state.notifyPlacement,
                  activeColor: const Color(0xFF0D47A1),
                  onChanged: (bool? val) {
                    setState(() {
                      _mgr.state.notifyPlacement = val ?? false;
                      _mgr.notify();
                    });
                  },
                ),
                const Divider(height: 1),
                CheckboxListTile(
                  secondary: const Icon(Icons.sports_soccer_rounded,
                      color: Colors.deepOrange),
                  title: const Text('Event & Sports Announcements'),
                  subtitle: const Text(
                      'CHARUSAT Spoural 2026, varsity athletic trials, hackathons'),
                  value: _mgr.state.notifyEvents,
                  activeColor: const Color(0xFF0D47A1),
                  onChanged: (bool? val) {
                    setState(() {
                      _mgr.state.notifyEvents = val ?? false;
                      _mgr.notify();
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Simulation Button
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.send_rounded),
            label: const Text('Test Notification Delivery (Trigger Toast)'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Test dispatch to $activeCount active channels: State verified!'),
                  backgroundColor: const Color(0xFF0D47A1),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: body,
    );
  }
}

// ============================================================================
// 5. PAGE 4: LANGUAGE & REGIONAL PREFERENCES (Radio & RadioListTile)
// ============================================================================
class LanguagePreferencesScreen extends StatefulWidget {
  final bool embedded;
  final VoidCallback onToggleTheme;

  const LanguagePreferencesScreen({
    super.key,
    this.embedded = false,
    required this.onToggleTheme,
  });

  @override
  State<LanguagePreferencesScreen> createState() =>
      _LanguagePreferencesScreenState();
}

class _LanguagePreferencesScreenState extends State<LanguagePreferencesScreen> {
  final PreferencesManager _mgr = PreferencesManager();

  String _getGreeting(String lang) {
    switch (lang) {
      case 'Hindi':
        return 'नमस्ते, जीत और अध्ययन की शुभकामनाएँ!';
      case 'Gujarati':
        return 'નમસ્તે, ચારુસેટ સ્માર્ટ સ્ટુડન્ટ પોર્ટલમાં સ્વાગત છે!';
      default:
        return 'Welcome to Smart Student & Sports Companion!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal.withValues(alpha: 0.12),
                  Colors.cyan.withValues(alpha: 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.translate_rounded,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Module 4: Language Selection (Radio Buttons)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Uses RadioListTile for mutual exclusion language switching with live preview.',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Live Greeting Banner
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: const Color(0xFF0D47A1),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Localized Interface Banner',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      Chip(
                        label: Text(_mgr.state.language,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11)),
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _getGreeting(_mgr.state.language),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text('Select Application Language',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),

          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('English (Default)'),
                  subtitle: const Text(
                      'Primary university academic and technical language'),
                  secondary: const CircleAvatar(
                      radius: 14,
                      child: Text('EN',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold))),
                  value: 'English',
                  groupValue: _mgr.state.language,
                  activeColor: const Color(0xFF0D47A1),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _mgr.state.language = val;
                        _mgr.notify();
                      });
                    }
                  },
                ),
                const Divider(height: 1),
                RadioListTile<String>(
                  title: const Text('Hindi (हिन्दी)'),
                  subtitle:
                      const Text('राष्ट्रीय भाषा - शैक्षणिक सूचनाएँ और अलर्ट'),
                  secondary: const CircleAvatar(
                      radius: 14,
                      child: Text('HI',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold))),
                  value: 'Hindi',
                  groupValue: _mgr.state.language,
                  activeColor: const Color(0xFF0D47A1),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _mgr.state.language = val;
                        _mgr.notify();
                      });
                    }
                  },
                ),
                const Divider(height: 1),
                RadioListTile<String>(
                  title: const Text('Gujarati (ગુજરાતી)'),
                  subtitle: const Text(
                      'પ્રાદેશિક ભાષા - ચારુસેટ કેમ્પસ પરિપત્રો અને સૂચનાઓ'),
                  secondary: const CircleAvatar(
                      radius: 14,
                      child: Text('GU',
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold))),
                  value: 'Gujarati',
                  groupValue: _mgr.state.language,
                  activeColor: const Color(0xFF0D47A1),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _mgr.state.language = val;
                        _mgr.notify();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Selection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: body,
    );
  }
}

// ============================================================================
// 6. PAGE 5: COURSE PREFERENCES & ATHLETIC FOCUS (FilterChips & Checkbox)
// ============================================================================
class CoursePreferencesScreen extends StatefulWidget {
  final bool embedded;
  final VoidCallback onToggleTheme;

  const CoursePreferencesScreen({
    super.key,
    this.embedded = false,
    required this.onToggleTheme,
  });

  @override
  State<CoursePreferencesScreen> createState() =>
      _CoursePreferencesScreenState();
}

class _CoursePreferencesScreenState extends State<CoursePreferencesScreen> {
  final PreferencesManager _mgr = PreferencesManager();

  final List<Map<String, dynamic>> _syllabusCourses = [
    {
      'code': 'MAD',
      'title': 'Mobile Application Development (MAD)',
      'faculty': 'Prof. Parth Patel',
      'credits': 4,
      'icon': Icons.phone_android_rounded,
      'color': Colors.blue,
    },
    {
      'code': 'AI',
      'title': 'Artificial Intelligence (AI)',
      'faculty': 'Dr. Sneha Sharma',
      'credits': 4,
      'icon': Icons.psychology_rounded,
      'color': Colors.teal,
    },
    {
      'code': 'DBMS',
      'title': 'Database Management Systems (DBMS)',
      'faculty': 'Prof. Amit Shah',
      'credits': 3,
      'icon': Icons.storage_rounded,
      'color': Colors.indigo,
    },
    {
      'code': 'CN',
      'title': 'Computer Networks (CN)',
      'faculty': 'Dr. Ritu Desai',
      'credits': 3,
      'icon': Icons.hub_rounded,
      'color': Colors.deepOrange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    int totalCredits = 0;
    for (final c in _syllabusCourses) {
      if (_mgr.state.selectedCourses.contains(c['title'])) {
        totalCredits += (c['credits'] as int);
      }
    }

    final body = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.indigo.withValues(alpha: 0.12),
                  Colors.blue.withValues(alpha: 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.indigo,
                  child: Icon(Icons.menu_book_rounded,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Module 5: Course Preferences (FilterChips & Checkbox)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Multi-select academic subjects with dynamic credit calculation via setState().',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Total Selected Credits Badge
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D47A1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$totalCredits',
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D47A1)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enrolled Subject Credits',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${_mgr.state.selectedCourses.length} of ${_syllabusCourses.length} core courses actively tracked',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text('Interactive Filter Chips',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _syllabusCourses.map((course) {
              final title = course['title'] as String;
              final code = course['code'] as String;
              final isSelected = _mgr.state.selectedCourses.contains(title);
              return FilterChip(
                label: Text('$code (${course['credits']} Cr)'),
                selected: isSelected,
                selectedColor: const Color(0xFF0D47A1).withValues(alpha: 0.2),
                checkmarkColor: const Color(0xFF0D47A1),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? const Color(0xFF0D47A1) : null,
                ),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      _mgr.state.selectedCourses.add(title);
                    } else {
                      _mgr.state.selectedCourses.remove(title);
                    }
                    _mgr.notify();
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          const Text('Course Tracking List (Checkboxes)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),

          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: _syllabusCourses.map((c) {
                final title = c['title'] as String;
                final isChecked = _mgr.state.selectedCourses.contains(title);
                return CheckboxListTile(
                  secondary: CircleAvatar(
                    backgroundColor:
                        (c['color'] as Color).withValues(alpha: 0.15),
                    child: Icon(c['icon'] as IconData,
                        color: c['color'] as Color, size: 20),
                  ),
                  title: Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13.5)),
                  subtitle: Text(
                      'Faculty: ${c['faculty']} • ${c['credits']} Credits'),
                  value: isChecked,
                  activeColor: const Color(0xFF0D47A1),
                  onChanged: (bool? val) {
                    setState(() {
                      if (val == true) {
                        _mgr.state.selectedCourses.add(title);
                      } else {
                        _mgr.state.selectedCourses.remove(title);
                      }
                      _mgr.notify();
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Preferences'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: body,
    );
  }
}

// ============================================================================
// 7. PAGE 6: DASHBOARD CUSTOMIZATION & SLIDERS (Slider & Switch)
// ============================================================================
class DashboardCustomizationScreen extends StatefulWidget {
  final bool embedded;
  final VoidCallback onToggleTheme;

  const DashboardCustomizationScreen({
    super.key,
    this.embedded = false,
    required this.onToggleTheme,
  });

  @override
  State<DashboardCustomizationScreen> createState() =>
      _DashboardCustomizationScreenState();
}

class _DashboardCustomizationScreenState
    extends State<DashboardCustomizationScreen> {
  final PreferencesManager _mgr = PreferencesManager();

  @override
  Widget build(BuildContext context) {
    final body = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.withValues(alpha: 0.12),
                  Colors.lightGreen.withValues(alpha: 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.tune_rounded,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Module 6: Dashboard Customization & Sliders',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Uses Slider widgets to continuously modulate academic goals and thresholds.',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Slider 1: Daily Study Goal Hours
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.timer_outlined, color: Color(0xFF0D47A1)),
                          SizedBox(width: 10),
                          Text('Daily Study Target',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D47A1).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_mgr.state.dailyStudyGoal.toStringAsFixed(1)} Hours/Day',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D47A1)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                      'Adjust planned daily revision, practical preparation, and athletic drill hours',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Slider(
                    value: _mgr.state.dailyStudyGoal,
                    min: 1.0,
                    max: 12.0,
                    divisions: 22,
                    label: '${_mgr.state.dailyStudyGoal.toStringAsFixed(1)} hrs',
                    activeColor: const Color(0xFF0D47A1),
                    onChanged: (double val) {
                      setState(() {
                        _mgr.state.dailyStudyGoal = val;
                        _mgr.notify();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1.0 hr (Light)',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade600)),
                      Text('6.0 hrs (Target)',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade600)),
                      Text('12.0 hrs (Intense)',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Slider 2: Minimum Attendance Alert Threshold
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.deepOrange),
                          SizedBox(width: 10),
                          Text('Attendance Safe-Zone Threshold',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_mgr.state.attendanceAlertThreshold.toStringAsFixed(0)}%',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                      'University regulations mandate >= 85% attendance for regular examinations',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Slider(
                    value: _mgr.state.attendanceAlertThreshold,
                    min: 70.0,
                    max: 98.0,
                    divisions: 28,
                    label:
                        '${_mgr.state.attendanceAlertThreshold.toStringAsFixed(0)}%',
                    activeColor: Colors.deepOrange,
                    onChanged: (double val) {
                      setState(() {
                        _mgr.state.attendanceAlertThreshold = val;
                        _mgr.notify();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('70% (Warning)',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade600)),
                      const Text('85% (CHARUSAT Criteria)',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold)),
                      Text('98% (Honors)',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Dashboard Visibility Switches
          const Text('Dashboard Visual Component Toggles',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),

          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dashboard_customize_outlined),
                  title: const Text('Show High-Level KPI Summary Cards'),
                  subtitle: const Text(
                      'Displays CGPA Standing, Tasks Completed, and Varsity Fitness'),
                  value: _mgr.state.showKpiMetrics,
                  onChanged: (bool val) {
                    setState(() {
                      _mgr.state.showKpiMetrics = val;
                      _mgr.notify();
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.flash_on_outlined),
                  title: const Text('Show Quick Action Shortcuts Row'),
                  subtitle: const Text(
                      'Direct launch chips for Timetable, Attendance, and Faculty Cabins'),
                  value: _mgr.state.showQuickShortcuts,
                  onChanged: (bool val) {
                    setState(() {
                      _mgr.state.showQuickShortcuts = val;
                      _mgr.notify();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Customization & Sliders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: body,
    );
  }
}

// ============================================================================
// 8. PAGE 7: STATE MANAGEMENT INSPECTOR & EPHEMERAL VS APP STATE
// ============================================================================
class StateManagementSummaryScreen extends StatefulWidget {
  final bool embedded;
  final VoidCallback onToggleTheme;

  const StateManagementSummaryScreen({
    super.key,
    this.embedded = false,
    required this.onToggleTheme,
  });

  @override
  State<StateManagementSummaryScreen> createState() =>
      _StateManagementSummaryScreenState();
}

class _StateManagementSummaryScreenState
    extends State<StateManagementSummaryScreen> {
  final PreferencesManager _mgr = PreferencesManager();
  int _ephemeralCounter = 0; // Local Ephemeral State Example

  @override
  Widget build(BuildContext context) {
    final body = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueGrey.withValues(alpha: 0.12),
                  Colors.cyan.withValues(alpha: 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueGrey.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blueGrey,
                  child:
                      Icon(Icons.code_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Module 7: Ephemeral State vs Application State',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Live side-by-side comparison illustrating how setState() controls reactive UI.',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Interactive Ephemeral State Card
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.touch_app_rounded, color: Colors.teal),
                      SizedBox(width: 8),
                      Text('1. Ephemeral State (Local to Widget Tree)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'State that a single widget holds and no other widget needs to know about. Exists only while this widget is in the tree.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Interactive Local Counter: $_ephemeralCounter',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.remove),
                        onPressed: () => setState(() => _ephemeralCounter--),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => _ephemeralCounter++),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Application State Live Dump Card
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.account_tree_rounded, color: Color(0xFF0D47A1)),
                      SizedBox(width: 8),
                      Text('2. Application State (Shared Across All Screens)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'State shared across multiple screens (profile, theme, notification channels, courses, sliders). Dynamically broadcasted via setState().',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 14),
                  _stateRow('Student Name', _mgr.state.studentName),
                  _stateRow('Enrollment ID', _mgr.state.enrollmentId),
                  _stateRow('Academic Semester', _mgr.state.semester),
                  _stateRow('Theme Selection', _mgr.state.selectedThemeMode),
                  _stateRow('Language Preference', _mgr.state.language),
                  _stateRow('Study Target Goal',
                      '${_mgr.state.dailyStudyGoal.toStringAsFixed(1)} hrs/day'),
                  _stateRow('Attendance Threshold',
                      '${_mgr.state.attendanceAlertThreshold.toStringAsFixed(0)}%'),
                  _stateRow('Active Courses',
                      '${_mgr.state.selectedCourses.length} Core Subjects'),
                  _stateRow(
                    'Notifications',
                    [
                      if (_mgr.state.notifyAssignments) 'Assignments',
                      if (_mgr.state.notifyExams) 'Exams',
                      if (_mgr.state.notifyPlacement) 'Placement',
                      if (_mgr.state.notifyEvents) 'Events'
                    ].join(', '),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Global Reset & Save Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.restart_alt_rounded),
                  label: const Text('Reset Defaults'),
                  onPressed: () {
                    setState(() {
                      _mgr.resetDefaults();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All state fields reset to defaults'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Apply All Changes'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'State persisted for active session! Screen rebuild verified.'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management Inspector'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: body,
    );
  }

  Widget _stateRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.grey)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
