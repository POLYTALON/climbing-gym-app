import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:flutter/material.dart';

class RouteEdit extends ChangeNotifier {
  AppRoute currentRoute = AppRoute();
  bool showPanel = true;

  AppRoute get currentGymDetails => currentRoute;

  void showEdit(AppRoute route) {
    currentRoute = route;
    showPanel = true;
    notifyListeners();
  }
}
