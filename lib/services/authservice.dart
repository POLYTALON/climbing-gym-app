import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

/*
  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }
  */
}
