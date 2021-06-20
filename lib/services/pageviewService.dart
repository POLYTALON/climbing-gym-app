import 'package:flutter/cupertino.dart';

class PageViewService {
  ValueNotifier<bool> isSwipingAllowed = ValueNotifier(true);

  void setSwipingAllowed(bool isValue) {
    isSwipingAllowed.value = isValue;
  }
}
