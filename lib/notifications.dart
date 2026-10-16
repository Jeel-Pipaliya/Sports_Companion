// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development
// WORK/MODULE: Notifications & Alerts Module
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const NotificationsScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications & Alerts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: NotificationsModule(onToggleTheme: onToggleTheme),
    );
  }
}

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
