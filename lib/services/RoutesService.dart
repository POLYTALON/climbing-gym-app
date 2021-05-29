import 'package:climbing_gym_app/models/Route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoutesService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Route>> streamRoutes(String gymId) {
    return _firestore
        .collection('routes')
        .orderBy('date', descending: true)
        .where('gymid', isEqualTo: gymId)
        .snapshots()
        .forEach((list) => list.docs.map((doc) => _firestore
            .collection('routes')
            .doc(doc.id)
            .collection('ratings')
            .snapshots()
            .map((list) =>
                list.docs.map((rating) => Route.fromFirestore(doc, rating)))))
        .asStream();
  }
}
