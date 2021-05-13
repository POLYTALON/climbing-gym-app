import 'dart:io';
import 'package:path/path.dart';
import 'package:climbing_gym_app/models/Gym.dart';
import 'package:climbing_gym_app/models/News.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:universal_html/html.dart' as html;
import 'package:uuid/uuid.dart';

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

  Future<void> addGym(String name, String city, dynamic image) async {
    String imageUrl;
    if (image is File) {
      imageUrl = await uploadFile(image);
    } else if (image is html.File) {
      imageUrl = await uploadFileWeb(image);
    }
    try {
      await _firestore
          .collection('gyms')
          .add({'name': name, 'city': city, 'imageUrl': imageUrl});
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String> uploadFile(File file) async {
    String url;
    try {
      TaskSnapshot snapshot =
          await _storage.ref().child(basename(file.path)).putFile(file);
      url = await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print(e);
    }
    return url;
  }

  Future<String> uploadFileWeb(html.File file) async {
    String name = Uuid().v4();
    Uri url;
    fb.StorageReference storageRef = fb.storage().ref(name);
    fb.UploadTaskSnapshot uploadTaskSnapshot =
        await storageRef.put(file).future;
    url = await uploadTaskSnapshot.ref.getDownloadURL();
    return url.toString();
  }
}
