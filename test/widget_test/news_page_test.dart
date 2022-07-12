import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_test/starter%20folder/articles.dart';
import 'package:learning_test/starter%20folder/news_change_notifier.dart';
import 'package:learning_test/starter%20folder/news_page.dart';
import 'package:learning_test/starter%20folder/news_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockNewsService extends Mock implements NewsServices {}

void main() {
  late MockNewsService mockNewsService;
  setUp(() {
    mockNewsService = MockNewsService();
  });

  final articleFormService = [
    Article(title: "Test 1", content: "Test 1 content"),
    Article(title: "Test 2", content: "Test 2 content"),
    Article(title: "Test 3", content: "Test 3 content"),
  ];

  void arrangeNewsServiceReturn3Articles() {
    when(() => mockNewsService.getArticle()).thenAnswer(
      (_) async => articleFormService,
    );
  }

  void arrangeNewsServiceReturn3ArticlesAfter2Seconds() {
    when(() => mockNewsService.getArticle()).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return articleFormService;
    });
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets(
    "title is displayed",
    (WidgetTester tester) async {
      arrangeNewsServiceReturn3Articles();
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text("News"), findsOneWidget);
    },
  );

  testWidgets(
    "loading indicates is displayed while waiting for articles",
    (WidgetTester tester) async {
      arrangeNewsServiceReturn3ArticlesAfter2Seconds();

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump(
        const Duration(milliseconds: 500),
      ); // the pump() forces a widget rebuild to the build function inside the widget tree.

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    "Articles are displayed",
    (WidgetTester tester) async {
      arrangeNewsServiceReturn3Articles();

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump();

      for (final articles in articleFormService) {
        expect(find.text(articles.title), findsOneWidget);
        expect(find.text(articles.content), findsOneWidget);
      }
    },
  );
}
