import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:learning_test/starter%20folder/articles.dart';

class NewsServices {
  final _article = List.generate(
    10,
    (_) => Article(
      title: lorem(paragraphs: 1, words: 3),
      content: lorem(paragraphs: 10, words: 500),
    ),
  );

  Future<List<Article>> getArticle() async {
    await Future.delayed(const Duration(seconds: 1));
    return _article;
  }
}
