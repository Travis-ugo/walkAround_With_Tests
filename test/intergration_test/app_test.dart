import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_test/starter%20folder/article_page.dart';
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
    """Tapping on the first article excerpt open
    the article page where the full article
    content is displayed""",
    (WidgetTester tester) async {
      arrangeNewsServiceReturn3Articles();

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.tap(find.text("Test 1 content"));
      await tester.pumpAndSettle();

      expect(find.byType(NewsPage), findsNothing);
      expect(find.byType(ArticlePage), findsOneWidget);

      expect(find.text("Test 1"), findsOneWidget);
      expect(find.text("Test 1 content"), findsOneWidget);
    },
  );
}
