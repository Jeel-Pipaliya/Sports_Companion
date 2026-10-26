// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development (Semester 5)
// PRACTICAL 5: Implement Navigation, Routing, and Persistent User Preferences
// STUDENT: Jeel Pipaliya (24AIML051)
// MODULE: NavigationWidgets (Drawer & BottomNavigationBar)
// ============================================================================

import 'package:flutter/material.dart';
import 'preferences_service.dart';

/// Reusable Application Navigation Drawer demonstrating named routing,
/// route highlight indicators, student session info, and persistent logout.
class AppNavigationDrawer extends StatelessWidget {
  final String currentRoute;
  final VoidCallback? onToggleTheme;
  final ValueChanged<int>? onSelectIndex;

  const AppNavigationDrawer({
    super.key,
    required this.currentRoute,
    this.onToggleTheme,
    this.onSelectIndex,
  });

  void _navigateTo(BuildContext context, String routeName, [int? tabIndex]) {
    if (onSelectIndex != null && tabIndex != null) {
      Navigator.pop(context);
      onSelectIndex!(tabIndex);
      return;
    }
    if (currentRoute == routeName) {
      Navigator.pop(context); // already on this screen, just close drawer
      return;
    }
    Navigator.pop(context); // close drawer first
    Navigator.pushNamed(context, routeName);
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Confirm Logout'),
          ],
        ),
        content: const Text(
          'Are you sure you want to end your session? Your persistent login token will be cleared from SharedPreferences.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx); // close dialog
              // Clear persistent storage
              await PreferencesService().clearUserSession();
              // Clear route stack and navigate to Login
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prefs = PreferencesService();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Column(
        children: [
          // User Accounts Header with session data
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF131D2E), const Color(0xFF1F2C42)]
                    : [const Color(0xFF0D47A1), const Color(0xFF1976D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                prefs.userName.isNotEmpty ? prefs.userName[0] : 'R',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
            ),
            accountName: Text(
              prefs.userName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  prefs.userEmail,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
                Text(
                  '${prefs.enrollmentNo} • ${prefs.selectedSemester}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF90CAF9),
                  ),
                ),
              ],
            ),
          ),

          // Drawer Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerTile(
                  context: context,
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard,
                  title: 'Dashboard Hub',
                  route: '/dashboard',
                  tabIndex: 0,
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  title: 'Student Profile',
                  route: '/profile',
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.how_to_reg_outlined,
                  activeIcon: Icons.how_to_reg,
                  title: 'Attendance Summary',
                  route: '/attendance',
                  tabIndex: 1,
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.calendar_month_outlined,
                  activeIcon: Icons.calendar_month,
                  title: 'Academic Timetable',
                  route: '/timetable',
                  tabIndex: 2,
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.assignment_outlined,
                  activeIcon: Icons.assignment,
                  title: 'Assignments & Projects',
                  route: '/assignments',
                  tabIndex: 3,
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.notifications_outlined,
                  activeIcon: Icons.notifications,
                  title: 'Notifications & Alerts',
                  route: '/notifications',
                  tabIndex: 4,
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.badge_outlined,
                  activeIcon: Icons.badge,
                  title: 'Faculty Information',
                  route: '/faculty',
                  tabIndex: 5,
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.photo_library_outlined,
                  activeIcon: Icons.photo_library,
                  title: 'Sports & Event Gallery',
                  route: '/gallery',
                  tabIndex: 6,
                ),
                const Divider(),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.alt_route_outlined,
                  activeIcon: Icons.alt_route,
                  title: 'Practical 5 Navigation Hub',
                  subtitle: 'Navigator & Routing Demo',
                  route: '/practical5',
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.storage_outlined,
                  activeIcon: Icons.storage_rounded,
                  title: 'Practical 6 SQLite DB',
                  subtitle: 'Notes & Tasks CRUD',
                  route: '/practical6',
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  title: 'Persistent Settings',
                  subtitle: 'SharedPreferences',
                  route: '/settings',
                ),
                if (onToggleTheme != null)
                  ListTile(
                    leading: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: isDark ? Colors.amber : Colors.blueGrey,
                    ),
                    title: Text(isDark ? 'Light Mode' : 'Dark Mode'),
                    onTap: () {
                      onToggleTheme!();
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),

          // Bottom Logout Option
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'Logout Session',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              'Clear SharedPreferences',
              style: TextStyle(fontSize: 11),
            ),
            onTap: () => _showLogoutDialog(context),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDrawerTile({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String title,
    String? subtitle,
    required String route,
    int? tabIndex,
  }) {
    final isSelected = currentRoute == route;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: isSelected ? primaryColor.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          leading: Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? primaryColor : Colors.grey.shade600,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? primaryColor : null,
              fontSize: 14,
            ),
          ),
          subtitle: subtitle != null
              ? Text(subtitle, style: const TextStyle(fontSize: 11))
              : null,
          selected: isSelected,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onTap: () => _navigateTo(context, route, tabIndex),
        ),
      ),
    );
  }
}

/// Reusable Application Bottom Navigation Bar
class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      elevation: 3,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book),
          label: 'Courses',
        ),
        NavigationDestination(
          icon: Icon(Icons.how_to_reg_outlined),
          selectedIcon: Icon(Icons.how_to_reg),
          label: 'Attendance',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
