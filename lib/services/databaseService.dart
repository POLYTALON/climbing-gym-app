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
    //TODO: only get news from the current gym and global news
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
    String imageUrl;
    imageUrl = await uploadFile(image);
    try {
      await _firestore
          .collection('gyms')
          .add({'name': name, 'city': city, 'imageUrl': imageUrl});
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> editGym(String id, String name, String city,
      [File image]) async {
    if (image != null) {
      String imageUrl;
      imageUrl = await uploadFile(image);
      try {
        await _firestore
            .collection('gyms')
            .doc(id)
            .update({'name': name, 'city': city, 'imageUrl': imageUrl});
      } on FirebaseException catch (e) {
        print(e);
      }
    } else {
      try {
        await _firestore
            .collection('gyms')
            .doc(id)
            .update({'name': name, 'city': city});
      } on FirebaseException catch (e) {
        print(e);
      }
    }
  }

  Future<void> addNews(String title, String subtitle, String content,
      String creator, File image) async {
    String imageUrl = await uploadFile(image);
    try {
      await _firestore.collection('news').add({
        'title': title,
        'subtitle': subtitle,
        'content': content,
        'imageUrls': [
          imageUrl //todo: more pictures
        ],
        'date': DateTime.now(),
        'creator': creator,
        'isGlobal': true, //todo
      });
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

  /* Privileges */
  Future<bool> hasRoleGymUser(String uid, String gymId) async {
    bool isGymUser = false;
    try {
      CollectionReference privileges =
          _firestore.collection('users').doc(uid).collection('privileges');
      CollectionReference private = privileges.doc(gymId).collection('private');
      DocumentSnapshot docRoles = await private.doc('roles').get();
      if (docRoles.exists) {
        isGymUser = docRoles.data()['gymuser'];
      }
    } on FirebaseException catch (e) {
      print(e);
    }
    return isGymUser;
  }

  Future<bool> isAnyGymUser(String uid) async {
    bool isAnyGymUser = false;
    try {
      CollectionReference privileges =
          _firestore.collection('users').doc(uid).collection('privileges');
      QuerySnapshot snapshot = await privileges.snapshots().first;
      await Future.wait(snapshot.docs.map((doc) async {
        DocumentSnapshot roles = await privileges
            .doc(doc.id)
            .collection('private')
            .doc('roles')
            .get();
        if (roles.data()['gymuser']) isAnyGymUser = true;
      }));
    } on FirebaseException catch (e) {
      print(e);
    }
    return isAnyGymUser;
  }
}
