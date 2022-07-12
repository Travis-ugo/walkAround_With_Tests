import 'package:flutter/material.dart';
import 'package:learning_test/starter%20folder/articles.dart';
import 'package:learning_test/starter%20folder/news_service.dart';

class NewsChangeNotifier extends ChangeNotifier {
  final NewsServices _newsService;

  NewsChangeNotifier(this._newsService);

  List<Article> _articles = [];

  List<Article> get articles => _articles;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> getArticles() async {
    _isLoading = true;
    notifyListeners();
    _articles = await _newsService.getArticle();
    _isLoading = false;
    notifyListeners();
  }
}
