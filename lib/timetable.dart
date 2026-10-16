// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development
// WORK/MODULE: Academic & Athletic Timetable Management
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';

class TimetableScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const TimetableScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic & Drill Timetable', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: TimetableModule(onToggleTheme: onToggleTheme),
    );
  }
}

class TimetableModule extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const TimetableModule({super.key, required this.onToggleTheme});

  @override
  State<TimetableModule> createState() => _TimetableModuleState();
}

class _TimetableModuleState extends State<TimetableModule> {
  String _selectedDay = 'Monday';

  final List<String> _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

  final Map<String, List<Map<String, String>>> _schedules = {
    'Monday': [
      {'time': '09:00 - 10:00 AM', 'sub': 'DBMS Theory', 'room': 'Room 204 FTE', 'fac': 'Prof. Amit Shah', 'type': 'Theory'},
      {'time': '10:00 - 11:00 AM', 'sub': 'MAD Theory', 'room': 'Room 204 FTE', 'fac': 'Prof. Parth Patel', 'type': 'Theory'},
      {'time': '11:15 - 01:15 PM', 'sub': 'MAD Practical Lab (P3)', 'room': 'Lab 102 (AI Lab)', 'fac': 'Prof. Parth Patel', 'type': 'Lab'},
      {'time': '02:00 - 03:00 PM', 'sub': 'AI Theory', 'room': 'Room 204 FTE', 'fac': 'Dr. Sneha Sharma', 'type': 'Theory'},
      {'time': '04:30 - 06:00 PM', 'sub': 'Athletic Training & Drills', 'room': 'Sports Arena', 'fac': 'Coach Vikram Singh', 'type': 'Sports'},
    ],
    'Tuesday': [
      {'time': '09:00 - 11:00 AM', 'sub': 'AI Practical Lab', 'room': 'Lab 104', 'fac': 'Dr. Sneha Sharma', 'type': 'Lab'},
      {'time': '11:15 - 12:15 PM', 'sub': 'Computer Networks', 'room': 'Room 204 FTE', 'fac': 'Dr. Ritu Desai', 'type': 'Theory'},
      {'time': '01:00 - 02:00 PM', 'sub': 'DBMS Theory', 'room': 'Room 204 FTE', 'fac': 'Prof. Amit Shah', 'type': 'Theory'},
      {'time': '04:30 - 06:00 PM', 'sub': 'Football Squad Practice', 'room': 'Football Turf Ground', 'fac': 'Coach Vikram Singh', 'type': 'Sports'},
    ],
    'Wednesday': [
      {'time': '09:00 - 10:00 AM', 'sub': 'MAD Theory', 'room': 'Room 204 FTE', 'fac': 'Prof. Parth Patel', 'type': 'Theory'},
      {'time': '10:00 - 11:00 AM', 'sub': 'CN Theory', 'room': 'Room 204 FTE', 'fac': 'Dr. Ritu Desai', 'type': 'Theory'},
      {'time': '11:15 - 01:15 PM', 'sub': 'DBMS Lab Practical', 'room': 'Database Lab 201', 'fac': 'Prof. Amit Shah', 'type': 'Lab'},
      {'time': '02:00 - 03:00 PM', 'sub': 'AI Machine Learning', 'room': 'Room 204 FTE', 'fac': 'Dr. Sneha Sharma', 'type': 'Theory'},
    ],
    'Thursday': [
      {'time': '09:00 - 10:00 AM', 'sub': 'Computer Networks', 'room': 'Room 204 FTE', 'fac': 'Dr. Ritu Desai', 'type': 'Theory'},
      {'time': '10:00 - 12:00 PM', 'sub': 'CN Practical Lab', 'room': 'Networks Lab 105', 'fac': 'Dr. Ritu Desai', 'type': 'Lab'},
      {'time': '01:00 - 02:00 PM', 'sub': 'MAD Code Review', 'room': 'Room 204 FTE', 'fac': 'Prof. Parth Patel', 'type': 'Theory'},
      {'time': '04:30 - 06:00 PM', 'sub': 'Strength & Conditioning', 'room': 'University Gymnasium', 'fac': 'Coach Vikram Singh', 'type': 'Sports'},
    ],
    'Friday': [
      {'time': '09:00 - 11:00 AM', 'sub': 'Flutter Layout Workshop', 'room': 'Lab 102 (AI Lab)', 'fac': 'Prof. Parth Patel', 'type': 'Workshop'},
      {'time': '11:15 - 12:15 PM', 'sub': 'DBMS Query Optimization', 'room': 'Room 204 FTE', 'fac': 'Prof. Amit Shah', 'type': 'Theory'},
      {'time': '01:00 - 02:00 PM', 'sub': 'AI Project Mentoring', 'room': 'FTE Faculty Cabin', 'fac': 'Dr. Sneha Sharma', 'type': 'Mentoring'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final currentList = _schedules[_selectedDay] ?? [];

    return Column(
      children: [
        // Day Picker Row (SingleChildScrollView with Row)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _days.map((day) {
                final bool isSelected = _selectedDay == day;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(day),
                    onSelected: (val) {
                      setState(() => _selectedDay = day);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const Divider(height: 1),

        // Schedule ListView
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: currentList.length,
            itemBuilder: (context, idx) {
              final slot = currentList[idx];
              final isLab = slot['type'] == 'Lab' || slot['type'] == 'Workshop';
              final isSports = slot['type'] == 'Sports';

              Color badgeCol = Colors.blue;
              if (isLab) badgeCol = Colors.purple;
              if (isSports) badgeCol = Colors.green;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Time Slot Box
                      Container(
                        width: 90,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: badgeCol.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: badgeCol.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.access_time_rounded, size: 18, color: badgeCol),
                            const SizedBox(height: 4),
                            Text(
                              slot['time']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: badgeCol,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Session Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    slot['sub']!,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: badgeCol.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    slot['type']!,
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeCol),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.room_outlined, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    slot['room']!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    slot['fac']!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
