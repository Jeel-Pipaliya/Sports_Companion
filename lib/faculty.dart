// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development
// WORK/MODULE: Faculty Information & Consultation Directory
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';

class FacultyScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const FacultyScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: FacultyInformationModule(onToggleTheme: onToggleTheme),
    );
  }
}

class FacultyInformationModule extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const FacultyInformationModule({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faculties = [
      {
        'name': 'Prof. Parth Patel',
        'designation': 'Assistant Professor',
        'dept': 'Mobile Application Development (MAD)',
        'cabin': 'Cabin 204, 2nd Floor FTE',
        'email': 'parthpatel.it@charusat.ac.in',
        'hours': '3:00 PM - 5:00 PM',
      },
      {
        'name': 'Dr. Sneha Sharma',
        'designation': 'Associate Professor & AI Lead',
        'dept': 'Artificial Intelligence & Machine Learning',
        'cabin': 'Cabin 102 (AI Lab Wing)',
        'email': 'snehasharma.ai@charusat.ac.in',
        'hours': '11:00 AM - 1:00 PM',
      },
      {
        'name': 'Prof. Amit Shah',
        'designation': 'Assistant Professor',
        'dept': 'Database Management Systems (DBMS)',
        'cabin': 'Cabin 301, 3rd Floor FTE',
        'email': 'amitshah.ce@charusat.ac.in',
        'hours': '2:00 PM - 4:00 PM',
      },
      {
        'name': 'Dr. Ritu Desai',
        'designation': 'Head of Department',
        'dept': 'Computer Networks & Security',
        'cabin': 'HOD Office 210, FTE',
        'email': 'ritudesai.ce@charusat.ac.in',
        'hours': '10:00 AM - 12:00 PM',
      },
      {
        'name': 'Coach Vikram Singh',
        'designation': 'University Sports Director',
        'dept': 'Athletics & Physical Education Hub',
        'cabin': 'Sports Complex Directorate',
        'email': 'sports.director@charusat.ac.in',
        'hours': '6:00 AM - 8:30 AM',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: faculties.length,
      itemBuilder: (context, idx) {
        final f = faculties[idx];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFF0D47A1),
                  child: Text(
                    f['name']!.split(' ').map((e) => e[0]).take(2).join(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f['name']!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${f['designation']!} • ${f['dept']!}',
                        style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.meeting_room_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              f['cabin']!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              f['email']!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Consultation: ${f['hours']!}',
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
    );
  }
}
