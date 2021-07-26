import 'package:climbing_gym_app/models/RouteColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteColorService extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RouteColor>> getAvailableRouteColors() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('routecolors').doc('colors').get();
    return snapshot
        .data()
        .entries
        .map((entry) => RouteColor.fromFirestore(entry.key, entry.value))
        .toList();
  }

  Future<Color> getColorFromString(String color) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('routecolors').doc('colors').get();
      String hexColor = snapshot.data()[color];
      return Color(int.parse(hexColor));
    } on Exception {
      return Colors.black;
    }
  }
}
