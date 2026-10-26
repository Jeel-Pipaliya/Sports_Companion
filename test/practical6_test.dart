// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development (Semester 5)
// PRACTICAL 6: SQLite Database & Local Data Persistence Test Suite
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_companion/database_helper.dart';
import 'package:sports_companion/practical6_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    final helper = DatabaseHelper();
    helper.setUseInMemory(true);
    await helper.resetToSampleData();
  });

  group('Practical 6: DatabaseHelper CRUD Unit Tests (Student Notes)', () {
    test('Verifies initial syllabus seed notes exist', () async {
      final helper = DatabaseHelper();
      final notes = await helper.getAllNotes();

      expect(notes.isNotEmpty, true);
      final flutterNote = notes.firstWhere((n) => n.title == 'Flutter Widgets');
      expect(flutterNote.subject, 'Mobile Application Development');
      expect(flutterNote.description.contains('Stateless and Stateful'), true);
    });

    test('Verifies insertNote creates and returns new note ID', () async {
      final helper = DatabaseHelper();
      final newNote = StudentNote(
        title: 'SQLite Architecture in Flutter',
        description: 'Study sqflite plugin, DatabaseHelper singleton, and B-Tree indexing.',
        subject: 'Mobile Application Development',
        createdDate: '2026-10-26',
        colorTag: 1,
      );

      final id = await helper.insertNote(newNote);
      expect(id > 0, true);

      final fetched = await helper.getNoteById(id);
      expect(fetched, isNotNull);
      expect(fetched!.title, 'SQLite Architecture in Flutter');
      expect(fetched.colorTag, 1);
    });

    test('Verifies updateNote modifies existing record', () async {
      final helper = DatabaseHelper();
      final notes = await helper.getAllNotes();
      final target = notes.first;

      final updated = target.copyWith(
        title: 'Updated Note Title',
        description: 'Modified note content for unit test validation.',
      );

      final rowsAffected = await helper.updateNote(updated);
      expect(rowsAffected, 1);

      final reFetched = await helper.getNoteById(target.id!);
      expect(reFetched!.title, 'Updated Note Title');
      expect(reFetched.description, 'Modified note content for unit test validation.');
    });

    test('Verifies deleteNote removes record from database', () async {
      final helper = DatabaseHelper();
      final notesBefore = await helper.getAllNotes();
      final countBefore = notesBefore.length;
      final targetId = notesBefore.first.id!;

      final deletedRows = await helper.deleteNote(targetId);
      expect(deletedRows, 1);

      final notesAfter = await helper.getAllNotes();
      expect(notesAfter.length, countBefore - 1);

      final exists = await helper.getNoteById(targetId);
      expect(exists, isNull);
    });

    test('Verifies searchNotes and subject filter', () async {
      final helper = DatabaseHelper();

      // Search by query
      final searchResults = await helper.getAllNotes(searchQuery: 'Normalization');
      expect(searchResults.length, 1);
      expect(searchResults.first.title.contains('Normalization'), true);

      // Filter by subject
      final madNotes = await helper.getAllNotes(
        subjectFilter: 'Mobile Application Development',
      );
      expect(madNotes.every((n) => n.subject == 'Mobile Application Development'), true);
    });
  });

  group('Practical 6: DatabaseHelper CRUD Unit Tests (Task Manager)', () {
    test('Verifies initial syllabus seed tasks exist', () async {
      final helper = DatabaseHelper();
      final tasks = await helper.getAllTasks();

      expect(tasks.isNotEmpty, true);
      final flutterTask = tasks.firstWhere((t) => t.taskName == 'Submit Flutter Assignment');
      expect(flutterTask.priority, 'High');
      expect(flutterTask.status, 'Pending');
    });

    test('Verifies insertTask creates new task record', () async {
      final helper = DatabaseHelper();
      final newTask = TaskManager(
        taskName: 'Complete Practical 6 Documentation & Report',
        dueDate: '2026-10-27',
        priority: 'High',
        status: 'Pending',
        category: 'Assignment',
      );

      final id = await helper.insertTask(newTask);
      expect(id > 0, true);

      final fetched = await helper.getTaskById(id);
      expect(fetched, isNotNull);
      expect(fetched!.taskName, 'Complete Practical 6 Documentation & Report');
      expect(fetched.priority, 'High');
    });

    test('Verifies toggleTaskStatus switches Pending <-> Completed', () async {
      final helper = DatabaseHelper();
      final tasks = await helper.getAllTasks();
      final pendingTask = tasks.firstWhere((t) => t.status == 'Pending');

      // Toggle to Completed
      await helper.toggleTaskStatus(pendingTask.id!, 'Pending');
      var updated = await helper.getTaskById(pendingTask.id!);
      expect(updated!.status, 'Completed');

      // Toggle back to Pending
      await helper.toggleTaskStatus(pendingTask.id!, 'Completed');
      updated = await helper.getTaskById(pendingTask.id!);
      expect(updated!.status, 'Pending');
    });

    test('Verifies deleteTask removes task record', () async {
      final helper = DatabaseHelper();
      final tasksBefore = await helper.getAllTasks();
      final countBefore = tasksBefore.length;
      final targetId = tasksBefore.first.id!;

      await helper.deleteTask(targetId);
      final tasksAfter = await helper.getAllTasks();
      expect(tasksAfter.length, countBefore - 1);
    });

    test('Verifies getDatabaseStatistics calculation', () async {
      final helper = DatabaseHelper();
      final stats = await helper.getDatabaseStatistics();

      expect(stats.containsKey('totalNotes'), true);
      expect(stats.containsKey('totalTasks'), true);
      expect(stats.containsKey('pendingTasks'), true);
      expect(stats.containsKey('completedTasks'), true);
      expect(stats.containsKey('highPriorityTasks'), true);
      expect((stats['totalNotes'] as int) > 0, true);
      expect((stats['totalTasks'] as int) > 0, true);
    });
  });

  group('Practical 6: Widget & UI Integration Tests', () {
    testWidgets('Renders Practical6DatabaseHubScreen with TabBar and Notes', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: Practical6DatabaseHubScreen(
            onToggleTheme: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Header & Tabs
      expect(find.text('Practical 6: SQLite Database'), findsOneWidget);
      expect(find.text('Student Notes'), findsOneWidget);
      expect(find.text('Task Manager'), findsOneWidget);
      expect(find.text('SQLite Stats'), findsOneWidget);

      // Verify Notes List contains sample records
      expect(find.text('Flutter Widgets'), findsOneWidget);
      expect(find.text('Relational Database Normalization'), findsOneWidget);
      expect(find.text('Mobile Application Development'), findsAtLeast(1));

      // Verify Add Note FAB
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Switches to Task Manager tab and renders tasks', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Practical6DatabaseHubScreen(
            onToggleTheme: () {},
            initialTabIndex: 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Task tab content
      expect(find.text('Submit Flutter Assignment'), findsOneWidget);
      expect(find.text('Prepare DBMS Practical'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('Switches to SQLite Stats tab and renders analytics & schema', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Practical6DatabaseHubScreen(
            onToggleTheme: () {},
            initialTabIndex: 2,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Stats Header
      expect(find.text('SQLite Engine Active'), findsOneWidget);
      expect(find.text('Total Notes'), findsOneWidget);
      expect(find.text('Total Tasks'), findsOneWidget);
      expect(find.text('Database Schema & SQL DDL'), findsOneWidget);
      expect(find.text('Table: student_notes'), findsOneWidget);
      expect(find.text('Table: task_manager'), findsOneWidget);
    });
  });
}
