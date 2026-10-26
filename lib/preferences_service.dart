// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development (Semester 5)
// PRACTICAL 5: Implement Navigation, Routing, and Persistent User Preferences
// STUDENT: Jeel Pipaliya (24AIML051)
// MODULE: PreferencesService (Persistent Storage with SharedPreferences)
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Singleton Service to handle persistent key-value storage using SharedPreferences.
/// Extends ChangeNotifier to allow reactive UI updates whenever preferences change.
class PreferencesService extends ChangeNotifier {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  // Storage Keys
  static const String keyIsLoggedIn = 'sp_is_logged_in';
  static const String keyRememberMe = 'sp_remember_me';
  static const String keyUserEmail = 'sp_user_email';
  static const String keyUserName = 'sp_user_name';
  static const String keyEnrollmentNo = 'sp_enrollment_no';
  static const String keyDepartment = 'sp_department';
  static const String keySelectedTheme = 'sp_selected_theme'; // 'System', 'Light', 'Dark'
  static const String keySelectedLanguage = 'sp_selected_language'; // 'English', 'Hindi', 'Gujarati'
  static const String keySelectedSemester = 'sp_selected_semester'; // 'Semester V'
  static const String keyNotificationsEnabled = 'sp_notifications_enabled';
  static const String keyAttendanceThreshold = 'sp_attendance_threshold'; // 85.0
  static const String keySportsInterest = 'sp_sports_interest';

  // In-memory cached values for synchronous access
  bool _isLoggedIn = false;
  bool _rememberMe = true;
  String _userEmail = 'rahul.patel@charusat.edu.in';
  String _userName = 'Rahul Patel';
  String _enrollmentNo = '24AIML051';
  String _department = 'Artificial Intelligence & Machine Learning';
  String _selectedTheme = 'System';
  String _selectedLanguage = 'English';
  String _selectedSemester = 'Semester V';
  bool _notificationsEnabled = true;
  double _attendanceThreshold = 85.0;
  String _sportsInterest = 'Athletics & Badminton';
  bool _isInitialized = false;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  bool get rememberMe => _rememberMe;
  String get userEmail => _userEmail;
  String get userName => _userName;
  String get enrollmentNo => _enrollmentNo;
  String get department => _department;
  String get selectedTheme => _selectedTheme;
  String get selectedLanguage => _selectedLanguage;
  String get selectedSemester => _selectedSemester;
  bool get notificationsEnabled => _notificationsEnabled;
  double get attendanceThreshold => _attendanceThreshold;
  String get sportsInterest => _sportsInterest;
  bool get isInitialized => _isInitialized;

