import 'package:flutter/material.dart';

class NavigationService {
  final PageController pageController = new PageController(
    initialPage: 0,
  );

  jumpToPage(int index) {
    pageController.jumpToPage(index);
  }
}
