import 'dart:io';
import 'package:climbing_gym_app/services/fileService.dart';
import 'package:flutter/cupertino.dart';
import 'package:climbing_gym_app/models/News.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class NewsService extends ChangeNotifier with FileService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  final ValueNotifier<News> currentNews = ValueNotifier(News());
  final PanelController panelControl = PanelController();

  News get currentNewsDetails => currentNews.value;

  void showNews(News news) {
    currentNews.value = news;
    panelControl.open();
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
        DocumentSnapshot<Map<String, dynamic>> gymDoc =
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
      final List<dynamic> imageUrls = news.data()['imageUrls'];
      await _firestore.collection('news').doc(id).delete();
      imageUrls.forEach((imageUrl) async {
        await _storage.refFromURL(imageUrl).delete();
      });
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
}
