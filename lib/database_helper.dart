// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development (Semester 5)
// PRACTICAL 6: Develop Student Notes and Task Management Module using SQLite Database
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// ============================================================================
// DATA MODEL 1: StudentNote
// ============================================================================
class StudentNote {
  final int? id;
  final String title;
  final String description;
  final String subject;
  final String createdDate;
  final int colorTag;

  StudentNote({
    this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.createdDate,
    this.colorTag = 0,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
      'subject': subject,
      'created_date': createdDate,
      'color_tag': colorTag,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory StudentNote.fromMap(Map<String, dynamic> map) {
    return StudentNote(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      subject: map['subject'] as String? ?? '',
      createdDate: map['created_date'] as String? ?? '',
      colorTag: map['color_tag'] as int? ?? 0,
    );
  }

  StudentNote copyWith({
    int? id,
    String? title,
    String? description,
    String? subject,
    String? createdDate,
    int? colorTag,
  }) {
    return StudentNote(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      createdDate: createdDate ?? this.createdDate,
      colorTag: colorTag ?? this.colorTag,
    );
  }
}

// ============================================================================
// DATA MODEL 2: TaskManager
// ============================================================================
class TaskManager {
  final int? id;
  final String taskName;
  final String dueDate;
  final String priority; // High, Medium, Low
  final String status; // Pending, Completed
  final String category; // Academic, Assignment, Exam, Placement, Sports

  TaskManager({
    this.id,
    required this.taskName,
    required this.dueDate,
    required this.priority,
    required this.status,
    this.category = 'Academic',
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'task_name': taskName,
      'due_date': dueDate,
      'priority': priority,
      'status': status,
      'category': category,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory TaskManager.fromMap(Map<String, dynamic> map) {
    return TaskManager(
      id: map['id'] as int?,
      taskName: map['task_name'] as String? ?? '',
      dueDate: map['due_date'] as String? ?? '',
      priority: map['priority'] as String? ?? 'Medium',
      status: map['status'] as String? ?? 'Pending',
      category: map['category'] as String? ?? 'Academic',
    );
  }

  TaskManager copyWith({
    int? id,
    String? taskName,
    String? dueDate,
    String? priority,
    String? status,
    String? category,
  }) {
    return TaskManager(
      id: id ?? this.id,
      taskName: taskName ?? this.taskName,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      category: category ?? this.category,
    );
  }
}

// ============================================================================
// DATABASE HELPER (Singleton Pattern)
// ============================================================================
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const String dbName = 'smart_student_companion.db';
  static const int dbVersion = 1;

  // Table & Column definitions
  static const String tableNotes = 'student_notes';
  static const String tableTasks = 'task_manager';

  // In-memory web / test fallback storage
  final List<StudentNote> _memoryNotes = [];
  final List<TaskManager> _memoryTasks = [];
  int _nextNoteId = 1;
  int _nextTaskId = 1;
  bool _useInMemory = false;

  /// Force in-memory mode for web preview or headless environments
  void setUseInMemory(bool value) {
    _useInMemory = value;
  }

  Future<Database?> get database async {
    if (kIsWeb || _useInMemory) {
      return null;
    }
    if (_database != null) return _database;
    try {
      _database = await _initDatabase();
      return _database;
    } catch (e) {
      debugPrint('Database initialization warning (falling back to memory): $e');
      _useInMemory = true;
      _initSampleMemoryData();
      return null;
    }
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, dbName);

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Create student_notes table
    await db.execute('''
      CREATE TABLE $tableNotes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        subject TEXT NOT NULL,
        created_date TEXT NOT NULL,
        color_tag INTEGER DEFAULT 0
      )
    ''');

    // 2. Create task_manager table
    await db.execute('''
      CREATE TABLE $tableTasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task_name TEXT NOT NULL,
        due_date TEXT NOT NULL,
        priority TEXT NOT NULL,
        status TEXT NOT NULL,
        category TEXT DEFAULT 'Academic'
      )
    ''');

    // 3. Pre-populate initial syllabus test data
    await _seedDatabase(db);
  }

  Future<void> _seedDatabase(Database db) async {
    final batch = db.batch();

    // Notes Seed Data (including syllabus sample)
    final initialNotes = [
      StudentNote(
        title: 'Flutter Widgets',
        subject: 'Mobile Application Development',
        description: 'Study Stateless and Stateful Widgets, LayoutBuilder, and setState() state management lifecycle.',
        createdDate: '2026-10-20',
        colorTag: 0,
      ),
      StudentNote(
        title: 'Relational Database Normalization',
        subject: 'Database Management Systems',
        description: 'Study 1NF, 2NF, 3NF, BCNF, functional dependencies, and lossless join decomposition.',
        createdDate: '2026-10-22',
        colorTag: 1,
      ),
      StudentNote(
        title: 'Convolutional Neural Networks (CNN)',
        subject: 'Artificial Intelligence & ML',
        description: 'Implement feature maps, convolutional kernels, max-pooling layers, and softmax loss functions.',
        createdDate: '2026-10-24',
        colorTag: 2,
      ),
      StudentNote(
        title: 'TCP/IP Protocol Stack & Subnetting',
        subject: 'Computer Networks',
        description: 'Calculate CIDR subnet masks, IP routing tables, and transport layer 3-way handshakes.',
        createdDate: '2026-10-25',
        colorTag: 3,
      ),
    ];

    for (var note in initialNotes) {
      batch.insert(tableNotes, note.toMap());
    }

    // Tasks Seed Data (including syllabus sample)
    final initialTasks = [
      TaskManager(
        taskName: 'Submit Flutter Assignment',
        dueDate: '2026-10-28',
        priority: 'High',
        status: 'Pending',
        category: 'Academic',
      ),
      TaskManager(
        taskName: 'Prepare DBMS Practical',
        dueDate: '2026-10-30',
        priority: 'Medium',
        status: 'Pending',
        category: 'Academic',
      ),
      TaskManager(
        taskName: 'Complete REST API Module',
        dueDate: '2026-11-02',
        priority: 'High',
        status: 'Pending',
        category: 'Assignment',
      ),
      TaskManager(
        taskName: 'Attend Placement Workshop',
        dueDate: '2026-11-05',
        priority: 'Low',
        status: 'Completed',
        category: 'Placement',
      ),
      TaskManager(
        taskName: 'Athletic Meet High-Jump Drill',
        dueDate: '2026-11-08',
        priority: 'Medium',
        status: 'Pending',
        category: 'Sports',
      ),
    ];

    for (var task in initialTasks) {
      batch.insert(tableTasks, task.toMap());
    }

    await batch.commit(noResult: true);
  }

  void _initSampleMemoryData() {
    if (_memoryNotes.isEmpty && _memoryTasks.isEmpty) {
      _memoryNotes.addAll([
        StudentNote(
          id: _nextNoteId++,
          title: 'Flutter Widgets',
          subject: 'Mobile Application Development',
          description: 'Study Stateless and Stateful Widgets, LayoutBuilder, and setState() state management lifecycle.',
          createdDate: '2026-10-20',
          colorTag: 0,
        ),
        StudentNote(
          id: _nextNoteId++,
          title: 'Relational Database Normalization',
          subject: 'Database Management Systems',
          description: 'Study 1NF, 2NF, 3NF, BCNF, functional dependencies, and lossless join decomposition.',
          createdDate: '2026-10-22',
          colorTag: 1,
        ),
        StudentNote(
          id: _nextNoteId++,
          title: 'Convolutional Neural Networks (CNN)',
          subject: 'Artificial Intelligence & ML',
          description: 'Implement feature maps, convolutional kernels, max-pooling layers, and softmax loss functions.',
          createdDate: '2026-10-24',
          colorTag: 2,
        ),
        StudentNote(
          id: _nextNoteId++,
          title: 'TCP/IP Protocol Stack & Subnetting',
          subject: 'Computer Networks',
          description: 'Calculate CIDR subnet masks, IP routing tables, and transport layer 3-way handshakes.',
          createdDate: '2026-10-25',
          colorTag: 3,
        ),
      ]);

      _memoryTasks.addAll([
        TaskManager(
          id: _nextTaskId++,
          taskName: 'Submit Flutter Assignment',
          dueDate: '2026-10-28',
          priority: 'High',
          status: 'Pending',
          category: 'Academic',
        ),
        TaskManager(
          id: _nextTaskId++,
          taskName: 'Prepare DBMS Practical',
          dueDate: '2026-10-30',
          priority: 'Medium',
          status: 'Pending',
          category: 'Academic',
        ),
        TaskManager(
          id: _nextTaskId++,
          taskName: 'Complete REST API Module',
          dueDate: '2026-11-02',
          priority: 'High',
          status: 'Pending',
          category: 'Assignment',
        ),
        TaskManager(
          id: _nextTaskId++,
          taskName: 'Attend Placement Workshop',
          dueDate: '2026-11-05',
          priority: 'Low',
          status: 'Completed',
          category: 'Placement',
        ),
        TaskManager(
          id: _nextTaskId++,
          taskName: 'Athletic Meet High-Jump Drill',
          dueDate: '2026-11-08',
          priority: 'Medium',
          status: 'Pending',
          category: 'Sports',
        ),
      ]);
    }
  }

  // ============================================================================
  // CRUD OPERATIONS: Student Notes
  // ============================================================================

  /// CREATE: Insert a new student note
  Future<int> insertNote(StudentNote note) async {
    final db = await database;
    if (db != null) {
      return await db.insert(tableNotes, note.toMap());
    } else {
      _initSampleMemoryData();
      final newNote = note.copyWith(id: _nextNoteId++);
      _memoryNotes.insert(0, newNote);
      return newNote.id!;
    }
  }

  /// READ: Get all notes with optional search, subject filter, and sorting
  Future<List<StudentNote>> getAllNotes({
    String? searchQuery,
    String? subjectFilter,
    String? sortBy, // 'date_desc', 'date_asc', 'title_asc'
  }) async {
    final db = await database;
    if (db != null) {
      List<String> whereClauses = [];
      List<dynamic> whereArgs = [];

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        whereClauses.add('(title LIKE ? OR description LIKE ? OR subject LIKE ?)');
        final q = '%${searchQuery.trim()}%';
        whereArgs.addAll([q, q, q]);
      }

      if (subjectFilter != null && subjectFilter.isNotEmpty && subjectFilter != 'All Subjects') {
        whereClauses.add('subject = ?');
        whereArgs.add(subjectFilter);
      }

      String orderBy = 'id DESC';
      if (sortBy == 'date_asc') {
        orderBy = 'created_date ASC, id ASC';
      } else if (sortBy == 'date_desc') {
        orderBy = 'created_date DESC, id DESC';
      } else if (sortBy == 'title_asc') {
        orderBy = 'title ASC';
      }

      final maps = await db.query(
        tableNotes,
        where: whereClauses.isEmpty ? null : whereClauses.join(' AND '),
        whereArgs: whereArgs.isEmpty ? null : whereArgs,
        orderBy: orderBy,
      );

      return maps.map((m) => StudentNote.fromMap(m)).toList();
    } else {
      _initSampleMemoryData();
      var list = List<StudentNote>.from(_memoryNotes);

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        list = list.where((n) =>
            n.title.toLowerCase().contains(q) ||
            n.description.toLowerCase().contains(q) ||
            n.subject.toLowerCase().contains(q)).toList();
      }

      if (subjectFilter != null && subjectFilter.isNotEmpty && subjectFilter != 'All Subjects') {
        list = list.where((n) => n.subject == subjectFilter).toList();
      }

      if (sortBy == 'date_asc') {
        list.sort((a, b) => a.createdDate.compareTo(b.createdDate));
      } else if (sortBy == 'date_desc') {
        list.sort((a, b) => b.createdDate.compareTo(a.createdDate));
      } else if (sortBy == 'title_asc') {
        list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      }

      return list;
    }
  }

