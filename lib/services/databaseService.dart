import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';
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

  Stream<List<News>> streamNews(String gymid) {
    return _firestore
        .collection('news')
        .where('gymid', whereIn: [gymid, ""])
        .orderBy("date", descending: true)
        .snapshots()
        .map(
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
    DocumentReference docRef;
    try {
      docRef = _firestore.collection('gyms').doc();
    } on FirebaseException catch (e) {
      print(e);
    }
    imageUrl = await uploadFile(image, docRef.path);
    try {
      await docRef.set({'name': name, 'city': city, 'imageUrl': imageUrl});
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> editGym(String id, String name, String city,
      [File image]) async {
    if (image != null) {
      String imageUrl;
      imageUrl = await uploadFile(image, 'gyms' + '/' + id);
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

  Future<void> addNews(String title, String content, String link, File image,
      String gymid) async {
    try {
      DocumentReference docRef;
      docRef = _firestore.collection('news').doc();

      String imageUrl = await uploadFile(image, docRef.path);

      String creator;
      if (gymid.isNotEmpty) {
        DocumentSnapshot gymDoc =
            await _firestore.collection('gyms').doc(gymid).get();
        creator = gymDoc.data()['name'];
      } else {
        creator = 'Polytalon';
      }

      await docRef.set({
        'title': title,
        'content': content,
        'link': link,
        'imageUrls': [
          imageUrl //TODO: allow / present multiple pictures
        ],
        'date': DateTime.now(),
        'creator': creator,
        'gymid': gymid,
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<bool> deleteNews(String id) async {
    try {
      dynamic news = await _firestore.collection('news').doc(id).get();
      await news.data()['imageUrls'].forEach((imageUrl) async {
        await _storage.refFromURL(imageUrl).delete();
      });
      await _firestore.collection('news').doc(id).delete();
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> uploadFile(File file, String path) async {
    String url;
    file = await compressFile(file);
    try {
      TaskSnapshot snapshot = await _storage
          .ref()
          .child(path + '/' + basename(file.path))
          .putFile(file);
      url = await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print(e);
    }
    return url;
  }

  Future<File> compressFile(File file) async {
    File compressedFile =
        await FlutterNativeImage.compressImage(file.path, quality: 5);
    return compressedFile;
  }
}
