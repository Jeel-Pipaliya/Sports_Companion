// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development
// WORK/MODULE: Responsive Main Container & Navigation Hub
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'attendance.dart';
import 'timetable.dart';
import 'assignments.dart';
import 'notifications.dart';
import 'faculty.dart';
import 'gallery.dart';

// ============================================================================
// STANDALONE DEDICATED PAGE WRAPPER (Scaffold & AppBar for Individual Work)
// ============================================================================
class StandalonePageWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onToggleTheme;

  const StandalonePageWrapper({
    super.key,
    required this.title,
    required this.child,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: child,
    );
  }
}

// ============================================================================
// RESPONSIVE MAIN CONTAINER (Shell with LayoutBuilder & NavigationBar)
// ============================================================================
class ResponsiveMainContainer extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final int initialIndex;
  final bool initialTablet;

  const ResponsiveMainContainer({
    super.key,
    required this.onToggleTheme,
    this.initialIndex = 0,
    this.initialTablet = false,
  });

  @override
  State<ResponsiveMainContainer> createState() => _ResponsiveMainContainerState();
}

class _ResponsiveMainContainerState extends State<ResponsiveMainContainer> {
  late int _currentIndex;
  late bool _isTabletPreview;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _isTabletPreview = widget.initialTablet;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isLargeScreen = _isTabletPreview || constraints.maxWidth >= 720;

        final List<Widget> pages = [
          CourseDashboardModule(onToggleTheme: widget.onToggleTheme),
          AttendanceSummaryModule(onToggleTheme: widget.onToggleTheme),
          TimetableModule(onToggleTheme: widget.onToggleTheme),
          AssignmentListModule(onToggleTheme: widget.onToggleTheme),
          NotificationsModule(onToggleTheme: widget.onToggleTheme),
          FacultyInformationModule(onToggleTheme: widget.onToggleTheme),
          EventGalleryModule(onToggleTheme: widget.onToggleTheme),
        ];

