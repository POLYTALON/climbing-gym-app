import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path/path.dart';
import 'package:climbing_gym_app/models/News.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewsService extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  News currentNews = News();
  bool showPanel = true;

  News get currentNewsDetails => currentNews;

  void showNews(News news) {
    currentNews = news;
    showPanel = true;
    notifyListeners();
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

  Future<bool> cleanUpNewsForGym(String gymid) async {
    try {
      await _firestore
          .collection('news')
          .where('gymid', isEqualTo: gymid)
          .get()
          .then((doc) => doc.docs.forEach((news) {
                deleteNews(news.id);
              }));
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