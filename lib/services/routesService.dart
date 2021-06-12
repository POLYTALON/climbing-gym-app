import 'dart:io';

import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path/path.dart';

class RoutesService extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  AppRoute currentRoute;

  bool showEditPanel = false;

  void showEdit(AppRoute route) {
    currentRoute = route;
    showEditPanel = true;
    notifyListeners();
  }

  Stream<List<AppRoute>> streamRoutes(String gymId, dynamic userRoutes) {
    return _firestore
        .collection('routes')
        .orderBy('date', descending: true)
        .where('gymid', isEqualTo: gymId)
        .snapshots()
        .map((list) => list.docs.map((doc) {
              // user infos
              bool isTried = false;
              bool isDone = false;
              if (userRoutes[gymId] != null &&
                  userRoutes[gymId][doc.id] != null) {
                if (userRoutes[gymId][doc.id]['isDone'] == true) {
                  isDone = true;
                } else {
                  isTried = true;
                }
              }
              return AppRoute.fromFirestore(doc, isTried, isDone);
            }).toList());
  }

  Future<Map<String, int>> getRouteAmountPerColor(String gymId) async {
    Map<String, int> result = {};
    await _firestore
        .collection('routes')
        .where('gymid', isEqualTo: gymId)
        .get()
        .then((list) => list.docs.forEach((doc) {
              String difficulty = doc.data()['difficulty'];
              if (!result.containsKey(difficulty)) {
                result[difficulty] = 1;
              } else {
                result[difficulty] = result[difficulty] + 1;
              }
            }));
    return result;
  }

  Future<double> getRatingByRouteId(String routeId) async {
    int ratingCount = 0;
    double ratingSum = 0;
    await _firestore
        .collection('routes')
        .doc(routeId)
        .collection('ratings')
        .get()
        .then((doc) {
      doc.docs.forEach((rating) {
        ratingCount++;
        ratingSum += rating.data()['rating'];
      });
    });
    return ratingSum / ratingCount;
  }

  Future<void> addRoute(
      String name,
      String gymid,
      String difficulty,
      String type,
      String holds,
      String builder,
      File image,
      DateTime date) async {
    DocumentReference docRef;
    try {
      docRef = _firestore.collection('routes').doc();
    } on FirebaseException catch (e) {
      print(e);
    }
    String imageUrl = await uploadFile(image, docRef.path);
    try {
      await docRef.set({
        'name': name,
        'gymid': gymid,
        'difficulty': difficulty,
        'type': type,
        'holds': holds,
        'imageUrl': imageUrl,
        'date': date,
        'builder': builder,
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> editRoute(
      String id,
      String name,
      String gymid,
      String difficulty,
      String type,
      String holds,
      String builder,
      DateTime date,
      [File image]) async {
    String imageUrl;
    if (image != null) {
      imageUrl = await uploadFile(image, 'routes' + '/' + id);
      try {
        await _firestore.collection('routes').doc(id).update({
          'name': name,
          'gymid': gymid,
          'difficulty': difficulty,
          'type': type,
          'holds': holds,
          'imageUrl': imageUrl,
          'date': date,
          'builder': builder,
        });
      } on FirebaseException catch (e) {
        print(e);
      }
    } else {
      try {
        await _firestore.collection('routes').doc(id).update({
          'name': name,
          'gymid': gymid,
          'difficulty': difficulty,
          'type': type,
          'holds': holds,
          'date': date,
          'builder': builder,
        });
      } on FirebaseException catch (e) {
        print(e);
      }
    }
  }

  Future<bool> deleteRoute(String id) async {
    try {
      dynamic route = await _firestore.collection('routes').doc(id).get();
      await _storage.refFromURL(route.data()['imageUrl']).delete();
    } on FirebaseException catch (e) {
      print(e);
    }
    try {
      await _firestore.collection('routes').doc(id).delete();
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updateRouteRating(
      String userid, AppRoute route, int rating) async {
    try {
      DocumentSnapshot userRating = await _firestore
          .collection('routes')
          .doc(route.id)
          .collection('ratings')
          .doc(userid)
          .get();
      if (userRating.exists) {
        await _firestore
            .collection('routes')
            .doc(route.id)
            .collection('ratings')
            .doc(userid)
            .update({'rating': rating});
      } else {
        await _firestore
            .collection('routes')
            .doc(route.id)
            .collection('ratings')
            .doc(userid)
            .set({'rating': rating});
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<bool> cleanUpRoutesForGym(String gymid) async {
    try {
      await _firestore
          .collection('routes')
          .get()
          .then((doc) => doc.docs.forEach((route) {
                if (route.exists) {
                  if (route.data()['gymid'] == gymid) {
                    deleteRoute(route.id);
                  }
                }
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