  /// Initialize and load saved preferences from disk
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool(keyIsLoggedIn) ?? false;
      _rememberMe = prefs.getBool(keyRememberMe) ?? true;
      _userEmail = prefs.getString(keyUserEmail) ?? 'rahul.patel@charusat.edu.in';
      _userName = prefs.getString(keyUserName) ?? 'Rahul Patel';
      _enrollmentNo = prefs.getString(keyEnrollmentNo) ?? '24AIML051';
      _department = prefs.getString(keyDepartment) ?? 'Artificial Intelligence & Machine Learning';
      _selectedTheme = prefs.getString(keySelectedTheme) ?? 'System';
      _selectedLanguage = prefs.getString(keySelectedLanguage) ?? 'English';
      _selectedSemester = prefs.getString(keySelectedSemester) ?? 'Semester V';
      _notificationsEnabled = prefs.getBool(keyNotificationsEnabled) ?? true;
      _attendanceThreshold = prefs.getDouble(keyAttendanceThreshold) ?? 85.0;
      _sportsInterest = prefs.getString(keySportsInterest) ?? 'Athletics & Badminton';
    } catch (e) {
      debugPrint('PreferencesService init error (falling back to memory): $e');
    }
    _isInitialized = true;
    notifyListeners();
  }

  /// Save user login session
  Future<void> saveUserSession({
    required String email,
    required String name,
    required bool rememberMe,
  }) async {
    _isLoggedIn = true;
    _userEmail = email;
    _userName = name;
    _rememberMe = rememberMe;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(keyIsLoggedIn, true);
      await prefs.setBool(keyRememberMe, rememberMe);
      await prefs.setString(keyUserEmail, email);
      await prefs.setString(keyUserName, name);
    } catch (e) {
      debugPrint('PreferencesService saveUserSession error: $e');
    }
    notifyListeners();
  }

  /// Clear user session on Logout
  Future<void> clearUserSession() async {
    _isLoggedIn = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(keyIsLoggedIn, false);
      if (!_rememberMe) {
        await prefs.remove(keyUserEmail);
        await prefs.remove(keyUserName);
      }
    } catch (e) {
      debugPrint('PreferencesService clearUserSession error: $e');
    }
    notifyListeners();
  }

  /// Update Theme Mode Preference
  Future<void> setTheme(String theme) async {
    _selectedTheme = theme;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(keySelectedTheme, theme);
    } catch (e) {
      debugPrint('PreferencesService setTheme error: $e');
    }
    notifyListeners();
  }

  /// Update Language Preference
  Future<void> setLanguage(String language) async {
    _selectedLanguage = language;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(keySelectedLanguage, language);
    } catch (e) {
      debugPrint('PreferencesService setLanguage error: $e');
    }
    notifyListeners();
  }

  /// Update Semester Preference
  Future<void> setSemester(String semester) async {
    _selectedSemester = semester;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(keySelectedSemester, semester);
    } catch (e) {
      debugPrint('PreferencesService setSemester error: $e');
    }
    notifyListeners();
  }

  /// Update Notifications Enabled Preference
  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(keyNotificationsEnabled, enabled);
    } catch (e) {
      debugPrint('PreferencesService setNotificationsEnabled error: $e');
    }
    notifyListeners();
  }

  /// Update Attendance Threshold Preference
  Future<void> setAttendanceThreshold(double threshold) async {
    _attendanceThreshold = threshold;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(keyAttendanceThreshold, threshold);
    } catch (e) {
      debugPrint('PreferencesService setAttendanceThreshold error: $e');
    }
    notifyListeners();
  }

  /// Update Profile Details
  Future<void> updateProfile({
    required String name,
    required String enrollmentNo,
    required String department,
    required String sportsInterest,
  }) async {
    _userName = name;
    _enrollmentNo = enrollmentNo;
    _department = department;
    _sportsInterest = sportsInterest;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(keyUserName, name);
      await prefs.setString(keyEnrollmentNo, enrollmentNo);
      await prefs.setString(keyDepartment, department);
      await prefs.setString(keySportsInterest, sportsInterest);
    } catch (e) {
      debugPrint('PreferencesService updateProfile error: $e');
    }
    notifyListeners();
  }

  /// Reset all preferences to university defaults
  Future<void> resetToDefaults() async {
    _selectedTheme = 'System';
    _selectedLanguage = 'English';
    _selectedSemester = 'Semester V';
    _notificationsEnabled = true;
    _attendanceThreshold = 85.0;
    _sportsInterest = 'Athletics & Badminton';

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(keySelectedTheme, _selectedTheme);
      await prefs.setString(keySelectedLanguage, _selectedLanguage);
      await prefs.setString(keySelectedSemester, _selectedSemester);
      await prefs.setBool(keyNotificationsEnabled, _notificationsEnabled);
      await prefs.setDouble(keyAttendanceThreshold, _attendanceThreshold);
      await prefs.setString(keySportsInterest, _sportsInterest);
    } catch (e) {
      debugPrint('PreferencesService resetToDefaults error: $e');
    }
    notifyListeners();
  }

  /// Export all current preferences as a Map for state inspection & debugging
  Map<String, dynamic> toMap() {
    return {
      'isLoggedIn': _isLoggedIn,
      'rememberMe': _rememberMe,
      'userEmail': _userEmail,
      'userName': _userName,
      'enrollmentNo': _enrollmentNo,
      'department': _department,
      'selectedTheme': _selectedTheme,
      'selectedLanguage': _selectedLanguage,
      'selectedSemester': _selectedSemester,
      'notificationsEnabled': _notificationsEnabled,
      'attendanceThreshold': _attendanceThreshold,
      'sportsInterest': _sportsInterest,
      'storageEngine': 'SharedPreferences (Local Persistence)',
    };
  }
}
