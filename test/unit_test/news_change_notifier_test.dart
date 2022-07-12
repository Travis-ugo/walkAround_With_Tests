import 'package:flutter_test/flutter_test.dart';
import 'package:learning_test/starter%20folder/articles.dart';
import 'package:learning_test/starter%20folder/news_change_notifier.dart';
import 'package:learning_test/starter%20folder/news_service.dart';
import 'package:mocktail/mocktail.dart';

// Bad way to write your mock classes

// class BadMockNewsService implements NewsService {
//   bool getArticleCalled = false;
//   @override
//   Future<List<Article>> getArticle() async {
//     getArticleCalled = true;
//     return [
//       Article(title: "Test 1", content: "Test 1 content"),
//       Article(title: "Test 2", content: "Test 2 content"),
//       Article(title: "Test 3", content: "Test 3 content"),
//     ];
//   }
// }

class MockNewsService extends Mock implements NewsServices {}

void main() {
  late NewsChangeNotifier sut; // system under test.
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test("initial values are correct", () {
    expect(sut.articles, []);
    expect(sut.isLoading, false);
  });

  group(
    "get Articles",
    () {
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

      test(
        "gets articles using the news service",
        () async {
          arrangeNewsServiceReturn3Articles();
          await sut.getArticles();
          verify(() => mockNewsService.getArticle()).called(1);
        },
      );

      test(
        """indicates loading data,
       set articles from the ones from the service,
       indicates that data is not being loaded anymore""",
        () async {
          arrangeNewsServiceReturn3Articles();
          final future = sut.getArticles();
          expect(sut.isLoading, true);
          await future;
          expect(sut.articles, articleFormService);
          expect(sut.isLoading, false);
        },
      );
    },
  );
}
