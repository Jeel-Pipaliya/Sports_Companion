// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development (Semester 5)
// PRACTICAL 3: Develop Responsive User Interface using Flutter Layout Widgets
// STUDENT: Jeel Pipaliya (24AIML051)
// DOMAIN: Smart Sports & Academic Student Companion Application
// ============================================================================

import 'package:flutter/material.dart';

void main() {
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
      routes: {
        '/': (context) => SplashScreen(onToggleTheme: _toggleTheme),
        '/login': (context) => LoginScreen(onToggleTheme: _toggleTheme),
        '/register': (context) => RegistrationScreen(onToggleTheme: _toggleTheme),
        '/dashboard': (context) => ResponsiveMainContainer(onToggleTheme: _toggleTheme),
      },
    );
  }
}

// ============================================================================
// 1. SPLASH SCREEN (Single-Child & Multi-Child Layout Example)
// ============================================================================
class SplashScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const SplashScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).scaffoldBackgroundColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 2),
                ),
                child: const Icon(
                  Icons.sports_soccer_rounded,
                  size: 96,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Sports Companion',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'CHARUSAT Student Academic & Athletic Hub',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Text(
                  'Practical 3: Responsive Layout Widgets (CO2)',
                  style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0D47A1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get Started',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 2. LOGIN SCREEN (Form Validation & SingleChildScrollView)
// ============================================================================
class LoginScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const LoginScreen({super.key, required this.onToggleTheme});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController(text: '24AIML051');
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful! Welcome Jeel Pipaliya.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.sports_soccer_outlined,
                    size: 64,
                    color: Color(0xFF0D47A1),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Welcome to Sports Hub',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Sign in with your Student ID or Email',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'Enrollment ID / Email',
                      prefixIcon: Icon(Icons.badge_outlined),
                      hintText: 'e.g. 24AIML051',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your Enrollment ID or Email';
                      }
                      if (value.trim().length < 5) {
                        return 'ID must be at least 5 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _handleLogin,
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text('Register Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 3. REGISTRATION SCREEN (Form & Multi-field Validation)
// ============================================================================
class RegistrationScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const RegistrationScreen({super.key, required this.onToggleTheme});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Jeel Pipaliya');
  final _idController = TextEditingController(text: '24AIML051');
  final _emailController = TextEditingController(text: '24aiml051@charusat.edu.in');
  final _passwordController = TextEditingController(text: 'password123');
  final _confirmPasswordController = TextEditingController(text: 'password123');
  String _selectedSport = 'Football';
  bool _obscurePassword = true;

  final List<String> _sportsList = [
    'Football',
    'Athletics & Track',
    'Badminton',
    'Cricket',
    'Basketball',
    'Table Tennis',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Athlete profile created for ${_nameController.text}!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Athlete Registration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Join Sports Companion',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Register your student details for CHARUSAT Academic & Sports Hub',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: 'Enrollment / Student ID',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter your ID';
                    }
                    if (val.trim().length < 5) {
                      return 'ID must be at least 5 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedSport,
                  decoration: const InputDecoration(
                    labelText: 'Primary Sport Discipline',
                    prefixIcon: Icon(Icons.sports),
                  ),
                  items: _sportsList.map((sport) {
                    return DropdownMenuItem(value: sport, child: Text(sport));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedSport = val);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'University Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter your university email';
                    }
                    if (!val.contains('@') || !val.contains('.')) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Create Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please create a password';
                    }
                    if (val.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_reset),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (val != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _handleRegister,
                    child: const Text(
                      'Create Account',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 4. RESPONSIVE MAIN CONTAINER (Shell with LayoutBuilder & NavigationBar)
// ============================================================================
class ResponsiveMainContainer extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const ResponsiveMainContainer({super.key, required this.onToggleTheme});

  @override
  State<ResponsiveMainContainer> createState() => _ResponsiveMainContainerState();
}

class _ResponsiveMainContainerState extends State<ResponsiveMainContainer> {
  int _currentIndex = 0;
  bool _isTabletPreview = false; // Toggle to demonstrate responsive breakpoints

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
              const SizedBox(width: 4),
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

// ============================================================================
// MODULE 1: COURSE & SPORTS DASHBOARD (Responsive Grid & Flex Rows)
// ============================================================================
class CourseDashboardModule extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const CourseDashboardModule({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 600;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Student Profile Header Card (Single-Child Container & Multi-Child Row)
            Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.6),
                      Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Color(0xFF0D47A1),
                      child: Text(
                        'JP',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jeel Pipaliya',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '24AIML051 • Semester V',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Dept. of AI & ML • FTE CHARUSAT',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green.shade400, width: 1.5),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            '91.25%',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Overall Att.',
                            style: TextStyle(color: Colors.green, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // KPI Performance Overview Cards (Row + Expanded + Flexible)
            Row(
              children: [
                Expanded(
                  child: _kpiCard(
                    context,
                    '9.42',
                    'CGPA Standing',
                    Icons.school_rounded,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _kpiCard(
                    context,
                    '4 / 5',
                    'Tasks Completed',
                    Icons.task_alt_rounded,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _kpiCard(
                    context,
                    '94%',
                    'Varsity Fitness',
                    Icons.fitness_center_rounded,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section Header: Enrolled Academic Courses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Academic Courses (Semester V)',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '4 Active Subjects',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Responsive Grid of Course Modules (GridView.count with dynamic crossAxisCount)
            GridView.count(
              crossAxisCount: isWide ? 4 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isWide ? 1.4 : 1.25,
              children: [
                _courseCard(context, 'DBMS', 'Database Systems', '92% Att.', Colors.indigo, Icons.storage_rounded),
                _courseCard(context, 'MAD', 'Mobile App Dev', '88% Att.', Colors.blue, Icons.phone_android_rounded),
                _courseCard(context, 'AI', 'Artificial Intelligence', '95% Att.', Colors.teal, Icons.psychology_rounded),
                _courseCard(context, 'CN', 'Computer Networks', '90% Att.', Colors.deepOrange, Icons.lan_rounded),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Actions Horizontal Scroll (SingleChildScrollView with Row)
            const Text(
              'Quick Action Shortcuts',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _actionChip(context, 'View Attendance', Icons.pie_chart, Colors.green),
                  _actionChip(context, 'Class Timetable', Icons.calendar_month, Colors.blue),
                  _actionChip(context, 'Submit Assignment', Icons.cloud_upload_outlined, Colors.amber.shade800),
                  _actionChip(context, 'Event Gallery', Icons.photo_library_outlined, Colors.purple),
                  _actionChip(context, 'Faculty Cabins', Icons.meeting_room_outlined, Colors.teal),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _kpiCard(BuildContext context, String val, String title, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              val,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _courseCard(BuildContext context, String code, String name, String att, Color color, IconData icon) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Course details for $code - $name')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      att,
                      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    code,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionChip(BuildContext context, String label, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ActionChip(
        avatar: Icon(icon, color: color, size: 18),
        label: Text(label),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Triggered shortcut: $label')),
          );
        },
      ),
    );
  }
}

// ============================================================================
// MODULE 2: ATTENDANCE SUMMARY MODULE (Progress Bars & Multi-Child Stack)
// ============================================================================
class AttendanceSummaryModule extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const AttendanceSummaryModule({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> subjectAttendance = [
      {
        'code': 'DBMS',
        'title': 'Database Management Systems',
        'faculty': 'Prof. Amit Shah',
        'percentage': 92,
        'attended': 46,
        'total': 50,
        'color': Colors.indigo,
      },
      {
        'code': 'MAD',
        'title': 'Mobile Application Development',
        'faculty': 'Prof. Parth Patel',
        'percentage': 88,
        'attended': 44,
        'total': 50,
        'color': Colors.blue,
      },
      {
        'code': 'AI',
        'title': 'Artificial Intelligence',
        'faculty': 'Dr. Sneha Sharma',
        'percentage': 95,
        'attended': 47,
        'total': 50,
        'color': Colors.teal,
      },
      {
        'code': 'CN',
        'title': 'Computer Networks',
        'faculty': 'Dr. Ritu Desai',
        'percentage': 90,
        'attended': 45,
        'total': 50,
        'color': Colors.deepOrange,
      },
      {
        'code': 'ATH',
        'title': 'Athletic & Sports Training',
        'faculty': 'Coach Vikram Singh',
        'percentage': 94,
        'attended': 47,
        'total': 50,
        'color': Colors.green,
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overall Attendance Hero Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Circular Progress Indicator with Stack
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: 0.9125,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                    const Text(
                      '91.3%',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cumulative Attendance',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Total 229 / 250 Sessions Attended',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '✓ Status: Safe Zone (Req. >= 85%)',
                        style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
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
          'Subject-wise Breakdown (Syllabus CO2)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        // List of Subjects with Linear Progress Bars (ListView.builder concept)
        ...subjectAttendance.map((item) {
          final double val = (item['percentage'] as int) / 100.0;
          final Color col = item['color'] as Color;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: col.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['code'] as String,
                                style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item['title'] as String,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${item['percentage']}%',
                        style: TextStyle(
                          color: (item['percentage'] as int) >= 85 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: val,
                      minHeight: 8,
                      backgroundColor: Colors.black12,
                      valueColor: AlwaysStoppedAnimation<Color>(col),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Faculty: ${item['faculty']}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Attended: ${item['attended']} / ${item['total']}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ============================================================================
// MODULE 3: TIMETABLE MODULE (Time Slots & Multi-Child Rows)
// ============================================================================
class TimetableModule extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const TimetableModule({super.key, required this.onToggleTheme});

  @override
  State<TimetableModule> createState() => _TimetableModuleState();
}

class _TimetableModuleState extends State<TimetableModule> {
  String _selectedDay = 'Monday';

  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  final Map<String, List<Map<String, String>>> _schedules = {
    'Monday': [
      {'time': '09:00 - 10:00 AM', 'sub': 'DBMS Theory', 'room': 'Room 204 FTE', 'fac': 'Prof. Amit Shah', 'type': 'Theory'},
      {'time': '10:00 - 11:00 AM', 'sub': 'MAD Theory', 'room': 'Room 204 FTE', 'fac': 'Prof. Parth Patel', 'type': 'Theory'},
      {'time': '11:15 - 01:15 PM', 'sub': 'MAD Practical Lab (P3)', 'room': 'Lab 102 (AI Lab)', 'fac': 'Prof. Parth Patel', 'type': 'Lab'},
      {'time': '02:00 - 03:00 PM', 'sub': 'AI Theory', 'room': 'Room 204 FTE', 'fac': 'Dr. Sneha Sharma', 'type': 'Theory'},
      {'time': '04:30 - 06:00 PM', 'sub': 'Athletic Training & Drills', 'room': 'Sports Arena', 'fac': 'Coach Vikram Singh', 'type': 'Sports'},
    ],
    'Tuesday': [
      {'time': '09:00 - 11:00 AM', 'sub': 'AI Practical Lab', 'room': 'Lab 104', 'fac': 'Dr. Sneha Sharma', 'type': 'Lab'},
      {'time': '11:15 - 12:15 PM', 'sub': 'Computer Networks', 'room': 'Room 204 FTE', 'fac': 'Dr. Ritu Desai', 'type': 'Theory'},
      {'time': '01:00 - 02:00 PM', 'sub': 'DBMS Theory', 'room': 'Room 204 FTE', 'fac': 'Prof. Amit Shah', 'type': 'Theory'},
      {'time': '04:30 - 06:00 PM', 'sub': 'Football Squad Practice', 'room': 'Football Turf Ground', 'fac': 'Coach Vikram Singh', 'type': 'Sports'},
    ],
    'Wednesday': [
      {'time': '09:00 - 10:00 AM', 'sub': 'MAD Theory', 'room': 'Room 204 FTE', 'fac': 'Prof. Parth Patel', 'type': 'Theory'},
      {'time': '10:00 - 11:00 AM', 'sub': 'CN Theory', 'room': 'Room 204 FTE', 'fac': 'Dr. Ritu Desai', 'type': 'Theory'},
      {'time': '11:15 - 01:15 PM', 'sub': 'DBMS Lab Practical', 'room': 'Database Lab 201', 'fac': 'Prof. Amit Shah', 'type': 'Lab'},
      {'time': '02:00 - 03:00 PM', 'sub': 'AI Machine Learning', 'room': 'Room 204 FTE', 'fac': 'Dr. Sneha Sharma', 'type': 'Theory'},
    ],
    'Thursday': [
      {'time': '09:00 - 10:00 AM', 'sub': 'Computer Networks', 'room': 'Room 204 FTE', 'fac': 'Dr. Ritu Desai', 'type': 'Theory'},
      {'time': '10:00 - 12:00 PM', 'sub': 'CN Practical Lab', 'room': 'Networks Lab 105', 'fac': 'Dr. Ritu Desai', 'type': 'Lab'},
      {'time': '01:00 - 02:00 PM', 'sub': 'MAD Code Review', 'room': 'Room 204 FTE', 'fac': 'Prof. Parth Patel', 'type': 'Theory'},
      {'time': '04:30 - 06:00 PM', 'sub': 'Strength & Conditioning', 'room': 'University Gymnasium', 'fac': 'Coach Vikram Singh', 'type': 'Sports'},
    ],
    'Friday': [
      {'time': '09:00 - 11:00 AM', 'sub': 'Flutter Layout Workshop', 'room': 'Lab 102 (AI Lab)', 'fac': 'Prof. Parth Patel', 'type': 'Workshop'},
      {'time': '11:15 - 12:15 PM', 'sub': 'DBMS Query Optimization', 'room': 'Room 204 FTE', 'fac': 'Prof. Amit Shah', 'type': 'Theory'},
      {'time': '01:00 - 02:00 PM', 'sub': 'AI Project Mentoring', 'room': 'FTE Faculty Cabin', 'fac': 'Dr. Sneha Sharma', 'type': 'Mentoring'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final currentList = _schedules[_selectedDay] ?? [];

    return Column(
      children: [
        // Day Picker Row (SingleChildScrollView with Row)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _days.map((day) {
                final bool isSelected = _selectedDay == day;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(day),
                    onSelected: (val) {
                      setState(() => _selectedDay = day);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const Divider(height: 1),

        // Schedule ListView
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: currentList.length,
            itemBuilder: (context, idx) {
              final slot = currentList[idx];
              final isLab = slot['type'] == 'Lab' || slot['type'] == 'Workshop';
              final isSports = slot['type'] == 'Sports';

              Color badgeCol = Colors.blue;
              if (isLab) badgeCol = Colors.purple;
              if (isSports) badgeCol = Colors.green;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Time Slot Box
                      Container(
                        width: 90,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: badgeCol.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: badgeCol.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.access_time_rounded, size: 18, color: badgeCol),
                            const SizedBox(height: 4),
                            Text(
                              slot['time']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: badgeCol,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Session Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    slot['sub']!,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: badgeCol.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    slot['type']!,
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeCol),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.room_outlined, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    slot['room']!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    slot['fac']!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// MODULE 4: ASSIGNMENT LIST MODULE (Cards, Status Chips, LinearProgress)
// ============================================================================
class AssignmentListModule extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const AssignmentListModule({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    // Syllabus specified assignments
    final List<Map<String, dynamic>> assignments = [
      {
        'title': 'Flutter UI Design (Practical 2)',
        'course': 'MAD (AIUE302)',
        'due': 'Completed & Graded',
        'status': 'Submitted',
        'progress': 1.0,
        'grade': 'Grade: A+ (100%)',
        'color': Colors.green,
      },
      {
        'title': 'Database CRUD & Normalization',
        'course': 'DBMS (AIUE304)',
        'due': 'Due Tomorrow, 11:59 PM',
        'status': 'In Progress',
        'progress': 0.75,
        'grade': 'Pending Review',
        'color': Colors.orange,
      },
      {
        'title': 'REST API Integration & JSON Parsing',
        'course': 'MAD (AIUE302)',
        'due': 'Due Next Week (Oct 24, 2026)',
        'status': 'Upcoming',
        'progress': 0.25,
        'grade': 'Not Submitted',
        'color': Colors.blue,
      },
      {
        'title': 'Deep Learning Neural Network Model',
        'course': 'AI (AIUE306)',
        'due': 'Due Oct 28, 2026',
        'status': 'In Progress',
        'progress': 0.50,
        'grade': 'Drafting Code',
        'color': Colors.purple,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: assignments.length,
      itemBuilder: (context, idx) {
        final a = assignments[idx];
        final Color col = a['color'] as Color;

        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: col.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          a['course'] as String,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: col.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: col.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        a['status'] as String,
                        style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  a['title'] as String,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  a['due'] as String,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: a['progress'] as double,
                    minHeight: 6,
                    backgroundColor: Colors.black12,
                    valueColor: AlwaysStoppedAnimation<Color>(col),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      a['grade'] as String,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.file_upload_outlined, size: 16),
                      label: const Text('Action'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Submission portal opened for ${a['title']}')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// MODULE 5: NOTIFICATIONS & ALERTS (Syllabus: Exam, Deadline, Tech Events)
// ============================================================================
class NotificationsModule extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const NotificationsModule({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    // Syllabus specified notification items
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Internal Exam Schedule Announced',
        'desc': 'Mid-semester theoretical examinations for Semester V will commence from Nov 03, 2026. Review exam seating and guidelines.',
        'time': '2 hours ago',
        'category': 'Academic',
        'icon': Icons.edit_calendar_rounded,
        'color': Colors.redAccent,
        'urgent': true,
      },
      {
        'title': 'Assignment Deadline Reminder',
        'desc': 'Database CRUD & Normalization assignment portal closes tomorrow at 11:59 PM. Ensure schema scripts are attached.',
        'time': '4 hours ago',
        'category': 'Submission',
        'icon': Icons.timer_outlined,
        'color': Colors.orange,
        'urgent': true,
      },
      {
        'title': 'Technical Event Registration Open',
        'desc': 'Registrations are now active for the National Flutter App Hackathon 2026 & CHARUSAT Tech Expo.',
        'time': 'Yesterday',
        'category': 'Tech Fest',
        'icon': Icons.emoji_events_outlined,
        'color': Colors.blue,
        'urgent': false,
      },
      {
        'title': 'Inter-College Sports Trials',
        'desc': 'Selections for the University Football Team and 100m/200m Sprint qualifiers start tomorrow at 6:30 AM.',
        'time': '2 days ago',
        'category': 'Athletics',
        'icon': Icons.sports_soccer_outlined,
        'color': Colors.green,
        'urgent': false,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, idx) {
        final n = notifications[idx];
        final Color col = n['color'] as Color;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: col.withValues(alpha: 0.15),
                  child: Icon(n['icon'] as IconData, color: col, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: col.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              n['category'] as String,
                              style: TextStyle(color: col, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            n['time'] as String,
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        n['title'] as String,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        n['desc'] as String,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// MODULE 6: FACULTY INFORMATION MODULE (Cards with Row, Column, Avatar)
// ============================================================================
class FacultyInformationModule extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const FacultyInformationModule({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faculties = [
      {
        'name': 'Prof. Parth Patel',
        'designation': 'Assistant Professor',
        'dept': 'Mobile Application Development (MAD)',
        'cabin': 'Cabin 204, 2nd Floor FTE',
        'email': 'parthpatel.it@charusat.ac.in',
        'hours': '3:00 PM - 5:00 PM',
      },
      {
        'name': 'Dr. Sneha Sharma',
        'designation': 'Associate Professor & AI Lead',
        'dept': 'Artificial Intelligence & Machine Learning',
        'cabin': 'Cabin 102 (AI Lab Wing)',
        'email': 'snehasharma.ai@charusat.ac.in',
        'hours': '11:00 AM - 1:00 PM',
      },
      {
        'name': 'Prof. Amit Shah',
        'designation': 'Assistant Professor',
        'dept': 'Database Management Systems (DBMS)',
        'cabin': 'Cabin 301, 3rd Floor FTE',
        'email': 'amitshah.ce@charusat.ac.in',
        'hours': '2:00 PM - 4:00 PM',
      },
      {
        'name': 'Dr. Ritu Desai',
        'designation': 'Head of Department',
        'dept': 'Computer Networks & Security',
        'cabin': 'HOD Office 210, FTE',
        'email': 'ritudesai.ce@charusat.ac.in',
        'hours': '10:00 AM - 12:00 PM',
      },
      {
        'name': 'Coach Vikram Singh',
        'designation': 'University Sports Director',
        'dept': 'Athletics & Physical Education Hub',
        'cabin': 'Sports Complex Directorate',
        'email': 'sports.director@charusat.ac.in',
        'hours': '6:00 AM - 8:30 AM',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: faculties.length,
      itemBuilder: (context, idx) {
        final f = faculties[idx];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFF0D47A1),
                  child: Text(
                    f['name']!.split(' ').map((e) => e[0]).take(2).join(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f['name']!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${f['designation']!} • ${f['dept']!}',
                        style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.meeting_room_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              f['cabin']!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              f['email']!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Consultation: ${f['hours']!}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
        );
      },
    );
  }
}

// ============================================================================
// MODULE 7: EVENT GALLERY MODULE (Syllabus: GridView with At Least 6 Cards)
// ============================================================================
class EventGalleryModule extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const EventGalleryModule({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    // Syllabus specified dataset: Display at least six event cards using GridView
    final List<Map<String, dynamic>> events = [
      {
        'title': 'CHARUSAT Spoural 2026',
        'category': 'Annual Sports Fest',
        'date': 'Nov 15-18, 2026',
        'venue': 'University Sports Complex',
        'icon': Icons.sports_soccer_rounded,
        'gradient': [const Color(0xFF0D47A1), const Color(0xFF1976D2)],
      },
      {
        'title': 'National Flutter Hackathon',
        'category': 'Mobile App Sprint',
        'date': 'Oct 28-29, 2026',
        'venue': 'FTE Innovation Center',
        'icon': Icons.phone_android_rounded,
        'gradient': [const Color(0xFF00695C), const Color(0xFF26A69A)],
      },
      {
        'title': 'AI & Deep Learning Summit',
        'category': 'Keynotes & Demos',
        'date': 'Nov 05, 2026',
        'venue': 'Central Auditorium',
        'icon': Icons.psychology_rounded,
        'gradient': [const Color(0xFF6A1B9A), const Color(0xFFAB47BC)],
      },
      {
        'title': 'Inter-Dept Football Cup',
        'category': 'Varsity Knockouts',
        'date': 'Nov 10, 2026',
        'venue': 'Campus Turf Arena',
        'icon': Icons.sports_football_rounded,
        'gradient': [const Color(0xFF2E7D32), const Color(0xFF66BB6A)],
      },
      {
        'title': 'Cloud & DevOps Bootcamp',
        'category': 'Hands-on Labs',
        'date': 'Nov 02, 2026',
        'venue': 'Computer Lab 304',
        'icon': Icons.cloud_done_rounded,
        'gradient': [const Color(0xFFD84315), const Color(0xFFFF7043)],
      },
      {
        'title': 'Badminton Masters League',
        'category': 'Singles & Doubles',
        'date': 'Nov 12, 2026',
        'venue': 'Indoor Sports Hall',
        'icon': Icons.sports_tennis_rounded,
        'gradient': [const Color(0xFFC2185B), const Color(0xFFEC407A)],
      },
      {
        'title': 'Startup Pitch & Showcase',
        'category': 'Incubation Expo',
        'date': 'Nov 20, 2026',
        'venue': 'CHARUSAT Incubation Center',
        'icon': Icons.rocket_launch_rounded,
        'gradient': [const Color(0xFF4527A0), const Color(0xFF7E57C2)],
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive Grid calculation: 2 columns on mobile, 3 columns on tablet/desktop
        final int crossAxisCount = constraints.maxWidth >= 700 ? 3 : 2;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.70,
          ),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final ev = events[index];
            final List<Color> gradient = ev['gradient'] as List<Color>;

            return Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Banner with Gradient & Icon
                  Container(
                    height: 75,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -10,
                          bottom: -10,
                          child: Icon(
                            ev['icon'] as IconData,
                            size: 70,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                ev['category'] as String,
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Event Info Details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ev['title'] as String,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 11, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      ev['date'] as String,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.place, size: 11, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      ev['venue'] as String,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 28,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: gradient[0],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Registered for ${ev['title']}!'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: const Text('Register', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
