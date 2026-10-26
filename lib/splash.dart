// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development
// WORK/MODULE: Splash Screen with Session Verification
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';
import 'preferences_service.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const SplashScreen({super.key, required this.onToggleTheme});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PreferencesService _prefs = PreferencesService();
  bool _isCheckingSession = false;
  String _statusText = 'Secure session verified';

  @override
  void initState() {
    super.initState();
    _isCheckingSession = !_prefs.isInitialized;
    _verifySession();
  }

  Future<void> _verifySession() async {
    if (!_prefs.isInitialized) {
      await _prefs.init();
    }
    if (!mounted) return;

    setState(() {
      _isCheckingSession = false;
      _statusText = _prefs.isLoggedIn
          ? 'Session found: ${_prefs.userName}'
          : 'Ready for authentication';
    });
  }

  void _proceedToNext() {
    if (_prefs.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

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
              const SizedBox(height: 12),

              // Session status indicator
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isCheckingSession ? Icons.sync : (_prefs.isLoggedIn ? Icons.verified : Icons.lock_open),
                      size: 14,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _statusText,
                      style: const TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
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
                    onPressed: _proceedToNext,
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
