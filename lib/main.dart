// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development (Semester 5)
// PRACTICAL 3: Develop Responsive User Interface using Flutter Layout Widgets
// PRACTICAL 4: Implement State Management for Dynamic Application Features
// STUDENT: Jeel Pipaliya (24AIML051)
// DOMAIN: Smart Sports & Academic Student Companion Application
// ============================================================================

import 'package:flutter/material.dart';

// Modular Separate Work Files
import 'splash.dart';
import 'login.dart';
import 'registration.dart';
import 'responsive_container.dart';
import 'attendance.dart';
import 'timetable.dart';
import 'assignments.dart';
import 'notifications.dart';
import 'faculty.dart';
import 'gallery.dart';
import 'practical4_state_management.dart';
import 'preferences_service.dart';
import 'practical5_navigation.dart';
import 'practical6_database.dart';
import 'practical7_api.dart';

// Export all modules so that tests and external files have full access
export 'splash.dart';
export 'login.dart';
export 'registration.dart';
export 'responsive_container.dart';
export 'dashboard.dart';
export 'attendance.dart';
export 'timetable.dart';
export 'assignments.dart';
export 'notifications.dart';
export 'faculty.dart';
export 'gallery.dart';
export 'practical4_state_management.dart';
export 'preferences_service.dart';
export 'navigation_widgets.dart';
export 'practical5_navigation.dart';
export 'database_helper.dart';
export 'practical6_database.dart';
export 'api_service.dart';
export 'practical7_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService().init();
  runApp(const SportsCompanionApp());
}

// ============================================================================
// ROOT APPLICATION (StatefulWidget - Manages Theme & Routing)
// ============================================================================
class SportsCompanionApp extends StatefulWidget {
  const SportsCompanionApp({super.key});

  @override
  State<SportsCompanionApp> createState() => _SportsCompanionAppState();
}

