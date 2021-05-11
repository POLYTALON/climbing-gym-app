import 'dart:io';
import 'package:path/path.dart';
import 'package:climbing_gym_app/models/Gym.dart';
import 'package:climbing_gym_app/models/News.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

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

  Stream<List<News>> streamNews(String gym) {
    //TODO: better so store gym id in news table?
    return _firestore.collection('news').snapshots().map(
        (list) => list.docs.map((doc) => News.fromFirestore(doc)).toList());
  }

  Stream<List<Gym>> streamGyms() {
    return _firestore
        .collection('gyms')
        .snapshots()
        .map((list) => list.docs.map((doc) => Gym.fromFirestore(doc)).toList());
  }

  Future<void> addGym(String name, String city, File image) async {
    String imageUrl = await uploadFile(image);
    _firestore
        .collection('gyms')
        .add({name: name, city: city, imageUrl: imageUrl}).catchError((e) {
      print(e);
    });
  }

  Future<String> uploadFile(File file) async {
    Future<String> url;
    await _storage
        .ref()
        .child('${basename(file.path)}')
        .putFile(file)
        .whenComplete(() => {url = _storage.ref().getDownloadURL()});
    return url;
  }
}
