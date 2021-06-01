import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:climbing_gym_app/models/Rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class RoutesService extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppRoute currentRoute;

  bool showEditPanel = false;

  void showEdit(AppRoute route) {
    currentRoute = route;
    showEditPanel = true;
    notifyListeners();
  }

  Stream<List<AppRoute>> streamRoutes(String gymId) {
    return _firestore
        .collection('routes')
        .orderBy('date', descending: true)
        .where('gymid', isEqualTo: gymId)
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => AppRoute.fromFirestore(doc)).toList());
  }

  Future<Rating> getRatingByRouteId(String routeId) async {
    List<Map<String, Timestamp>> commentsList = [{}];
    List<int> ratingsList = [];
    await _firestore
        .collection('routes')
        .doc(routeId)
        .collection('ratings')
        .get()
        .then((doc) => doc.docs.forEach((rating) {
              if (rating.exists) {
                rating.data().entries.forEach((entry) {
                  commentsList.add(entry.value['date'] = entry.value['date']);
                  print(commentsList);
                });
                ratingsList.add(rating.data()['rating']);
              }
            }))
        .then((value) {
      return Rating.fromFirestore(commentsList, ratingsList);
    });
    return Rating();
  }
}