  /// READ: Single note by ID
  Future<StudentNote?> getNoteById(int id) async {
    final db = await database;
    if (db != null) {
      final maps = await db.query(
        tableNotes,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return StudentNote.fromMap(maps.first);
      }
      return null;
    } else {
      _initSampleMemoryData();
      try {
        return _memoryNotes.firstWhere((n) => n.id == id);
      } catch (_) {
        return null;
      }
    }
  }

  /// UPDATE: Modify an existing note
  Future<int> updateNote(StudentNote note) async {
    final db = await database;
    if (db != null) {
      return await db.update(
        tableNotes,
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );
    } else {
      _initSampleMemoryData();
      final idx = _memoryNotes.indexWhere((n) => n.id == note.id);
      if (idx != -1) {
        _memoryNotes[idx] = note;
        return 1;
      }
      return 0;
    }
  }

  /// DELETE: Remove note by ID
  Future<int> deleteNote(int id) async {
    final db = await database;
    if (db != null) {
      return await db.delete(
        tableNotes,
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {
      _initSampleMemoryData();
      final beforeLen = _memoryNotes.length;
      _memoryNotes.removeWhere((n) => n.id == id);
      return beforeLen - _memoryNotes.length;
    }
  }

  /// DELETE ALL: Clear all notes
  Future<int> deleteAllNotes() async {
    final db = await database;
    if (db != null) {
      return await db.delete(tableNotes);
    } else {
      _initSampleMemoryData();
      final count = _memoryNotes.length;
      _memoryNotes.clear();
      return count;
    }
  }

  // ============================================================================
  // CRUD OPERATIONS: Task Manager
  // ============================================================================

  /// CREATE: Insert a new task
  Future<int> insertTask(TaskManager task) async {
    final db = await database;
    if (db != null) {
      return await db.insert(tableTasks, task.toMap());
    } else {
      _initSampleMemoryData();
      final newTask = task.copyWith(id: _nextTaskId++);
      _memoryTasks.insert(0, newTask);
      return newTask.id!;
    }
  }

  /// READ: Get all tasks with optional search, priority, status filter, and sorting
  Future<List<TaskManager>> getAllTasks({
    String? searchQuery,
    String? priorityFilter, // 'High', 'Medium', 'Low', 'All Priorities'
    String? statusFilter, // 'Pending', 'Completed', 'All'
    String? sortBy, // 'date_asc', 'date_desc', 'priority'
  }) async {
    final db = await database;
    if (db != null) {
      List<String> whereClauses = [];
      List<dynamic> whereArgs = [];

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        whereClauses.add('(task_name LIKE ? OR category LIKE ?)');
        final q = '%${searchQuery.trim()}%';
        whereArgs.addAll([q, q]);
      }

      if (priorityFilter != null && priorityFilter.isNotEmpty && priorityFilter != 'All Priorities') {
        whereClauses.add('priority = ?');
        whereArgs.add(priorityFilter);
      }

      if (statusFilter != null && statusFilter.isNotEmpty && statusFilter != 'All') {
        whereClauses.add('status = ?');
        whereArgs.add(statusFilter);
      }

      String orderBy = 'id DESC';
      if (sortBy == 'date_asc') {
        orderBy = 'due_date ASC, id ASC';
      } else if (sortBy == 'date_desc') {
        orderBy = 'due_date DESC, id DESC';
      } else if (sortBy == 'priority') {
        orderBy = "CASE priority WHEN 'High' THEN 1 WHEN 'Medium' THEN 2 WHEN 'Low' THEN 3 ELSE 4 END ASC, due_date ASC";
      }

      final maps = await db.query(
        tableTasks,
        where: whereClauses.isEmpty ? null : whereClauses.join(' AND '),
        whereArgs: whereArgs.isEmpty ? null : whereArgs,
        orderBy: orderBy,
      );

      return maps.map((m) => TaskManager.fromMap(m)).toList();
    } else {
      _initSampleMemoryData();
      var list = List<TaskManager>.from(_memoryTasks);

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        list = list.where((t) =>
            t.taskName.toLowerCase().contains(q) ||
            t.category.toLowerCase().contains(q)).toList();
      }

      if (priorityFilter != null && priorityFilter.isNotEmpty && priorityFilter != 'All Priorities') {
        list = list.where((t) => t.priority == priorityFilter).toList();
      }

      if (statusFilter != null && statusFilter.isNotEmpty && statusFilter != 'All') {
        list = list.where((t) => t.status == statusFilter).toList();
      }

      if (sortBy == 'date_asc') {
        list.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      } else if (sortBy == 'date_desc') {
        list.sort((a, b) => b.dueDate.compareTo(a.dueDate));
      } else if (sortBy == 'priority') {
        int prioWeight(String p) => p == 'High' ? 1 : (p == 'Medium' ? 2 : 3);
        list.sort((a, b) {
          final cmp = prioWeight(a.priority).compareTo(prioWeight(b.priority));
          if (cmp != 0) return cmp;
          return a.dueDate.compareTo(b.dueDate);
        });
      }

      return list;
    }
  }

