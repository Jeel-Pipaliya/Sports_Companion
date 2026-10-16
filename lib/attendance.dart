// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development
// WORK/MODULE: Attendance Summary & Safe-Zone Tracking
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const AttendanceScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: AttendanceSummaryModule(onToggleTheme: onToggleTheme),
    );
  }
}

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

    double overall = subjectAttendance.map((e) => e['percentage'] as int).reduce((a, b) => a + b) / subjectAttendance.length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Top Overall Gauge Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  height: 90,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: overall / 100,
                        strokeWidth: 9,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      Center(
                        child: Text(
                          '${overall.toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cumulative Attendance',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Total 229 / 250 Sessions Attended',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '✓ Status: Safe Zone (Req. >= 85%)',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Section Title
        const Text(
          'Subject-wise Breakdown (Syllabus CO2)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Subject Breakdown Cards
        ...subjectAttendance.map((item) {
          final Color col = item['color'] as Color;
          final double val = (item['percentage'] as int) / 100.0;

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
