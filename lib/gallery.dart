// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development
// WORK/MODULE: Event & Sports Gallery (Responsive GridView)
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';

class EventGalleryScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const EventGalleryScreen({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event & Sports Gallery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: EventGalleryModule(onToggleTheme: onToggleTheme),
    );
  }
}

class EventGalleryModule extends StatelessWidget {
  final VoidCallback onToggleTheme;

  const EventGalleryModule({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    // Syllabus specified dataset: Display at least six event cards using GridView
    final List<Map<String, dynamic>> events = [
      {
        'title': 'CHARUSAT Spoural 2026',
        'category': 'Annual Sports Fest',
        'date': 'Nov 15-18, 2026',
        'venue': 'University Sports Complex',
        'icon': Icons.sports_soccer_rounded,
        'gradient': [const Color(0xFF0D47A1), const Color(0xFF1976D2)],
      },
      {
        'title': 'National Flutter Hackathon',
        'category': 'Mobile App Sprint',
        'date': 'Oct 28-29, 2026',
        'venue': 'FTE Innovation Center',
        'icon': Icons.phone_android_rounded,
        'gradient': [const Color(0xFF00695C), const Color(0xFF26A69A)],
      },
      {
        'title': 'AI & Deep Learning Summit',
        'category': 'Keynotes & Demos',
        'date': 'Nov 05, 2026',
        'venue': 'Central Auditorium',
        'icon': Icons.psychology_rounded,
        'gradient': [const Color(0xFF6A1B9A), const Color(0xFFAB47BC)],
      },
      {
        'title': 'Inter-Dept Football Cup',
        'category': 'Varsity Knockouts',
        'date': 'Nov 10, 2026',
        'venue': 'CHARUSAT Stadium',
        'icon': Icons.sports_football_rounded,
        'gradient': [const Color(0xFFE65100), const Color(0xFFFB8C00)],
      },
      {
        'title': 'Cloud & DevOps Bootcamp',
        'category': 'Hands-on Lab',
        'date': 'Oct 22, 2026',
        'venue': 'Seminar Hall 3',
        'icon': Icons.cloud_done_rounded,
        'gradient': [const Color(0xFF37474F), const Color(0xFF78909C)],
      },
      {
        'title': 'University Badminton League',
        'category': 'Singles & Doubles',
        'date': 'Nov 12, 2026',
        'venue': 'Indoor Sports Arena',
        'icon': Icons.sports_tennis_rounded,
        'gradient': [const Color(0xFFC2185B), const Color(0xFFEC407A)],
      },
      {
        'title': 'Tech Entrepreneurship Expo',
        'category': 'Startup Showcase',
        'date': 'Nov 22, 2026',
        'venue': 'Management Block Grounds',
        'icon': Icons.rocket_launch_rounded,
        'gradient': [const Color(0xFF00838F), const Color(0xFF00ACC1)],
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 720;
        final int crossAxis = isTablet ? 3 : 2;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxis,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.70,
          ),
          itemCount: events.length,
          itemBuilder: (context, idx) {
            final ev = events[idx];
            final List<Color> grad = ev['gradient'] as List<Color>;

            return Card(
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Upper Event Banner with Icon & Gradient
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: grad,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -10,
                            bottom: -10,
                            child: Icon(
                              ev['icon'] as IconData,
                              size: 72,
                              color: Colors.white.withValues(alpha: 0.20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    ev['category'] as String,
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Icon(
                                  ev['icon'] as IconData,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Lower Metadata Container
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ev['title'] as String,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, height: 1.2),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      ev['date'] as String,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      ev['venue'] as String,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 32,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Registered for ${ev['title']}')),
                                );
                              },
                              child: const Text('View Event', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
