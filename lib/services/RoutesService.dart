import 'package:climbing_gym_app/models/AppRoute.dart';
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
}
