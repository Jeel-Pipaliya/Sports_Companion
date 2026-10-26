import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_companion/ai_assistant_service.dart';
import 'package:sports_companion/practical8_ai.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Practical 8: AiAssistantService Unit Tests', () {
    late AiAssistantService service;

    setUp(() {
      service = AiAssistantService();
      service.clearHistory();
    });

    test('1. Service initial state has welcome message', () {
      expect(service.chatHistory.isNotEmpty, isTrue);
      expect(service.chatHistory.first.isUser, isFalse);
      expect(service.chatHistory.first.text, contains('Gemini Nano'));
    });

    test('2. askAssistant responds to Stateful Widget query with academic explanation', () async {
      final reply = await service.askAssistant('Explain Stateful Widget');
      expect(reply.isUser, isFalse);
      expect(reply.text, contains('StatelessWidget'));
      expect(reply.text, contains('StatefulWidget'));
      expect(reply.latencyMs, greaterThan(0));
      expect(service.chatHistory.length, 3); // Welcome + User + AI
    });

    test('3. askAssistant responds to Lecture Summary query', () async {
      final reply = await service.askAssistant('Summarize today\'s lecture');
      expect(reply.text, contains('Lecture Summary'));
      expect(reply.text, contains('SQLite'));
      expect(reply.text, contains('RESTful API'));
    });

    test('4. askAssistant responds to DBMS study plan query', () async {
      final reply = await service.askAssistant('Generate study plan for DBMS examination');
      expect(reply.text, contains('DBMS Examination Study Plan'));
      expect(reply.text, contains('Relational Model'));
    });

    test('5. summarizeNotes compresses text and returns key takeaways', () {
      const sampleText =
          'Flutter widgets are declarative and immutable descriptions of the user interface. '
          'A StatelessWidget has no internal state and renders purely from constructor parameters. '
          'In contrast, a StatefulWidget delegates mutable state to a persistent State object, '
          'which triggers framework reconciliation through setState(). Understanding element trees, '
          'render objects, and dirty build scopes is critical for optimizing rendering performance. '
          'Mobile developers must structure code cleanly with separation of concerns.';
      final result = service.summarizeNotes(notes: sampleText, style: SummaryStyle.concise);

      expect(result.summary.isNotEmpty, isTrue);
      expect(result.keyTakeaways.isNotEmpty, isTrue);
      expect(result.compressionPercentage, greaterThan(0));
      expect(result.originalWordCount, greaterThan(result.summaryWordCount));
    });

    test('6. summarizeNotes handles empty input gracefully', () {
      final result = service.summarizeNotes(notes: '');
      expect(result.originalWordCount, 0);
      expect(result.summary, contains('No notes provided'));
    });

    test('7. generateStudyPlan produces correct daily schedule and resources', () {
      final plan = service.generateStudyPlan(
        subject: 'Mobile Application Development',
        days: 5,
        targetGrade: 'Grade AA (90%+)',
      );

      expect(plan.days, 5);
      expect(plan.schedule.length, 5);
      expect(plan.schedule.first.day, 1);
      expect(plan.schedule.first.topics.isNotEmpty, isTrue);
      expect(plan.recommendedResources.isNotEmpty, isTrue);
    });

    test('8. generateQuiz generates 4 interactive questions with valid options', () {
      final quiz = service.generateQuiz();
      expect(quiz.length, 4);
      for (final q in quiz) {
        expect(q.options.length, 4);
        expect(q.correctIndex, inInclusiveRange(0, 3));
        expect(q.explanation.isNotEmpty, isTrue);
      }
    });

    test('9. translateAcademicContent produces Hindi and Gujarati strings', () {
      final translation = service.translateAcademicContent('Stateful widgets maintain mutable state');
      expect(translation.hindiTranslation, contains('विजेट्स'));
      expect(translation.gujaratiTranslation, contains('વિજેટ્સ'));
      expect(translation.technicalGlossary.containsKey('Stateful Widget'), isTrue);
    });

    test('10. runHardwareBenchmark returns on-device edge metrics', () async {
      final benchmark = await service.runHardwareBenchmark();
      expect(benchmark.isOfflineReady, isTrue);
      expect(benchmark.privacyScore, 100);
      expect(benchmark.onDeviceLatencyMs, lessThan(benchmark.cloudLatencyMs));
      expect(benchmark.onDeviceDataTransferredBytes, 0);
    });
  });

  group('Practical 8: Widget Tests', () {
    testWidgets('11. Practical8AiHubScreen renders with AppBar and 4 Tabs', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Practical8AiHubScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Practical 8: Smart AI Assistant'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'AI Chat'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Note Summarizer'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Study & Quiz'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Edge Benchmark'), findsOneWidget);
      expect(find.text('Gemini Nano 1.8B INT4 (On-Device)'), findsOneWidget);
    });

    testWidgets('12. Note Summarizer tab loads notes and produces summary', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Practical8AiHubScreen(initialTabIndex: 1),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Load Sample Lecture Content:'), findsOneWidget);
      expect(find.text('Flutter Widgets'), findsOneWidget);

      // Tap on sample chip
      await tester.tap(find.text('Flutter Widgets'));
      await tester.pumpAndSettle();

      // Tap Generate AI Summary button
      final btnFinder = find.text('Generate AI Summary (On-Device)');
      await tester.ensureVisible(btnFinder);
      await tester.tap(btnFinder);
      await tester.pumpAndSettle();

      expect(find.text('AI Summary Generated'), findsOneWidget);
      expect(find.text('Key Academic Takeaways:'), findsOneWidget);
    });

    testWidgets('13. Study & Quiz tab allows answering quiz question', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Practical8AiHubScreen(initialTabIndex: 2),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Exam Revision Planner'), findsOneWidget);
      expect(find.text('AI-Generated Academic Quiz'), findsOneWidget);

      final correctOptionFinder = find.text('They offer zero network latency, offline availability, and absolute data privacy.');
      await tester.ensureVisible(correctOptionFinder);
      expect(correctOptionFinder, findsOneWidget);

      await tester.tap(correctOptionFinder);
      await tester.pumpAndSettle();

      expect(find.text('Score: 1 / 4'), findsOneWidget);
      expect(find.textContaining('Explanation: On-Device AI executes locally'), findsOneWidget);
    });

    testWidgets('14. Edge Benchmark tab renders metrics and comparison table', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Practical8AiHubScreen(initialTabIndex: 3),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('On-Device AI Silicon Status'), findsOneWidget);
      expect(find.text('On-Device Gemini Nano vs Cloud AI Comparison'), findsOneWidget);
      expect(find.text('Multilingual Academic Translation'), findsOneWidget);
      expect(find.text('Run Edge vs Cloud AI Benchmark'), findsOneWidget);
    });
  });
}
