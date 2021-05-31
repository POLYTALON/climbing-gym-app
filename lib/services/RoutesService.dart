import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:climbing_gym_app/models/Rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoutesService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    List<String> comments = [];
    List<int> ratings = [];
    await _firestore
        .collection('routes')
        .doc(routeId)
        .collection('ratings')
        .snapshots()
        .forEach((list) => list.docs.forEach((doc) {
              if (doc.exists) {
                comments.addAll(doc.data()['comments']);
                ratings.add(doc.data()['rating']);
              }
            }));
    Rating rating = Rating.fromFirestore(comments, ratings);
    print(rating);
    return rating;
  }
}