        return Scaffold(
          drawer: _buildDrawer(context),
          appBar: AppBar(
            title: Text(
              _getPageTitle(_currentIndex),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: [
              // Responsive Viewport Simulation Toggle
              ActionChip(
                avatar: Icon(
                  isLargeScreen ? Icons.tablet_mac_rounded : Icons.phone_android_rounded,
                  size: 16,
                ),
                label: Text(
                  isLargeScreen ? 'Tablet Layout (>=720px)' : 'Mobile Layout (<720px)',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  setState(() {
                    _isTabletPreview = !_isTabletPreview;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isTabletPreview
                            ? 'Switched to Tablet/Expanded Responsive Layout'
                            : 'Switched to Mobile Responsive Layout',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                tooltip: 'Practical 4: State Management Hub',
                onPressed: () => Navigator.pushNamed(context, '/practical4'),
              ),
              IconButton(
                icon: const Icon(Icons.brightness_6),
                tooltip: 'Toggle Theme',
                onPressed: widget.onToggleTheme,
              ),
            ],
          ),
          body: isLargeScreen
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _currentIndex,
                      onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
                      labelType: NavigationRailLabelType.all,
                      leading: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFF0D47A1),
                        child: Text('JP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.dashboard_outlined),
                          selectedIcon: Icon(Icons.dashboard),
                          label: Text('Dashboard'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.pie_chart_outline),
                          selectedIcon: Icon(Icons.pie_chart),
                          label: Text('Attendance'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.calendar_month_outlined),
                          selectedIcon: Icon(Icons.calendar_month),
                          label: Text('Timetable'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.assignment_outlined),
                          selectedIcon: Icon(Icons.assignment),
                          label: Text('Assignments'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.notifications_outlined),
                          selectedIcon: Icon(Icons.notifications),
                          label: Text('Alerts'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.people_alt_outlined),
                          selectedIcon: Icon(Icons.people_alt),
                          label: Text('Faculty'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.grid_view_outlined),
                          selectedIcon: Icon(Icons.grid_view),
                          label: Text('Gallery'),
                        ),
                      ],
                    ),
                    const VerticalDivider(width: 1, thickness: 1),
                    Expanded(child: pages[_currentIndex]),
                  ],
                )
              : pages[_currentIndex],
          bottomNavigationBar: isLargeScreen
              ? null
              : NavigationBar(
                  selectedIndex: _currentIndex == 6 ? 4 : (_currentIndex < 4 ? _currentIndex : 0),
                  onDestinationSelected: (idx) {
                    setState(() {
                      _currentIndex = idx == 4 ? 6 : idx;
                    });
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: 'Dashboard',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.pie_chart_outline),
                      selectedIcon: Icon(Icons.pie_chart),
                      label: 'Attendance',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.calendar_month_outlined),
                      selectedIcon: Icon(Icons.calendar_month),
                      label: 'Timetable',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.assignment_outlined),
                      selectedIcon: Icon(Icons.assignment),
                      label: 'Tasks',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.grid_view_outlined),
                      selectedIcon: Icon(Icons.grid_view),
                      label: 'Gallery',
                    ),
                  ],
                ),
        );
      },
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Course & Sports Dashboard';
      case 1:
        return 'Attendance Summary';
      case 2:
        return 'Academic & Drill Timetable';
      case 3:
        return 'Assignment & Project List';
      case 4:
        return 'Notifications & Alerts';
      case 5:
        return 'Faculty Information';
      case 6:
        return 'Event & Sports Gallery';
      default:
        return 'Smart Companion';
    }
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF1E88E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Text(
                    'JP',
                    style: TextStyle(
                      color: Color(0xFF0D47A1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Jeel Pipaliya',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '24AIML051 • Semester V (MAD Practical 3)',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          _drawerItem(0, 'Course Dashboard', Icons.dashboard),
          _drawerItem(1, 'Attendance Summary (CO2)', Icons.pie_chart),
          _drawerItem(2, 'Timetable & Schedule', Icons.calendar_month),
          _drawerItem(3, 'Assignment List', Icons.assignment),
          _drawerItem(4, 'Notifications & Alerts', Icons.notifications),
          _drawerItem(5, 'Faculty Information', Icons.people_alt),
          _drawerItem(6, 'Event Gallery (GridView)', Icons.grid_view),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'PRACTICAL 4: DYNAMIC STATE MANAGEMENT',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.tune_rounded, color: Color(0xFF0D47A1)),
            title: const Text('Practical 4 Master Hub', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Tabbed State Management System (CO2)', style: TextStyle(fontSize: 11)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/practical4');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_pin_rounded, color: Colors.blue),
            title: const Text('1. Profile & Semester (Dropdown)'),
            dense: true,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/p4/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette_rounded, color: Colors.deepPurple),
            title: const Text('2. Theme Selection (Switch & Radio)'),
            dense: true,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/p4/theme');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active_rounded, color: Colors.orange),
            title: const Text('3. Notification Channels (Checkbox)'),
            dense: true,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/p4/notifications');
            },
          ),
          ListTile(
            leading: const Icon(Icons.translate_rounded, color: Colors.teal),
            title: const Text('4. Language Selection (Radio)'),
            dense: true,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/p4/language');
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_rounded, color: Colors.indigo),
            title: const Text('5. Course Preferences (FilterChips)'),
            dense: true,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/p4/courses');
            },
          ),
          ListTile(
            leading: const Icon(Icons.tune_rounded, color: Colors.green),
            title: const Text('6. Dashboard Sliders & Goals'),
            dense: true,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/p4/customization');
            },
          ),
          ListTile(
            leading: const Icon(Icons.code_rounded, color: Colors.blueGrey),
            title: const Text('7. Ephemeral vs App State'),
            dense: true,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/p4/summary');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Sign Out', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(int index, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: _currentIndex == index ? const Color(0xFF0D47A1) : null),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: _currentIndex == index ? FontWeight.bold : FontWeight.normal,
          color: _currentIndex == index ? const Color(0xFF0D47A1) : null,
        ),
      ),
      selected: _currentIndex == index,
      onTap: () {
        setState(() => _currentIndex = index);
        Navigator.pop(context);
      },
    );
  }
}
