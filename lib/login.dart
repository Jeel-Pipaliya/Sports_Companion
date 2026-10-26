// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development
// WORK/MODULE: Student & Athlete Authentication / Login Screen (Practical 5)
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';
import 'preferences_service.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const LoginScreen({super.key, required this.onToggleTheme});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController(text: '24AIML051');
  final _passwordController = TextEditingController(text: 'student@123');
  bool _obscurePassword = true;
  bool _rememberMe = true;
  final PreferencesService _prefs = PreferencesService();

  @override
  void initState() {
    super.initState();
    _loadSavedPreferences();
  }

  Future<void> _loadSavedPreferences() async {
    await _prefs.init();
    if (mounted) {
      setState(() {
        if (_prefs.rememberMe && _prefs.userEmail.isNotEmpty) {
          _idController.text = _prefs.userEmail;
        }
        _rememberMe = _prefs.rememberMe;
      });
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _idController.text.trim();
      final isRahul = email.contains('rahul') || email.contains('24CE001');
      final studentName = isRahul ? 'Rahul Patel' : 'Jeel Pipaliya';

      // Save user session to SharedPreferences
      _prefs.saveUserSession(
        email: email,
        name: studentName,
        rememberMe: _rememberMe,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful! Welcome $studentName.'),
          backgroundColor: const Color(0xFF16A34A),
          duration: const Duration(seconds: 1),
        ),
      );
      // Replace login screen in navigation stack so user cannot pop back into login
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  void _fillSampleCredentials() {
    setState(() {
      _idController.text = 'rahul.patel@charusat.edu.in';
      _passwordController.text = 'student@123';
      _rememberMe = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                  const SizedBox(height: 20),

                  // Sample credentials helper card
                  Card(
                    color: const Color(0xFF0D47A1).withValues(alpha: 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF0D47A1), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Icon(Icons.key, color: Color(0xFF0D47A1), size: 18),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Syllabus Sample Credentials',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
                                ),
                                Text(
                                  'rahul.patel@charusat.edu.in / student@123',
                                  style: TextStyle(fontSize: 10.5, color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: _fillSampleCredentials,
                            child: const Text('Auto-Fill', style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'Enrollment ID / Email',
                      prefixIcon: Icon(Icons.badge_outlined),
                      hintText: 'e.g. 24AIML051 or rahul.patel@charusat.edu.in',
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
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 10),

                  // Remember Me checkbox
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Remember me & persist session',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    subtitle: const Text(
                      'Save credentials in SharedPreferences across app restarts',
                      style: TextStyle(fontSize: 11),
                    ),
                    value: _rememberMe,
                    activeColor: const Color(0xFF0D47A1),
                    onChanged: (val) {
                      setState(() {
                        _rememberMe = val ?? true;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

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
