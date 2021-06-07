import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> userSetup(String uid) async {
    _firestore
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (!documentSnapshot.exists) {
        _firestore.collection('users').doc(uid).set({'routes': {}});
      }
    });
  }
}