class _SportsCompanionAppState extends State<SportsCompanionApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Student & Sports Companion',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1), // Athletic Royal Blue
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardTheme: CardThemeData(
          elevation: 1.5,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2),
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
        scaffoldBackgroundColor: const Color(0xFF0B111E),
        cardTheme: CardThemeData(
          color: const Color(0xFF131D2E),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF1F2C42)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF192438),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E3D59)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E3D59)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF00E676), width: 2),
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final name = settings.name ?? '/';
        final uri = Uri.parse(name);
        final path = uri.path;
        switch (path) {
          case '/dashboard':
            return MaterialPageRoute(
              builder: (_) => ResponsiveMainContainer(
                onToggleTheme: _toggleTheme,
                initialIndex: 0,
              ),
            );
          case '/attendance':
            return MaterialPageRoute(
              builder: (_) => StandalonePageWrapper(
                title: 'Attendance Summary',
                onToggleTheme: _toggleTheme,
                child: AttendanceSummaryModule(onToggleTheme: _toggleTheme),
              ),
            );
          case '/timetable':
            return MaterialPageRoute(
              builder: (_) => StandalonePageWrapper(
                title: 'Academic & Drill Timetable',
                onToggleTheme: _toggleTheme,
                child: TimetableModule(onToggleTheme: _toggleTheme),
              ),
            );
          case '/assignments':
            return MaterialPageRoute(
              builder: (_) => StandalonePageWrapper(
                title: 'Assignment & Project List',
                onToggleTheme: _toggleTheme,
                child: AssignmentListModule(onToggleTheme: _toggleTheme),
              ),
            );
          case '/notifications':
            return MaterialPageRoute(
              builder: (_) => StandalonePageWrapper(
                title: 'Notifications & Alerts',
                onToggleTheme: _toggleTheme,
                child: NotificationsModule(onToggleTheme: _toggleTheme),
              ),
            );
          case '/faculty':
            return MaterialPageRoute(
              builder: (_) => StandalonePageWrapper(
                title: 'Faculty Information Directory',
                onToggleTheme: _toggleTheme,
                child: FacultyInformationModule(onToggleTheme: _toggleTheme),
              ),
            );
          case '/gallery':
            return MaterialPageRoute(
              builder: (_) => StandalonePageWrapper(
                title: 'Event & Sports Gallery',
                onToggleTheme: _toggleTheme,
                child: EventGalleryModule(onToggleTheme: _toggleTheme),
              ),
            );
          case '/tablet':
            return MaterialPageRoute(
              builder: (_) => ResponsiveMainContainer(
                onToggleTheme: _toggleTheme,
                initialIndex: 0,
                initialTablet: true,
              ),
            );
          case '/practical4':
            return MaterialPageRoute(
              builder: (_) => Practical4HubScreen(onToggleTheme: _toggleTheme),
            );
          case '/p4/profile':
            return MaterialPageRoute(
              builder: (_) => StudentProfileSettingsScreen(onToggleTheme: _toggleTheme),
            );
          case '/p4/theme':
            return MaterialPageRoute(
              builder: (_) => ThemeSettingsScreen(onToggleTheme: _toggleTheme),
            );
          case '/p4/notifications':
            return MaterialPageRoute(
              builder: (_) => NotificationPreferencesScreen(onToggleTheme: _toggleTheme),
            );
          case '/p4/language':
            return MaterialPageRoute(
              builder: (_) => LanguagePreferencesScreen(onToggleTheme: _toggleTheme),
            );
          case '/p4/courses':
            return MaterialPageRoute(
              builder: (_) => CoursePreferencesScreen(onToggleTheme: _toggleTheme),
            );
          case '/p4/customization':
            return MaterialPageRoute(
              builder: (_) => DashboardCustomizationScreen(onToggleTheme: _toggleTheme),
            );
          case '/p4/summary':
            return MaterialPageRoute(
              builder: (_) => StateManagementSummaryScreen(onToggleTheme: _toggleTheme),
            );
          case '/practical5':
          case '/p5/hub':
            return MaterialPageRoute(
              builder: (_) => Practical5HubScreen(onToggleTheme: _toggleTheme),
            );
          case '/practical6':
          case '/p6/hub':
            return MaterialPageRoute(
              builder: (_) => Practical6DatabaseHubScreen(onToggleTheme: _toggleTheme),
            );
          case '/p6/notes':
            return MaterialPageRoute(
              builder: (_) => Practical6DatabaseHubScreen(
                onToggleTheme: _toggleTheme,
                initialTabIndex: 0,
              ),
            );
          case '/p6/tasks':
            return MaterialPageRoute(
              builder: (_) => Practical6DatabaseHubScreen(
                onToggleTheme: _toggleTheme,
                initialTabIndex: 1,
              ),
            );
          case '/p6/stats':
            return MaterialPageRoute(
              builder: (_) => Practical6DatabaseHubScreen(
                onToggleTheme: _toggleTheme,
                initialTabIndex: 2,
              ),
            );
          case '/practical7':
          case '/p7/hub':
            return MaterialPageRoute(
              builder: (_) => Practical7ApiHubScreen(onToggleTheme: _toggleTheme),
            );
          case '/p7/notices':
            return MaterialPageRoute(
              builder: (_) => Practical7ApiHubScreen(
                onToggleTheme: _toggleTheme,
                initialTabIndex: 0,
              ),
            );
          case '/p7/events':
            return MaterialPageRoute(
              builder: (_) => Practical7ApiHubScreen(
                onToggleTheme: _toggleTheme,
                initialTabIndex: 1,
              ),
            );
          case '/p7/post':
            return MaterialPageRoute(
              builder: (_) => Practical7ApiHubScreen(
                onToggleTheme: _toggleTheme,
                initialTabIndex: 2,
              ),
            );
          case '/p7/docs':
            return MaterialPageRoute(
              builder: (_) => Practical7ApiHubScreen(
                onToggleTheme: _toggleTheme,
                initialTabIndex: 3,
              ),
            );
          case '/settings':
          case '/p5/settings':
            return MaterialPageRoute(
              builder: (_) => PersistentSettingsScreen(onToggleTheme: _toggleTheme),
            );
          case '/profile':
          case '/p5/profile':
            return MaterialPageRoute(
              builder: (_) => StudentProfileScreen(onToggleTheme: _toggleTheme),
            );
          case '/login':
            return MaterialPageRoute(
              builder: (_) => LoginScreen(onToggleTheme: _toggleTheme),
            );
          case '/register':
            return MaterialPageRoute(
              builder: (_) => RegistrationScreen(onToggleTheme: _toggleTheme),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => SplashScreen(onToggleTheme: _toggleTheme),
            );
        }
      },
      routes: {
        '/': (context) => SplashScreen(onToggleTheme: _toggleTheme),
        '/login': (context) => LoginScreen(onToggleTheme: _toggleTheme),
        '/register': (context) => RegistrationScreen(onToggleTheme: _toggleTheme),
        '/dashboard': (context) => ResponsiveMainContainer(onToggleTheme: _toggleTheme, initialIndex: 0),
        '/attendance': (context) => StandalonePageWrapper(
              title: 'Attendance Summary',
              onToggleTheme: _toggleTheme,
              child: AttendanceSummaryModule(onToggleTheme: _toggleTheme),
            ),
        '/timetable': (context) => StandalonePageWrapper(
              title: 'Academic & Drill Timetable',
              onToggleTheme: _toggleTheme,
              child: TimetableModule(onToggleTheme: _toggleTheme),
            ),
        '/assignments': (context) => StandalonePageWrapper(
              title: 'Assignment & Project List',
              onToggleTheme: _toggleTheme,
              child: AssignmentListModule(onToggleTheme: _toggleTheme),
            ),
        '/notifications': (context) => StandalonePageWrapper(
              title: 'Notifications & Alerts',
              onToggleTheme: _toggleTheme,
              child: NotificationsModule(onToggleTheme: _toggleTheme),
            ),
        '/faculty': (context) => StandalonePageWrapper(
              title: 'Faculty Information Directory',
              onToggleTheme: _toggleTheme,
              child: FacultyInformationModule(onToggleTheme: _toggleTheme),
            ),
        '/gallery': (context) => StandalonePageWrapper(
              title: 'Event & Sports Gallery',
              onToggleTheme: _toggleTheme,
              child: EventGalleryModule(onToggleTheme: _toggleTheme),
            ),
        '/tablet': (context) => ResponsiveMainContainer(
              onToggleTheme: _toggleTheme,
              initialIndex: 0,
              initialTablet: true,
            ),
        '/profile': (context) => StudentProfileScreen(onToggleTheme: _toggleTheme),
        '/settings': (context) => PersistentSettingsScreen(onToggleTheme: _toggleTheme),
        '/practical5': (context) => Practical5HubScreen(onToggleTheme: _toggleTheme),
        '/p5/hub': (context) => Practical5HubScreen(onToggleTheme: _toggleTheme),
        '/p5/settings': (context) => PersistentSettingsScreen(onToggleTheme: _toggleTheme),
        '/p5/profile': (context) => StudentProfileScreen(onToggleTheme: _toggleTheme),
        '/practical6': (context) => Practical6DatabaseHubScreen(onToggleTheme: _toggleTheme),
        '/p6/hub': (context) => Practical6DatabaseHubScreen(onToggleTheme: _toggleTheme),
        '/p6/notes': (context) => Practical6DatabaseHubScreen(onToggleTheme: _toggleTheme, initialTabIndex: 0),
        '/p6/tasks': (context) => Practical6DatabaseHubScreen(onToggleTheme: _toggleTheme, initialTabIndex: 1),
        '/p6/stats': (context) => Practical6DatabaseHubScreen(onToggleTheme: _toggleTheme, initialTabIndex: 2),
        '/practical4': (context) => Practical4HubScreen(onToggleTheme: _toggleTheme),
        '/p4/profile': (context) => StudentProfileSettingsScreen(onToggleTheme: _toggleTheme),
        '/p4/theme': (context) => ThemeSettingsScreen(onToggleTheme: _toggleTheme),
        '/p4/notifications': (context) => NotificationPreferencesScreen(onToggleTheme: _toggleTheme),
        '/p4/language': (context) => LanguagePreferencesScreen(onToggleTheme: _toggleTheme),
        '/p4/courses': (context) => CoursePreferencesScreen(onToggleTheme: _toggleTheme),
        '/p4/customization': (context) => DashboardCustomizationScreen(onToggleTheme: _toggleTheme),
        '/p4/summary': (context) => StateManagementSummaryScreen(onToggleTheme: _toggleTheme),
      },
    );
  }
}
