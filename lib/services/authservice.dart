import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;

  Future<void> register(String userEmail, String userPassword) async {
    await _auth.createUserWithEmailAndPassword(
        email: userEmail, password: userPassword);
  }

  Future<void> logout() async {
    await _auth.signOut();
    _loggedIn = false;
    notifyListeners();
  }

  Future<void> loginUser(String userEmail, String userPassword) async {
    await _auth.signInWithEmailAndPassword(
        email: userEmail, password: userPassword);
    _loggedIn = true;
    notifyListeners();
  }

/*
  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }
  */
}
