// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development
// WORK/MODULE: Assignment & Project Deliverables Tracking
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';

class AssignmentsScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const AssignmentsScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment & Project List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: AssignmentListModule(onToggleTheme: onToggleTheme),
    );
  }
}

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
