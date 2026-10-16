// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development
// WORK/MODULE: Course & Sports Dashboard Module
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const DashboardScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course & Sports Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Practical 4: State Management',
            onPressed: () => Navigator.pushNamed(context, '/practical4'),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: CourseDashboardModule(onToggleTheme: onToggleTheme),
    );
  }
}

class CourseDashboardModule extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const CourseDashboardModule({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 720;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Student Profile Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFF0D47A1),
                      child: Text(
                        'JP',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jeel Pipaliya',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '24AIML051 • Semester V',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Dept. of AI & ML • FTE CHARUSAT',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: Colors.blue.shade700, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            '91.25%',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 13),
                          ),
                          Text(
                            'Overall Att.',
                            style: TextStyle(fontSize: 9, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Performance KPI Flex Row (Row with Expanded widgets)
            Row(
              children: [
                Expanded(
                  child: _kpiCard(
                    context,
                    '9.42',
                    'CGPA Standing',
                    Icons.school_rounded,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _kpiCard(
                    context,
                    '4 / 5',
                    'Tasks Completed',
                    Icons.task_alt_rounded,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _kpiCard(
                    context,
                    '94%',
                    'Varsity Fitness',
                    Icons.fitness_center_rounded,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section Header: Enrolled Academic Courses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Academic Courses (Semester V)',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '4 Active Subjects',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Responsive Grid of Course Modules (GridView.count with dynamic crossAxisCount)
            GridView.count(
              crossAxisCount: isWide ? 4 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isWide ? 1.4 : 1.25,
              children: [
                _courseCard(context, 'DBMS', 'Database Systems', '92% Att.', Colors.indigo, Icons.storage_rounded),
                _courseCard(context, 'MAD', 'Mobile App Dev', '88% Att.', Colors.blue, Icons.phone_android_rounded),
                _courseCard(context, 'AI', 'Artificial Intelligence', '95% Att.', Colors.teal, Icons.psychology_rounded),
                _courseCard(context, 'CN', 'Computer Networks', '90% Att.', Colors.deepOrange, Icons.lan_rounded),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Actions Horizontal Scroll (SingleChildScrollView with Row)
            const Text(
              'Quick Action Shortcuts',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _actionChip(context, 'View Attendance', Icons.pie_chart, Colors.green, onTap: () => Navigator.pushNamed(context, '/attendance')),
                  _actionChip(context, 'Class Timetable', Icons.calendar_month, Colors.blue, onTap: () => Navigator.pushNamed(context, '/timetable')),
                  _actionChip(context, 'Submit Assignment', Icons.cloud_upload_outlined, Colors.amber.shade800, onTap: () => Navigator.pushNamed(context, '/assignments')),
                  _actionChip(context, 'Event Gallery', Icons.photo_library_outlined, Colors.purple, onTap: () => Navigator.pushNamed(context, '/gallery')),
                  _actionChip(context, 'Faculty Cabins', Icons.meeting_room_outlined, Colors.teal, onTap: () => Navigator.pushNamed(context, '/faculty')),
                  _actionChip(context, 'Practical 4 (State Mgmt)', Icons.tune_rounded, const Color(0xFF0D47A1), onTap: () => Navigator.pushNamed(context, '/practical4')),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _kpiCard(BuildContext context, String val, String title, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              val,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _courseCard(BuildContext context, String code, String name, String att, Color color, IconData icon) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(context, '/attendance'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      att,
                      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    code,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionChip(BuildContext context, String label, IconData icon, Color color, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ActionChip(
        avatar: Icon(icon, color: color, size: 18),
        label: Text(label),
        onPressed: onTap ?? () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Triggered shortcut: $label')),
          );
        },
      ),
    );
  }
}
