import 'package:climbing_gym_app/models/Gym.dart';
import 'package:flutter/material.dart';

class GymEdit extends ChangeNotifier {
  Gym currentGym = Gym();
  bool showPanel = true;

  Gym get currentGymDetails => currentGym;

  void showEdit(Gym gym) {
    currentGym = gym;
    showPanel = true;
    notifyListeners();
  }
}
