import 'package:climbing_gym_app/models/News.dart';
import 'package:flutter/material.dart';

class NewsDetails extends ChangeNotifier {
  News currentNews = News();
  bool showPanel = true;

  News get currentNewsDetails => currentNews;

  void showNews(News news) {
    currentNews = news;
    showPanel = true;
    notifyListeners();
  }
}
