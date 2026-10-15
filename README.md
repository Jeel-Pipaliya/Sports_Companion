# 🏆 Sports Companion - Smart Athletic Performance App
**Course**: AIUE302 – Mobile Application Development (Semester 5)  
**Institution**: Charotar University of Science and Technology (CHARUSAT)  
**Faculty**: Faculty of Technology and Engineering (FTE)  
**Academic Year**: 2026-27 (ODD)  
**CO Mapping**: CO1  

---

## 📋 Practical 1: Flutter Development Environment Setup and Project Initialization

### 🎯 Objective
Configure the complete Flutter development environment, initialize the foundation for the **Smart Sports Companion App**, study the 3-tier Flutter architecture, understand the project folder structure, implement core **Dart programming fundamentals and Object-Oriented Programming (OOP)** concepts, and execute the application.

---

## 🛠️ Environment Configuration & Verification

| Component | Version / Status | Notes |
| :--- | :--- | :--- |
| **Flutter SDK** | `3.44.9` (Channel stable) | Google official cross-platform UI framework |
| **Dart SDK** | `3.12.2` (x64) | Strongly typed client-optimized language |
| **DevTools** | `2.57.0` | Performance & widget tree profiler |
| **Target Platforms** | Android, Web, Windows Desktop | Cross-platform build targets |
| **Rendering Engine** | Impeller / Skia | High-performance hardware-accelerated 2D pipeline |

### Verification Command (`flutter doctor`)
```bash
flutter doctor -v
```

---

## 📂 Project Directory Structure

```text
sports_companion/
├── android/                 # Native Android Gradle configuration & AndroidManifest.xml
├── assets/                  # Application static assets
│   ├── data/                # Sample athlete JSON datasets (athlete_data.json)
│   ├── icons/               # Sports & discipline vector icons
│   └── images/              # Banner and athlete avatar resources
├── bin/                     # Standalone runnable Dart scripts
│   └── dart_fundamentals.dart # Full Dart OOP & language syntax demonstration
├── ios/                     # Native iOS Xcode workspace and CocoaPods configs
├── lib/                     # Core Flutter application source code
│   ├── main.dart            # Application entrypoint & Practical 1 interactive UI
│   └── models/              # Domain models & OOP hierarchy
│       └── athlete.dart     # Athlete, FootballPlayer, TrackAthlete, Mixins
├── test/                    # Unit and widget test suite
│   └── widget_test.dart     # Smoke tests & polymorphic calculations verification
├── web/                     # Web entry point & service workers
├── windows/                 # Windows C++ Desktop embedder
├── pubspec.yaml             # Manifest, dependencies, fonts, and assets declaration
└── README.md                # Project documentation
```

---

## 🏃 Quick Start: Execution Commands

### 1. Run the Dart Fundamentals Console Demonstration
Runs the comprehensive command-line demonstration showing variables, operators, loops, functions, closures, inheritance, polymorphism, and mixins:
```bash
dart run bin/dart_fundamentals.dart
```

### 2. Run the Interactive Flutter Application
Run on your connected Android device, Emulator, Windows, or Chrome browser:
```bash
# Run on Chrome
flutter run -d chrome

# Run on Windows Desktop
flutter run -d windows
```

### 3. Run Automated Unit & Widget Tests
```bash
flutter test
```

### 4. Code Quality & Static Analysis
```bash
flutter analyze
```

---

## 🧩 Practical 1 Feature Highlights

1. **Setup & Architecture Tab**:
   - Live environment status report.
   - 3-Tier interactive architecture breakdown: Framework (Dart), Engine (C/C++ Impeller/Skia), Embedder.
   - Comprehensive folder directory guide.

2. **Dart Fundamentals Tab**:
   - Syntax review for `var`, `final`, `const`, `late`, null safety (`?`, `??`).
   - Modern Dart 3 switch expressions with pattern matching & relational guards (`< 100`, `>= 100 && < 130`).
   - Interactive live calculation tools (BMI calculation and Heart Rate Zone classifier using mixins and closures).

3. **OOP & Athletes Tab**:
   - Encapsulation: Private variables (`_fitnessScore`, `_attendancePercentage`) protected by getters and defensive validation setters.
   - Inheritance & Polymorphism: `Athlete` abstract base class extended by `FootballPlayer` and `TrackAthlete` with overridden `calculatePerformanceRating()`.
   - Mixin: `PerformanceMetricsMixin` delivering shared health calculations.
   - Interface: `Trainable` implemented by all athletes.
   - Interactive button to log drills using Dart cascade notation (`..`).

4. **Viva & Key Questions Reference Tab**:
   - Ready answers to all 8 evaluation questions from the course syllabus.

---

## 👥 Student & Test Data Details
- **Lead Athlete**: Rahul Patel (`24SPT001`) — Football & Athletics (Sem 5)
- **Track Athlete**: Ananya Sharma (`24SPT002`) — Track & Field (Sem 5)
- **Course**: AIUE302 Mobile Application Development
