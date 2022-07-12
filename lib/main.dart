import 'package:flutter/material.dart';
import 'package:learning_test/starter%20folder/news_change_notifier.dart';
import 'package:learning_test/starter%20folder/news_page.dart';
import 'package:provider/provider.dart';

import 'starter folder/news_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(NewsServices()),
        child: const NewsPage(),
      ),
    );
  }
}
