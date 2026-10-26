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
import 'navigation_widgets.dart';

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
          drawer: AppNavigationDrawer(
            currentRoute: '/dashboard',
            onToggleTheme: widget.onToggleTheme,
            onSelectIndex: (idx) => setState(() => _currentIndex = idx),
          ),
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
                icon: const Icon(Icons.brightness_6),
                tooltip: 'Toggle Theme',
                onPressed: widget.onToggleTheme,
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                tooltip: 'Practical Hubs & Settings',
                onSelected: (route) => Navigator.pushNamed(context, route),
                itemBuilder: (ctx) => const [
                  PopupMenuItem(
                    value: '/practical5',
                    child: Row(
                      children: [
                        Icon(Icons.alt_route, color: Color(0xFF0D47A1), size: 18),
                        SizedBox(width: 8),
                        Text('Practical 5: Navigation Hub'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: '/settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings, color: Colors.blueGrey, size: 18),
                        SizedBox(width: 8),
                        Text('Persistent Settings'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: '/profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.teal, size: 18),
                        SizedBox(width: 8),
                        Text('Student Profile'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: '/practical4',
                    child: Row(
                      children: [
                        Icon(Icons.tune, color: Colors.indigo, size: 18),
                        SizedBox(width: 8),
                        Text('Practical 4: State Hub'),
                      ],
                    ),
                  ),
                ],
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
}
