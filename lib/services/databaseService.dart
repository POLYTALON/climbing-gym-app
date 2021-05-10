import 'package:climbing_gym_app/models/News.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> userSetup(String uid) async {
    _firestore
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (!documentSnapshot.exists) {
        print('Document not exists');
        _firestore.collection('users').doc(uid).set({'active': true});
      } else {
        print('Document exists');
      }
    });
  }

  Stream<List<News>> streamNews(String gym) {
    //TODO: better so store gym id in news table?
    var news = _firestore.collection('news').snapshots().map(
        (list) => list.docs.map((doc) => News.fromFirestore(doc)).toList());
    print(news.length);
    print(news);
    return news;
  }
}
