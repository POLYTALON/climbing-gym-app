import 'package:climbing_gym_app/models/Gym.dart';
import 'package:climbing_gym_app/models/News.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
}
