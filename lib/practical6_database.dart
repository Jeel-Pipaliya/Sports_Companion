// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development (Semester 5)
// PRACTICAL 6: Develop Student Notes and Task Management Module using SQLite Database
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';
import 'database_helper.dart';

class Practical6DatabaseHubScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final int initialTabIndex;

  const Practical6DatabaseHubScreen({
    super.key,
    required this.onToggleTheme,
    this.initialTabIndex = 0,
  });

  @override
  State<Practical6DatabaseHubScreen> createState() =>
      _Practical6DatabaseHubScreenState();
}

class _Practical6DatabaseHubScreenState
    extends State<Practical6DatabaseHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Notes state filters
  String _notesSearch = '';
  String _notesSubjectFilter = 'All Subjects';
  String _notesSort = 'date_desc';
  final TextEditingController _notesSearchController = TextEditingController();

  // Tasks state filters
  String _tasksSearch = '';
  String _tasksPriorityFilter = 'All Priorities';
  String _tasksStatusFilter = 'All';
  String _tasksSort = 'date_asc';
  final TextEditingController _tasksSearchController = TextEditingController();

  // Subject list
  final List<String> _subjects = [
    'All Subjects',
    'Mobile Application Development',
    'Database Management Systems',
    'Artificial Intelligence & ML',
    'Computer Networks',
    'Sports & Athletics',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notesSearchController.dispose();
    _tasksSearchController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  // ============================================================================
  // DIALOGS: NOTES (Add / Edit)
  // ============================================================================
  void _showNoteDialog({StudentNote? note}) {
    final isEditing = note != null;
    final titleController = TextEditingController(text: note?.title ?? '');
    final descController = TextEditingController(text: note?.description ?? '');
    String selectedSubject = note != null && _subjects.contains(note.subject)
        ? note.subject
        : 'Mobile Application Development';
    int colorTag = note?.colorTag ?? 0;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF131D2E) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit_note_rounded : Icons.post_add_rounded,
                    color: const Color(0xFF0D47A1),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isEditing ? 'Edit Student Note' : 'Add New Student Note',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: selectedSubject,
                        decoration: const InputDecoration(
                          labelText: 'Subject',
                          prefixIcon: Icon(Icons.school_rounded),
                        ),
                        items: _subjects
                            .where((s) => s != 'All Subjects')
                            .map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => selectedSubject = val);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Note Title *',
                          hintText: 'e.g. Flutter Widgets',
                          prefixIcon: Icon(Icons.title_rounded),
                        ),
                        validator: (val) =>
                            val == null || val.trim().isEmpty ? 'Please enter note title' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descController,
                        decoration: const InputDecoration(
                          labelText: 'Description / Summary',
                          hintText: 'Study Stateless & Stateful Widgets...',
                          prefixIcon: Icon(Icons.description_rounded),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Color Tag: ', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          ...List.generate(4, (index) {
                            final colors = [
                              const Color(0xFF0D47A1),
                              const Color(0xFF10B981),
                              const Color(0xFF8B5CF6),
                              const Color(0xFFF59E0B),
                            ];
                            return GestureDetector(
                              onTap: () => setDialogState(() => colorTag = index),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: colors[index],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: colorTag == index ? Colors.white : Colors.transparent,
                                    width: 2,
                                  ),
                                  boxShadow: colorTag == index
                                      ? [BoxShadow(color: colors[index].withValues(alpha: 0.5), blurRadius: 4)]
                                      : null,
                                ),
                                child: colorTag == index
                                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                                    : null,
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final now = DateTime.now();
                      final dateStr =
                          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
                      Navigator.pop(dialogCtx);

                      if (isEditing) {
                        final updated = note.copyWith(
                          title: titleController.text.trim(),
                          description: descController.text.trim(),
                          subject: selectedSubject,
                          colorTag: colorTag,
                        );
                        await _dbHelper.updateNote(updated);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Note updated in SQLite database successfully!'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      } else {
                        final newNote = StudentNote(
                          title: titleController.text.trim(),
                          description: descController.text.trim(),
                          subject: selectedSubject,
                          createdDate: dateStr,
                          colorTag: colorTag,
                        );
                        await _dbHelper.insertNote(newNote);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('New note inserted into SQLite successfully!'),
                            backgroundColor: Color(0xFF0D47A1),
                          ),
                        );
                      }
                      _refresh();
                    }
                  },
                  child: Text(isEditing ? 'Save Changes' : 'Insert Note'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================================
  // DIALOGS: TASKS (Add / Edit)
  // ============================================================================
  void _showTaskDialog({TaskManager? task}) {
    final isEditing = task != null;
    final nameController = TextEditingController(text: task?.taskName ?? '');
    String priority = task?.priority ?? 'Medium';
    String category = task?.category ?? 'Academic';
    String status = task?.status ?? 'Pending';
    String dueDate = task?.dueDate ??
        '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${(DateTime.now().day + 2).toString().padLeft(2, '0')}';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF131D2E) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit_calendar_rounded : Icons.add_task_rounded,
                    color: const Color(0xFF0D47A1),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isEditing ? 'Edit Task Record' : 'Create Task Record',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Task Name *',
                          hintText: 'e.g. Submit Flutter Assignment',
                          prefixIcon: Icon(Icons.assignment_turned_in_rounded),
                        ),
                        validator: (val) =>
                            val == null || val.trim().isEmpty ? 'Please enter task name' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: priority,
                              decoration: const InputDecoration(
                                labelText: 'Priority',
                                prefixIcon: Icon(Icons.flag_rounded),
                              ),
                              items: ['High', 'Medium', 'Low']
                                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setDialogState(() => priority = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: category,
                              decoration: const InputDecoration(
                                labelText: 'Category',
                                prefixIcon: Icon(Icons.category_rounded),
                              ),
                              items: ['Academic', 'Assignment', 'Exam', 'Placement', 'Sports']
                                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setDialogState(() => category = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: status,
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                prefixIcon: Icon(Icons.check_circle_outline_rounded),
                              ),
                              items: ['Pending', 'Completed']
                                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setDialogState(() => status = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_month_rounded, color: Color(0xFF0D47A1)),
                        title: const Text('Due Date', style: TextStyle(fontSize: 13, color: Colors.grey)),
                        subtitle: Text(dueDate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        trailing: OutlinedButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: dialogCtx,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2025),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setDialogState(() {
                                dueDate =
                                    '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                              });
                            }
                          },
                          child: const Text('Pick Date'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(dialogCtx);
                      if (isEditing) {
                        final updated = task.copyWith(
                          taskName: nameController.text.trim(),
                          priority: priority,
                          category: category,
                          status: status,
                          dueDate: dueDate,
                        );
                        await _dbHelper.updateTask(updated);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Task updated in SQLite database!'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      } else {
                        final newTask = TaskManager(
                          taskName: nameController.text.trim(),
                          dueDate: dueDate,
                          priority: priority,
                          status: status,
                          category: category,
                        );
                        await _dbHelper.insertTask(newTask);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Task inserted into SQLite database!'),
                            backgroundColor: Color(0xFF0D47A1),
                          ),
                        );
                      }
                      _refresh();
                    }
                  },
                  child: Text(isEditing ? 'Save Changes' : 'Insert Task'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================================
  // CONFIRMATION DIALOG: DELETE
  // ============================================================================
  void _confirmDelete({
    required String title,
    required String message,
    required Future<void> Function() onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(message),
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
                Navigator.pop(ctx);
                await onConfirm();
                _refresh();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================================
  // BUILD METHOD
  // ============================================================================
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Practical 6: SQLite Database',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Text(
              'Student Notes & Task Management (CRUD)',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (val) async {
              if (val == 'reset') {
                await _dbHelper.resetToSampleData();
                _refresh();
                if (!mounted) return;
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text('Database reset to University Syllabus sample records!'),
                    backgroundColor: Color(0xFF0D47A1),
                  ),
                );
              } else if (val == 'clear_notes') {
                _confirmDelete(
                  title: 'Clear All Notes',
                  message: 'Are you sure you want to delete all notes from SQLite?',
                  onConfirm: () async => await _dbHelper.deleteAllNotes(),
                );
              } else if (val == 'clear_tasks') {
                _confirmDelete(
                  title: 'Clear All Tasks',
                  message: 'Are you sure you want to delete all tasks from SQLite?',
                  onConfirm: () async => await _dbHelper.deleteAllTasks(),
                );
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restore_rounded, color: Color(0xFF0D47A1), size: 18),
                    SizedBox(width: 8),
                    Text('Reset to Sample Data'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_notes',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep_rounded, color: Colors.redAccent, size: 18),
                    SizedBox(width: 8),
                    Text('Delete All Notes'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_tasks',
                child: Row(
                  children: [
                    Icon(Icons.playlist_remove_rounded, color: Colors.redAccent, size: 18),
                    SizedBox(width: 8),
                    Text('Delete All Tasks'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: isDark ? const Color(0xFF00E676) : const Color(0xFF0D47A1),
          unselectedLabelColor: Colors.grey,
          indicatorColor: isDark ? const Color(0xFF00E676) : const Color(0xFF0D47A1),
          tabs: const [
            Tab(icon: Icon(Icons.note_alt_rounded), text: 'Student Notes'),
            Tab(icon: Icon(Icons.task_alt_rounded), text: 'Task Manager'),
            Tab(icon: Icon(Icons.storage_rounded), text: 'SQLite Stats'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotesTab(isDark),
          _buildTasksTab(isDark),
          _buildStatsTab(isDark),
        ],
      ),
      floatingActionButton: _tabController.index == 2
          ? null
          : FloatingActionButton.extended(
              backgroundColor: const Color(0xFF0D47A1),
              foregroundColor: Colors.white,
              onPressed: () {
                if (_tabController.index == 0) {
                  _showNoteDialog();
                } else {
                  _showTaskDialog();
                }
              },
              icon: Icon(_tabController.index == 0 ? Icons.note_add_rounded : Icons.add_task_rounded),
              label: Text(_tabController.index == 0 ? 'Add Note' : 'Add Task'),
            ),
    );
  }

  // ============================================================================
  // TAB 1: STUDENT NOTES
  // ============================================================================
  Widget _buildNotesTab(bool isDark) {
    return Column(
      children: [
        // Search and filter container
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: isDark ? const Color(0xFF131D2E) : Colors.white,
          child: Column(
            children: [
              // Search field
              TextField(
                controller: _notesSearchController,
                decoration: InputDecoration(
                  hintText: 'Search notes by title, subject or content...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _notesSearch.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _notesSearchController.clear();
                            setState(() => _notesSearch = '');
                          },
                        )
                      : null,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (val) => setState(() => _notesSearch = val),
              ),
              const SizedBox(height: 8),
              // Subject filter chip row & Sort button
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _subjects.map((sub) {
                          final isSelected = _notesSubjectFilter == sub;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: FilterChip(
                              label: Text(
                                sub,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: const Color(0xFF0D47A1),
                              checkmarkColor: Colors.white,
                              onSelected: (selected) {
                                setState(() {
                                  _notesSubjectFilter = selected ? sub : 'All Subjects';
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'Sort Notes',
                    icon: const Icon(Icons.sort_rounded, size: 20),
                    onSelected: (val) => setState(() => _notesSort = val),
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(value: 'date_desc', child: Text('Newest First')),
                      const PopupMenuItem(value: 'date_asc', child: Text('Oldest First')),
                      const PopupMenuItem(value: 'title_asc', child: Text('Title (A-Z)')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Asynchronous SQLite List rendering with FutureBuilder
        Expanded(
          child: FutureBuilder<List<StudentNote>>(
            future: _dbHelper.getAllNotes(
              searchQuery: _notesSearch,
              subjectFilter: _notesSubjectFilter,
              sortBy: _notesSort,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading notes: ${snapshot.error}'),
                );
              }
              final notes = snapshot.data ?? [];
              if (notes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notes_rounded, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      const Text(
                        'No student notes found in SQLite.',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap "Add Note" below or reset to sample records.',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.restore_rounded),
                        label: const Text('Seed Sample Notes'),
                        onPressed: () async {
                          await _dbHelper.resetToSampleData();
                          _refresh();
                        },
                      ),
                    ],
                  ),
                );
              }

              final colors = [
                const Color(0xFF0D47A1),
                const Color(0xFF10B981),
                const Color(0xFF8B5CF6),
                const Color(0xFFF59E0B),
              ];

              return RefreshIndicator(
                onRefresh: () async => _refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: notes.length,
                  itemBuilder: (ctx, idx) {
                    final note = notes[idx];
                    final color = colors[note.colorTag % colors.length];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isDark ? const Color(0xFF1F2C42) : Colors.grey.shade300,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _showNoteDialog(note: note),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: color.withValues(alpha: 0.4)),
                                    ),
                                    child: Text(
                                      note.subject,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    note.createdDate,
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded, size: 18),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    color: const Color(0xFF0D47A1),
                                    onPressed: () => _showNoteDialog(note: note),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    color: Colors.redAccent,
                                    onPressed: () {
                                      _confirmDelete(
                                        title: 'Delete Note',
                                        message: 'Delete note "${note.title}" from SQLite?',
                                        onConfirm: () async => await _dbHelper.deleteNote(note.id!),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                note.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                note.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // TAB 2: TASK MANAGER
  // ============================================================================
  Widget _buildTasksTab(bool isDark) {
    return Column(
      children: [
        // Search and Priority filter
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: isDark ? const Color(0xFF131D2E) : Colors.white,
          child: Column(
            children: [
              TextField(
                controller: _tasksSearchController,
                decoration: InputDecoration(
                  hintText: 'Search tasks by name or category...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _tasksSearch.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _tasksSearchController.clear();
                            setState(() => _tasksSearch = '');
                          },
                        )
                      : null,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (val) => setState(() => _tasksSearch = val),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  // Status toggle chips
                  ...['All', 'Pending', 'Completed'].map((st) {
                    final isSel = _tasksStatusFilter == st;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(st, style: TextStyle(fontSize: 12, color: isSel ? Colors.white : null)),
                        selected: isSel,
                        selectedColor: const Color(0xFF0D47A1),
                        onSelected: (selected) {
                          if (selected) setState(() => _tasksStatusFilter = st);
                        },
                      ),
                    );
                  }),
                  const Spacer(),
                  // Priority dropdown
                  DropdownButton<String>(
                    value: _tasksPriorityFilter,
                    underline: const SizedBox(),
                    items: ['All Priorities', 'High', 'Medium', 'Low']
                        .map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 12))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _tasksPriorityFilter = val);
                    },
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'Sort Tasks',
                    icon: const Icon(Icons.sort_rounded, size: 20),
                    onSelected: (val) => setState(() => _tasksSort = val),
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(value: 'date_asc', child: Text('Due Date (Earliest)')),
                      const PopupMenuItem(value: 'date_desc', child: Text('Due Date (Latest)')),
                      const PopupMenuItem(value: 'priority', child: Text('Priority (High First)')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // FutureBuilder for Task List
        Expanded(
          child: FutureBuilder<List<TaskManager>>(
            future: _dbHelper.getAllTasks(
              searchQuery: _tasksSearch,
              priorityFilter: _tasksPriorityFilter,
              statusFilter: _tasksStatusFilter,
              sortBy: _tasksSort,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading tasks: ${snapshot.error}'),
                );
              }
              final tasks = snapshot.data ?? [];
              if (tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_turned_in_rounded, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      const Text(
                        'No tasks match your filters.',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap "Add Task" below to schedule a new task.',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => _refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: tasks.length,
                  itemBuilder: (ctx, idx) {
                    final task = tasks[idx];
                    final isDone = task.status == 'Completed';

                    Color prioColor;
                    if (task.priority == 'High') {
                      prioColor = Colors.redAccent;
                    } else if (task.priority == 'Medium') {
                      prioColor = Colors.orangeAccent;
                    } else {
                      prioColor = Colors.teal;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isDark ? const Color(0xFF1F2C42) : Colors.grey.shade300,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _showTaskDialog(task: task),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              // Checkbox to toggle status
                              Checkbox(
                                value: isDone,
                                activeColor: const Color(0xFF10B981),
                                onChanged: (val) async {
                                  await _dbHelper.toggleTaskStatus(task.id!, task.status);
                                  _refresh();
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // Priority badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: prioColor.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: prioColor.withValues(alpha: 0.5)),
                                          ),
                                          child: Text(
                                            task.priority,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: prioColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        // Category badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            task.category,
                                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const Spacer(),
                                        Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey.shade500),
                                        const SizedBox(width: 4),
                                        Text(
                                          task.dueDate,
                                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      task.taskName,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        decoration: isDone ? TextDecoration.lineThrough : null,
                                        color: isDone
                                            ? Colors.grey
                                            : (isDark ? Colors.white : Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_rounded, size: 18),
                                color: const Color(0xFF0D47A1),
                                onPressed: () => _showTaskDialog(task: task),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                color: Colors.redAccent,
                                onPressed: () {
                                  _confirmDelete(
                                    title: 'Delete Task',
                                    message: 'Delete task "${task.taskName}" from SQLite?',
                                    onConfirm: () async => await _dbHelper.deleteTask(task.id!),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // TAB 3: SQLITE INSPECTOR & STATS
  // ============================================================================
  Widget _buildStatsTab(bool isDark) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dbHelper.getDatabaseStatistics(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final stats = snapshot.data!;
        final totalTasks = stats['totalTasks'] as int;
        final completedTasks = stats['completedTasks'] as int;
        final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF1E88E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D47A1).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.dns_rounded, color: Colors.white, size: 28),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SQLite Engine Active',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              'DB: ${stats['dbName']} (v${stats['dbVersion']})',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Architecture: ${stats['engine']}',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // KPI Metric Cards
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Total Notes',
                      value: '${stats['totalNotes']}',
                      icon: Icons.note_alt_rounded,
                      color: const Color(0xFF0D47A1),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Total Tasks',
                      value: '${stats['totalTasks']}',
                      icon: Icons.assignment_rounded,
                      color: const Color(0xFF10B981),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Pending Tasks',
                      value: '${stats['pendingTasks']}',
                      icon: Icons.hourglass_top_rounded,
                      color: Colors.orangeAccent,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'High Priority',
                      value: '${stats['highPriorityTasks']}',
                      icon: Icons.priority_high_rounded,
                      color: Colors.redAccent,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Completion Progress
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Task Completion Progress', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('${(progress * 100).toInt()}%',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          backgroundColor: isDark ? const Color(0xFF1F2C42) : Colors.grey.shade200,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$completedTasks of $totalTasks tasks completed',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Database Schema Viewer
              const Text(
                'Database Schema & SQL DDL',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _buildSqlSnippetCard(
                title: 'Table: student_notes',
                sql: '''CREATE TABLE student_notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT,
  subject TEXT NOT NULL,
  created_date TEXT NOT NULL,
  color_tag INTEGER DEFAULT 0
);''',
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildSqlSnippetCard(
                title: 'Table: task_manager',
                sql: '''CREATE TABLE task_manager (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  task_name TEXT NOT NULL,
  due_date TEXT NOT NULL,
  priority TEXT NOT NULL,
  status TEXT NOT NULL,
  category TEXT DEFAULT 'Academic'
);''',
                isDark: isDark,
              ),
              const SizedBox(height: 20),

              // Action Buttons
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: const Icon(Icons.restore_rounded),
                  label: const Text('Reset All to Syllabus Sample Data'),
                  onPressed: () async {
                    await _dbHelper.resetToSampleData();
                    _refresh();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('SQLite database reset successfully to Syllabus data!'),
                        backgroundColor: Color(0xFF0D47A1),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Icon(icon, size: 18, color: color),
                ),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: color),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildSqlSnippetCard({
    required String title,
    required String sql,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF38BDF8),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            sql,
            style: const TextStyle(
              color: Color(0xFFE2E8F0),
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
