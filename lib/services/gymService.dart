import 'dart:io';
import 'package:climbing_gym_app/services/fileService.dart';
import 'package:flutter/cupertino.dart';
import 'package:climbing_gym_app/models/Gym.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class GymService extends ChangeNotifier with FileService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  final ValueNotifier<Gym> currentGym = ValueNotifier(Gym());
  final PanelController panelControl = PanelController();
  final PanelController showSetOwnerPanel = PanelController();
  final PanelController showEditBuilderPanel = PanelController();

  void showEdit(Gym gym) {
    currentGym.value = gym;
    panelControl.open();
    notifyListeners();
  }

  void showSetOwner(Gym gym) {
    currentGym.value = gym;
    showSetOwnerPanel.open();
    notifyListeners();
  }

  void showEditBuilder(Gym gym) {
    currentGym.value = gym;
    showEditBuilderPanel.open();
    notifyListeners();
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
      String oldImageUrl;
      imageUrl = await uploadFile(image, 'gyms' + '/' + id);
      try {
        await _firestore
            .collection('gyms')
            .doc(id)
            .get()
            .then((gym) => oldImageUrl = gym.data()['imageUrl']);
        await _firestore
            .collection('gyms')
            .doc(id)
            .update({'name': name, 'city': city, 'imageUrl': imageUrl});
        await deleteFile(oldImageUrl);
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

  Future<bool> deleteGym(String id) async {
    try {
      dynamic gym = await _firestore.collection('gyms').doc(id).get();
      String imageUrl = gym.data()['imageUrl'];
      await _firestore.collection('gyms').doc(id).delete();
      await _storage.refFromURL(imageUrl).delete();
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> getGymNameById(String gymId) async {
    return _firestore
            .collection('gyms')
            .doc(gymId)
            .get()
            .then((gym) => gym.data()['name'] + ' ' + gym.data()['city']) ??
        '';
  }
}
