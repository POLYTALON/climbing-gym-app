import 'package:flutter/material.dart';

class NavigationService {
  final PageController pageController = new PageController(
    initialPage: 0,
  );

  animateToPage(int index) async {
    await pageController.animateToPage(index,
        duration: Duration(milliseconds: 100), curve: Curves.easeOut);
  }

  jumpToPage(int index) {
    pageController.jumpToPage(index);
  }
}
