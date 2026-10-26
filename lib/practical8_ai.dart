import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ai_assistant_service.dart';
import 'navigation_widgets.dart';

/// Practical 8 AI Assistant Hub Screen.
/// Provides an on-device AI academic assistant with Gemini Nano simulation,
/// note summarizer, study plan generator, interactive quiz, and edge benchmark.
class Practical8AiHubScreen extends StatefulWidget {
  final int initialTabIndex;

  const Practical8AiHubScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<Practical8AiHubScreen> createState() => _Practical8AiHubScreenState();
}

class _Practical8AiHubScreenState extends State<Practical8AiHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AiAssistantService _aiService = AiAssistantService();

  // Chat tab state
  final TextEditingController _chatInputController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  bool _isChatLoading = false;

  // Summarizer tab state
  final TextEditingController _notesController = TextEditingController();
  SummaryStyle _selectedSummaryStyle = SummaryStyle.concise;
  NoteSummaryResult? _summaryResult;
  bool _isSummarizing = false;

  // Study planner tab state
  String _selectedSubject = 'Mobile Application Development';
  int _studyDays = 5;
  String _targetGrade = 'Grade AA (90%+)';
  StudyPlan? _generatedPlan;
  bool _isGeneratingPlan = false;

  // Quiz state
  late List<QuizQuestion> _quizQuestions;
  final Map<int, int> _selectedAnswers = {};
  int _quizScore = 0;

  // Benchmark & Translation state
  EdgeHardwareBenchmark? _benchmarkResult;
  bool _isBenchmarking = false;
  final TextEditingController _translationController = TextEditingController(
    text: 'Stateful widgets maintain mutable state across frames.',
  );
  AcademicTranslation? _translationResult;

  final List<String> _quickPrompts = [
    'Explain Stateful Widget',
    'Summarize today\'s lecture',
    'Generate study plan for DBMS',
    'List Flutter interview questions',
    'Suggest learning resources',
  ];

  final Map<String, String> _sampleNotes = {
    'Flutter Widgets':
        'Flutter widgets are declarative and immutable descriptions of the user interface. '
        'A StatelessWidget has no internal state and renders purely from constructor parameters. '
        'In contrast, a StatefulWidget delegates mutable state to a persistent State object, '
        'which triggers framework reconciliation through setState(). Understanding element trees, '
        'render objects, and dirty build scopes is critical for optimizing rendering performance.',
    'SQLite & Persistence':
        'Mobile applications require local persistence to operate reliably in offline conditions. '
        'SQLite provides a lightweight, ACID-compliant relational database embedded in the application process. '
        'In Flutter, the sqflite package provides asynchronous execution of SQL queries, schema versioning, '
        'and transactional batch operations to prevent blocking the UI thread during disk I/O.',
    'REST APIs':
        'RESTful architectures communicate over HTTP using stateless client-server principles. '
        'Mobile clients issue GET, POST, PUT, and DELETE verbs and receive JSON payloads. '
        'Modern Flutter networking handles HTTP status codes (200 OK, 201 Created, 404 Not Found), '
        'asynchronous Future handling, timeouts, exponential backoff retries, and strongly typed DTOs.',
    'Edge AI & Gemini':
        'On-device AI executes quantized foundation models directly on client hardware without sending '
        'data across the internet. Google AI Edge SDK and Android AICore enable Gemini Nano to perform '
        'zero-latency summarization, contextual Q&A, and grammar assistance with complete student privacy. '
        'INT4 quantization reduces the memory footprint while maintaining high conceptual fidelity.',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 3),
    );
    _quizQuestions = _aiService.generateQuiz();
    _translationResult = _aiService.translateAcademicContent(_translationController.text);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chatInputController.dispose();
    _chatScrollController.dispose();
    _notesController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSendMessage([String? predefinedText]) async {
    final query = predefinedText ?? _chatInputController.text.trim();
    if (query.isEmpty || _isChatLoading) {
      return;
    }

    _chatInputController.clear();
    setState(() {
      _isChatLoading = true;
    });
    _scrollToBottom();

    try {
      await _aiService.askAssistant(query);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isChatLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  Future<void> _handleSummarize() async {
    final notes = _notesController.text.trim();
    if (notes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or paste lecture notes first.')),
      );
      return;
    }

    setState(() {
      _isSummarizing = true;
    });

    await Future.delayed(const Duration(milliseconds: 40));
    final res = _aiService.summarizeNotes(notes: notes, style: _selectedSummaryStyle);

    if (mounted) {
      setState(() {
        _summaryResult = res;
        _isSummarizing = false;
      });
    }
  }

  Future<void> _handleGeneratePlan() async {
    setState(() {
      _isGeneratingPlan = true;
    });

    await Future.delayed(const Duration(milliseconds: 50));
    final plan = _aiService.generateStudyPlan(
      subject: _selectedSubject,
      days: _studyDays,
      targetGrade: _targetGrade,
    );

    if (mounted) {
      setState(() {
        _generatedPlan = plan;
        _isGeneratingPlan = false;
      });
    }
  }

  Future<void> _handleRunBenchmark() async {
    setState(() {
      _isBenchmarking = true;
    });

    final res = await _aiService.runHardwareBenchmark();

    if (mounted) {
      setState(() {
        _benchmarkResult = res;
        _isBenchmarking = false;
      });
    }
  }

  void _handleTranslate() {
    final text = _translationController.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _translationResult = _aiService.translateAcademicContent(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    const charusatBlue = Color(0xFF0D47A1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practical 8: Smart AI Assistant'),
        backgroundColor: charusatBlue,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            tooltip: 'Clear Chat History',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                _aiService.clearHistory();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat history reset to default.')),
              );
            },
          ),
          IconButton(
            tooltip: 'Hardware Diagnostics',
            icon: const Icon(Icons.memory_rounded),
            onPressed: () {
              _tabController.animateTo(3);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.amberAccent,
          indicatorWeight: 3.5,
          tabs: const [
            Tab(icon: Icon(Icons.chat_bubble_outline_rounded), text: 'AI Chat'),
            Tab(icon: Icon(Icons.summarize_outlined), text: 'Note Summarizer'),
            Tab(icon: Icon(Icons.calendar_month_outlined), text: 'Study & Quiz'),
            Tab(icon: Icon(Icons.speed_rounded), text: 'Edge Benchmark'),
          ],
        ),
      ),
      drawer: const AppNavigationDrawer(currentRoute: '/practical8'),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatTab(),
          _buildSummarizerTab(),
          _buildStudyAndQuizTab(),
          _buildBenchmarkTab(),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: AI ACADEMIC CHAT
  // ==========================================
  Widget _buildChatTab() {
    return Column(
      children: [
        // Engine status bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          color: const Color(0xFFE8EAF6),
          child: Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Gemini Nano 1.8B INT4 (On-Device)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color(0xFF1A237E),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF9FA8DA)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline_rounded, size: 12, color: Colors.green),
                    SizedBox(width: 3),
                    Text(
                      '100% Offline / Private',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Quick prompt chips
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: _quickPrompts.length,
            itemBuilder: (context, index) {
              final prompt = _quickPrompts[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  avatar: const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF0D47A1)),
                  label: Text(
                    prompt,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFBBDEFB)),
                  onPressed: () => _handleSendMessage(prompt),
                ),
              );
            },
          ),
        ),

        const Divider(height: 1),

        // Messages list
        Expanded(
          child: ListView.builder(
            controller: _chatScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            itemCount: _aiService.chatHistory.length + (_isChatLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _aiService.chatHistory.length) {
                return _buildLoadingBubble();
              }
              final msg = _aiService.chatHistory[index];
              return _buildChatBubble(msg);
            },
          ),
        ),

        // Input bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatInputController,
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(
                      hintText: 'Ask academic query (e.g. Stateful Widget, SQLite)...',
                      hintStyle: const TextStyle(fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xFFCFD8DC)),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FA),
                      suffixIcon: _chatInputController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                setState(() {
                                  _chatInputController.clear();
                                });
                              },
                            )
                          : null,
                    ),
                    onSubmitted: (value) => _handleSendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF0D47A1),
                  child: IconButton(
                    icon: _isChatLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    onPressed: _isChatLoading ? null : () => _handleSendMessage(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatBubble(ChatMessage msg) {
    final isUser = msg.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              margin: const EdgeInsets.only(top: 2, right: 8),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF1A237E),
                child: Icon(Icons.smart_toy_rounded, size: 18, color: Colors.white),
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF0D47A1) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser ? null : Border.all(color: const Color(0xFFE0E0E0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : const Color(0xFF263238),
                      fontSize: 13.5,
                      height: 1.4,
                    ),
                  ),
                  if (!isUser) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.bolt, size: 11, color: Colors.green),
                              const SizedBox(width: 2),
                              Text(
                                '${msg.latencyMs}ms latency',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          msg.engineUsed,
                          style: const TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 13, color: Colors.grey),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Copy Answer',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: msg.text));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Response copied to clipboard.')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) ...[
            Container(
              margin: const EdgeInsets.only(top: 2, left: 8),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF00ACC1),
                child: Text(
                  'JP',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF1A237E),
            child: Icon(Icons.smart_toy_rounded, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0D47A1)),
                ),
                SizedBox(width: 8),
                Text(
                  'Gemini Nano inferring locally...',
                  style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: NOTE SUMMARIZER & ANALYZER
  // ==========================================
  Widget _buildSummarizerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner card
          Card(
            color: const Color(0xFFEDE7F6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFF512DA8)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'AI Note Summarizer: Condense complex lecture slides into actionable takeaways with zero cloud transmission.',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: Color(0xFF311B92)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Preset sample notes
          const Text(
            'Load Sample Lecture Content:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF263238)),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _sampleNotes.keys.map((title) {
              return ActionChip(
                label: Text(title, style: const TextStyle(fontSize: 11.5)),
                backgroundColor: const Color(0xFFF5F5F5),
                avatar: const Icon(Icons.bookmark_outline, size: 14, color: Color(0xFF0D47A1)),
                onPressed: () {
                  setState(() {
                    _notesController.text = _sampleNotes[title]!;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 14),

          // Note input field
          TextField(
            controller: _notesController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Lecture Notes / Syllabus Topic Text',
              hintText: 'Paste or type lecture notes here for AI processing...',
              alignLabelWithHint: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),

          const SizedBox(height: 14),

          // Summary style options
          const Text(
            'Select AI Summarization Mode:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF263238)),
          ),
          const SizedBox(height: 6),
          SegmentedButton<SummaryStyle>(
            segments: const [
              ButtonSegment(
                value: SummaryStyle.concise,
                label: Text('Concise'),
                icon: Icon(Icons.short_text, size: 16),
              ),
              ButtonSegment(
                value: SummaryStyle.bulletPoints,
                label: Text('Bullets'),
                icon: Icon(Icons.format_list_bulleted, size: 16),
              ),
              ButtonSegment(
                value: SummaryStyle.examPrep,
                label: Text('Exam Prep'),
                icon: Icon(Icons.school, size: 16),
              ),
            ],
            selected: {_selectedSummaryStyle},
            onSelectionChanged: (Set<SummaryStyle> newSelection) {
              setState(() {
                _selectedSummaryStyle = newSelection.first;
              });
            },
          ),

          const SizedBox(height: 16),

          // Summarize button
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              icon: _isSummarizing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.bolt_rounded),
              label: Text(_isSummarizing ? 'Processing Locally with Gemini Nano...' : 'Generate AI Summary (On-Device)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _isSummarizing ? null : _handleSummarize,
            ),
          ),

          const SizedBox(height: 20),

          // Result display
          if (_summaryResult != null) ...[
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'AI Summary Generated',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0D47A1)),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Text(
                            '${_summaryResult!.compressionPercentage}% Compressed',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.green.shade800),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Text(
                      _summaryResult!.summary,
                      style: const TextStyle(fontSize: 13.5, height: 1.45, color: Color(0xFF263238)),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Key Academic Takeaways:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1A237E)),
                    ),
                    const SizedBox(height: 6),
                    ..._summaryResult!.keyTakeaways.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 12.5, color: Color(0xFF37474F)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Words: ${_summaryResult!.originalWordCount} → ${_summaryResult!.summaryWordCount} | Time: ${_summaryResult!.processingTimeMs}ms',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.copy, size: 14),
                          label: const Text('Copy', style: TextStyle(fontSize: 12)),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                              text: '${_summaryResult!.summary}\n\nTakeaways:\n${_summaryResult!.keyTakeaways.join('\n')}',
                            ));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Summary copied to clipboard.')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // TAB 3: STUDY PLANNER & QUIZ LAB
  // ==========================================
  Widget _buildStudyAndQuizTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Study Schedule Generator
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, color: Color(0xFF0D47A1)),
                      SizedBox(width: 8),
                      Text(
                        'Exam Revision Planner',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _selectedSubject,
                    decoration: const InputDecoration(
                      labelText: 'Select Academic Subject',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Mobile Application Development',
                        child: Text('Mobile Application Development (AIUE302)'),
                      ),
                      DropdownMenuItem(
                        value: 'Database Management Systems',
                        child: Text('Database Management Systems (DBMS)'),
                      ),
                      DropdownMenuItem(
                        value: 'Machine Learning',
                        child: Text('Machine Learning & Neural Networks'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedSubject = val);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Days to Exam: $_studyDays Days',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            Slider(
                              value: _studyDays.toDouble(),
                              min: 3,
                              max: 14,
                              divisions: 11,
                              label: '$_studyDays days',
                              onChanged: (v) => setState(() => _studyDays = v.round()),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: _targetGrade,
                          decoration: const InputDecoration(
                            labelText: 'Target Grade',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'Grade AA (90%+)', child: Text('Grade AA (90%+)')),
                            DropdownMenuItem(value: 'Grade AB (80%+)', child: Text('Grade AB (80%+)')),
                            DropdownMenuItem(value: 'Grade BB (70%+)', child: Text('Grade BB (70%+)')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _targetGrade = val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      icon: _isGeneratingPlan
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.psychology_rounded),
                      label: const Text('Synthesize Study Plan with Gemini Nano'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _isGeneratingPlan ? null : _handleGeneratePlan,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Generated Study Plan
          if (_generatedPlan != null) ...[
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFFF1F8E9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📅 ${_generatedPlan!.days}-Day AI Study Schedule: ${_generatedPlan!.subject}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2E7D32)),
                    ),
                    const SizedBox(height: 8),
                    ..._generatedPlan!.schedule.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFC8E6C9)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: const Color(0xFF2E7D32),
                                    child: Text(
                                      '${item.day}',
                                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                                    ),
                                  ),
                                  Text(
                                    '${item.durationMinutes} min',
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Topics: ${item.topics.join(' • ')}',
                                style: const TextStyle(fontSize: 11.5, color: Color(0xFF37474F)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 6),
                    Text(
                      'Exam Tips: ${_generatedPlan!.examTips}',
                      style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF1B5E20)),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Section 2: Interactive Academic Quiz
          Row(
            children: [
              const Icon(Icons.quiz_rounded, color: Color(0xFF0D47A1)),
              const SizedBox(width: 8),
              const Text(
                'AI-Generated Academic Quiz',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0D47A1)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Score: $_quizScore / ${_quizQuestions.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0D47A1)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Test your comprehension of Mobile AI, Gemini Nano, and Flutter lifecycles:',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          ..._quizQuestions.asMap().entries.map((entry) {
            final qIndex = entry.key;
            final q = entry.value;
            final selected = _selectedAnswers[qIndex];
            final hasAnswered = selected != null;

            return Card(
              margin: const EdgeInsets.only(bottom: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${qIndex + 1}: ${q.question}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF263238)),
                    ),
                    const SizedBox(height: 8),
                    ...q.options.asMap().entries.map((optEntry) {
                      final optIndex = optEntry.key;
                      final optText = optEntry.value;

                      Color optColor = Colors.white;
                      Color borderColor = const Color(0xFFE0E0E0);

                      if (hasAnswered) {
                        if (optIndex == q.correctIndex) {
                          optColor = const Color(0xFFE8F5E9);
                          borderColor = Colors.green;
                        } else if (selected == optIndex) {
                          optColor = const Color(0xFFFFEBEE);
                          borderColor = Colors.red;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: InkWell(
                          onTap: hasAnswered
                              ? null
                              : () {
                                  setState(() {
                                    _selectedAnswers[qIndex] = optIndex;
                                    if (optIndex == q.correctIndex) {
                                      _quizScore++;
                                    }
                                  });
                                },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: optColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: hasAnswered && optIndex == q.correctIndex
                                      ? Colors.green
                                      : (hasAnswered && selected == optIndex ? Colors.red : const Color(0xFF90A4AE)),
                                  child: Text(
                                    String.fromCharCode(65 + optIndex),
                                    style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    optText,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    if (hasAnswered) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '💡 Explanation: ${q.explanation}',
                          style: const TextStyle(fontSize: 11.5, color: Color(0xFFF57F17)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 4: EDGE BENCHMARK & DIAGNOSTICS
  // ==========================================
  Widget _buildBenchmarkTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Silicon hardware card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.memory, color: Color(0xFF0D47A1)),
                      SizedBox(width: 8),
                      Text(
                        'On-Device AI Silicon Status',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0D47A1)),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  _buildMetricRow('Target Hardware Accelerator', 'ARM Cortex-A78 / Google Tensor NPU'),
                  _buildMetricRow('Foundation Model', 'Gemini Nano 1.8B (4-bit Quantized INT4)'),
                  _buildMetricRow('System Service', 'Android AICore Service (Simulated / Ready)'),
                  _buildMetricRow('SDK Version', 'Google AI Edge SDK v1.2.0'),
                  _buildMetricRow('Active Model Memory', '420.5 MB / 8192 MB (5.1% Total RAM)'),
                  _buildMetricRow('Privacy Classification', 'Air-Gapped / Zero Cloud Telemetry (100%)'),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      icon: _isBenchmarking
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.speed_rounded),
                      label: Text(_isBenchmarking ? 'Benchmarking Silicon...' : 'Run Edge vs Cloud AI Benchmark'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _isBenchmarking ? null : _handleRunBenchmark,
                    ),
                  ),
                  if (_benchmarkResult != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Live Benchmark: ${_benchmarkResult!.onDeviceLatencyMs}ms (Edge) vs ${_benchmarkResult!.cloudLatencyMs}ms (Cloud) • ${_benchmarkResult!.privacyScore}% Private',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Side-by-side comparison matrix
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'On-Device Gemini Nano vs Cloud AI Comparison',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1A237E)),
                  ),
                  const SizedBox(height: 12),
                  Table(
                    border: TableBorder.all(color: const Color(0xFFCFD8DC)),
                    columnWidths: const {
                      0: FlexColumnWidth(1.4),
                      1: FlexColumnWidth(1.3),
                      2: FlexColumnWidth(1.3),
                    },
                    children: [
                      _buildTableHeader(['Metric', 'On-Device Nano', 'Cloud Gemini']),
                      _buildTableRow(['Inference Latency', '14 ms (Sub-20ms)', '840 ms (+6000%)']),
                      _buildTableRow(['Data Sent Over Net', '0 Bytes (Offline)', '5.6 KB per call']),
                      _buildTableRow(['Offline Resilience', '✅ 100% Works Offline', '❌ Requires 5G/Wi-Fi']),
                      _buildTableRow(['Student Privacy', '🔒 Complete (Handset)', '⚠️ Server TLS Logs']),
                      _buildTableRow(['Server API Cost', '\$0.00 / Zero Cost', 'Token-based billing']),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Multilingual translation demo
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.translate_rounded, color: Color(0xFF0D47A1)),
                      SizedBox(width: 8),
                      Text(
                        'Multilingual Academic Translation',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0D47A1)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _translationController,
                    decoration: InputDecoration(
                      labelText: 'Academic Term or Statement to Translate',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward_rounded),
                        onPressed: _handleTranslate,
                      ),
                    ),
                  ),
                  if (_translationResult != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🇮🇳 Hindi (हिन्दी):',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFE65100)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _translationResult!.hindiTranslation,
                            style: const TextStyle(fontSize: 12.5),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '🏛️ Gujarati (ગુજરાતી):',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFE65100)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _translationResult!.gujaratiTranslation,
                            style: const TextStyle(fontSize: 12.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF546E7A)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableHeader(List<String> cells) {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFE8EAF6)),
      children: cells.map((c) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            c,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: Color(0xFF1A237E)),
          ),
        );
      }).toList(),
    );
  }

  TableRow _buildTableRow(List<String> cells) {
    return TableRow(
      children: cells.map((c) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            c,
            style: const TextStyle(fontSize: 11),
          ),
        );
      }).toList(),
    );
  }
}