  /// READ: Single task by ID
  Future<TaskManager?> getTaskById(int id) async {
    final db = await database;
    if (db != null) {
      final maps = await db.query(
        tableTasks,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return TaskManager.fromMap(maps.first);
      }
      return null;
    } else {
      _initSampleMemoryData();
      try {
        return _memoryTasks.firstWhere((t) => t.id == id);
      } catch (_) {
        return null;
      }
    }
  }

  /// UPDATE: Modify an existing task
  Future<int> updateTask(TaskManager task) async {
    final db = await database;
    if (db != null) {
      return await db.update(
        tableTasks,
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    } else {
      _initSampleMemoryData();
      final idx = _memoryTasks.indexWhere((t) => t.id == task.id);
      if (idx != -1) {
        _memoryTasks[idx] = task;
        return 1;
      }
      return 0;
    }
  }

  /// UPDATE: Toggle task status between 'Pending' and 'Completed'
  Future<int> toggleTaskStatus(int id, String currentStatus) async {
    final newStatus = currentStatus == 'Completed' ? 'Pending' : 'Completed';
    final db = await database;
    if (db != null) {
      return await db.update(
        tableTasks,
        {'status': newStatus},
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {
      _initSampleMemoryData();
      final idx = _memoryTasks.indexWhere((t) => t.id == id);
      if (idx != -1) {
        _memoryTasks[idx] = _memoryTasks[idx].copyWith(status: newStatus);
        return 1;
      }
      return 0;
    }
  }

  /// DELETE: Remove task by ID
  Future<int> deleteTask(int id) async {
    final db = await database;
    if (db != null) {
      return await db.delete(
        tableTasks,
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {
      _initSampleMemoryData();
      final beforeLen = _memoryTasks.length;
      _memoryTasks.removeWhere((t) => t.id == id);
      return beforeLen - _memoryTasks.length;
    }
  }

  /// DELETE ALL: Clear all tasks
  Future<int> deleteAllTasks() async {
    final db = await database;
    if (db != null) {
      return await db.delete(tableTasks);
    } else {
      _initSampleMemoryData();
      final count = _memoryTasks.length;
      _memoryTasks.clear();
      return count;
    }
  }

  // ============================================================================
  // DATABASE ANALYTICS & MAINTENANCE
  // ============================================================================

  /// Retrieve summary analytics for dashboard & viva presentation
  Future<Map<String, dynamic>> getDatabaseStatistics() async {
    final notes = await getAllNotes();
    final tasks = await getAllTasks();

    final pendingCount = tasks.where((t) => t.status == 'Pending').length;
    final completedCount = tasks.where((t) => t.status == 'Completed').length;
    final highPriorityCount = tasks.where((t) => t.priority == 'High').length;

    return {
      'totalNotes': notes.length,
      'totalTasks': tasks.length,
      'pendingTasks': pendingCount,
      'completedTasks': completedCount,
      'highPriorityTasks': highPriorityCount,
      'dbName': dbName,
      'dbVersion': dbVersion,
      'engine': (kIsWeb || _useInMemory) ? 'In-Memory Cache (Web/Preview)' : 'Native SQLite Engine (sqflite)',
    };
  }

  /// Reset all data back to university syllabus standard sample records
  Future<void> resetToSampleData() async {
    final db = await database;
    if (db != null) {
      await db.delete(tableNotes);
      await db.delete(tableTasks);
      await _seedDatabase(db);
    } else {
      _memoryNotes.clear();
      _memoryTasks.clear();
      _nextNoteId = 1;
      _nextTaskId = 1;
      _initSampleMemoryData();
    }
  }
}
