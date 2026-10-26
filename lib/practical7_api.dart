// ============================================================================
// CHAROTAR UNIVERSITY OF SCIENCE AND TECHNOLOGY (CHARUSAT)
// FACULTY OF TECHNOLOGY AND ENGINEERING (FTE)
// DEPARTMENT OF ARTIFICIAL INTELLIGENCE & MACHINE LEARNING
// SUBJECT: AIUE302 - Mobile Application Development (Semester 5)
// PRACTICAL 7: Integrate RESTful API for Academic Information
// STUDENT: Jeel Pipaliya (24AIML051)
// ============================================================================

import 'package:flutter/material.dart';
import 'api_service.dart';

class Practical7ApiHubScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final int initialTabIndex;

  const Practical7ApiHubScreen({
    super.key,
    required this.onToggleTheme,
    this.initialTabIndex = 0,
  });

  @override
  State<Practical7ApiHubScreen> createState() => _Practical7ApiHubScreenState();
}

class _Practical7ApiHubScreenState extends State<Practical7ApiHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();

  // Notices State
  String _selectedCategory = 'All Categories';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  late Future<ApiResponse<List<AcademicNotice>>> _noticesFuture;

  // Events State
  late Future<ApiResponse<List<CampusEvent>>> _eventsFuture;

  // POST Lab State
  final _postFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Jeel Pipaliya');
  final _idController = TextEditingController(text: '24AIML051');
  final _emailController = TextEditingController(text: 'jeel.pipaliya@charusat.edu.in');
  final _feedbackController = TextEditingController(
    text: 'Requesting permission for team registration in the upcoming AI & Mobile App Expo.',
  );
  String _selectedEvent = 'National AI & Mobile Innovation Hackathon 2026';
  bool _isPosting = false;
  ApiResponse<Map<String, dynamic>>? _postResult;

  final List<String> _categories = [
    'All Categories',
    'Examinations',
    'Placements',
    'Sports & Athletics',
    'Campus Events',
    'Academic Notices',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _loadNotices();
    _loadEvents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _loadNotices({bool forceRefresh = false}) {
    setState(() {
      _noticesFuture = _apiService.fetchAcademicNotices(
        categoryFilter: _selectedCategory,
        searchQuery: _searchQuery,
        forceRefresh: forceRefresh,
      );
    });
  }

  void _loadEvents() {
    setState(() {
      _eventsFuture = _apiService.fetchCampusEvents();
    });
  }

  Future<void> _handleRefresh() async {
    _loadNotices(forceRefresh: true);
    await _noticesFuture;
  }

  void _submitPostRequest() async {
    if (!_postFormKey.currentState!.validate()) return;

    setState(() {
      _isPosting = true;
      _postResult = null;
    });

    final reg = EventRegistration(
      studentName: _nameController.text.trim(),
      enrollmentId: _idController.text.trim(),
      email: _emailController.text.trim(),
      selectedEvent: _selectedEvent,
      department: 'Department of AI & ML • FTE CHARUSAT',
      feedback: _feedbackController.text.trim(),
    );

    final result = await _apiService.submitRegistration(reg);

    if (!mounted) return;
    setState(() {
      _isPosting = false;
      _postResult = result;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.isSuccess
              ? 'HTTP POST Successful! Status: ${result.statusCode} Created'
              : 'HTTP POST Error: ${result.errorMessage}',
        ),
        backgroundColor: result.isSuccess ? const Color(0xFF10B981) : Colors.redAccent,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ============================================================================
  // TAB 1: ACADEMIC NOTICES (HTTP GET + Search + Pull-to-Refresh)
  // ============================================================================
  Widget _buildNoticesTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Search & Category Filter Section
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF131D2E) : Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
          ),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search notices by title, keyword, or tag...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                            _loadNotices();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1F2C42) : const Color(0xFFF1F5F9),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) {
                  setState(() => _searchQuery = val);
                  _loadNotices();
                },
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(cat),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.grey.shade300 : const Color(0xFF334155)),
                        ),
                        selectedColor: const Color(0xFF0D47A1),
                        backgroundColor: isDark ? const Color(0xFF1F2C42) : Colors.grey.shade100,
                        checkmarkColor: Colors.white,
                        onSelected: (selected) {
                          setState(() => _selectedCategory = cat);
                          _loadNotices();
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Live API Response List with FutureBuilder
        Expanded(
          child: FutureBuilder<ApiResponse<List<AcademicNotice>>>(
            future: _noticesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Color(0xFF0D47A1)),
                      SizedBox(height: 16),
                      Text('Executing HTTP GET https://dummyjson.com/posts...',
                          style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.redAccent),
                        const SizedBox(height: 12),
                        Text('API Connection Error: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _loadNotices(forceRefresh: true),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry Request'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final response = snapshot.data;
              final notices = response?.data ?? [];

              return RefreshIndicator(
                color: const Color(0xFF0D47A1),
                onRefresh: _handleRefresh,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Network Status Banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D47A1).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF0D47A1).withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.http_rounded, color: Color(0xFF0D47A1), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'HTTP ${response?.statusCode ?? 200} OK • ${notices.length} Notices Retrieved (Pull-to-refresh enabled)',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0D47A1),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: response?.isFromCache == true ? Colors.amber : Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              response?.isFromCache == true ? 'CACHED' : 'LIVE 200',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (notices.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(
                          child: Text('No academic notices match the selected criteria.'),
                        ),
                      )
                    else
                      ...notices.map((notice) => _buildNoticeCard(notice)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoticeCard(AcademicNotice notice) {
    Color badgeColor = const Color(0xFF0D47A1);
    if (notice.category == 'Examinations') {
      badgeColor = Colors.deepOrange;
    } else if (notice.category == 'Placements') {
      badgeColor = Colors.teal;
    } else if (notice.category == 'Sports & Athletics') {
      badgeColor = Colors.green;
    } else if (notice.category == 'Campus Events') {
      badgeColor = Colors.purple;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    notice.category,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ),
                Text(
                  notice.date,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              notice.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              notice.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700, height: 1.3),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.business_rounded, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    notice.organizer,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.remove_red_eye_outlined, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text('${notice.views}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(width: 12),
                const Icon(Icons.thumb_up_alt_outlined, size: 14, color: Colors.blue),
                const SizedBox(width: 4),
                Text('${notice.reactions}', style: const TextStyle(fontSize: 11, color: Colors.blue)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // TAB 2: CAMPUS EVENTS DIRECTORY (GET /users)
  // ============================================================================
  Widget _buildEventsTab() {
    return FutureBuilder<ApiResponse<List<CampusEvent>>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF0D47A1)));
        }

        final events = snapshot.data?.data ?? [];

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final ev = events[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(14),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF0D47A1).withValues(alpha: 0.15),
                  child: const Icon(Icons.event_available, color: Color(0xFF0D47A1)),
                ),
                title: Text(ev.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('${ev.organizer} • ${ev.date}', style: const TextStyle(fontSize: 12)),
                    Text(ev.venue, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () {
                    setState(() => _selectedEvent = ev.title);
                    _tabController.animateTo(2); // Jump to POST tab
                  },
                  child: const Text('Register', style: TextStyle(fontSize: 11)),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================================
  // TAB 3: HTTP POST LAB (Submit Feedback / Registration)
  // ============================================================================
  Widget _buildPostTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Card(
            color: isDark ? const Color(0xFF131D2E) : const Color(0xFFEFF6FF),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.send_rounded, color: Color(0xFF0D47A1), size: 28),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('HTTP POST Request Lab',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 2),
                        Text(
                          'Sends JSON payloads to https://jsonplaceholder.typicode.com/posts and awaits HTTP 201 Created response.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Form
          Form(
            key: _postFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Student Full Name *',
                    prefixIcon: Icon(Icons.person_rounded),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Name required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: 'Enrollment Identifier *',
                    prefixIcon: Icon(Icons.badge_rounded),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Enrollment ID required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Institutional Email *',
                    prefixIcon: Icon(Icons.email_rounded),
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Email required' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: _selectedEvent,
                  decoration: const InputDecoration(
                    labelText: 'Target Campus Event',
                    prefixIcon: Icon(Icons.event_note_rounded),
                  ),
                  items: [
                    'National AI & Mobile Innovation Hackathon 2026',
                    'Mega Campus Placement Drive: TCS & Infosys AI Labs',
                    'Annual Inter-College Varsity Athletics & Sports Meet',
                    'Google Cloud & Flutter Workshop',
                  ].map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedEvent = val);
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _feedbackController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Student Feedback / Statement of Purpose',
                    prefixIcon: Icon(Icons.feedback_outlined),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isPosting ? null : _submitPostRequest,
                    icon: _isPosting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.cloud_upload_rounded),
                    label: Text(_isPosting ? 'Dispatching HTTP POST...' : 'Execute HTTP POST Request'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // POST Response Inspector
          if (_postResult != null) ...[
            const Text('Live HTTP Response Inspector:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF10B981), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'RESPONSE: application/json',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'HTTP ${_postResult!.statusCode} CREATED',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24),
                  Text(
                    '''{
  "status": "Success",
  "httpStatusCode": ${_postResult!.statusCode},
  "assignedServerId": ${_postResult!.data?['id'] ?? 101},
  "studentName": "${_nameController.text}",
  "enrollmentId": "${_idController.text}",
  "event": "$_selectedEvent",
  "endpoint": "${_postResult!.endpoint}"
}''',
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 12,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================================
  // TAB 4: API ARCHITECTURE & POSTMAN CONTRACT
  // ============================================================================
  Widget _buildDocsTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.integration_instructions, color: Color(0xFF0D47A1)),
                    SizedBox(width: 8),
                    Text('Practical 7 API Contracts & Endpoints',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 12),
                _apiEndpointTile('GET', 'https://dummyjson.com/posts?limit=15',
                    'Retrieves academic announcements, tags, reactions, and view counts.'),
                _apiEndpointTile('GET', 'https://jsonplaceholder.typicode.com/users',
                    'Retrieves campus event organizers, department emails, and venues.'),
                _apiEndpointTile('POST', 'https://jsonplaceholder.typicode.com/posts',
                    'Submits student event registrations with JSON payload; returns 201 Created.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Postman cURL Snippet
        const Text('Postman cURL Command (HTTP POST Verification):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF131D2E) : const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '''curl -X POST https://jsonplaceholder.typicode.com/posts \\
  -H "Content-Type: application/json; charset=UTF-8" \\
  -d '{
    "title": "Registration: AI Hackathon 2026",
    "body": "Student Registration (24AIML051)",
    "userId": 51
  }' ''',
            style: TextStyle(fontFamily: 'Courier', fontSize: 11, color: Color(0xFF4ADE80)),
          ),
        ),
      ],
    );
  }

  Widget _apiEndpointTile(String method, String url, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: method == 'GET' ? Colors.blue : Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  method,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(url,
                    style: const TextStyle(fontFamily: 'Courier', fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(desc, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Practical 7: RESTful Web APIs',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            Text('HTTP GET / POST • JSON Parsing • Academic Notices Feed',
                style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Pull / Reload Data',
            onPressed: () => _loadNotices(forceRefresh: true),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFF0D47A1),
          indicatorColor: const Color(0xFF0D47A1),
          tabs: const [
            Tab(icon: Icon(Icons.newspaper_rounded), text: 'Academic Notices'),
            Tab(icon: Icon(Icons.event_note_rounded), text: 'Events Directory'),
            Tab(icon: Icon(Icons.send_rounded), text: 'HTTP POST Lab'),
            Tab(icon: Icon(Icons.code_rounded), text: 'API Contracts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNoticesTab(),
          _buildEventsTab(),
          _buildPostTab(),
          _buildDocsTab(),
        ],
      ),
    );
  }
}
