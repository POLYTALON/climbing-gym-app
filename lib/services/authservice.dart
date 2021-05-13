import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  bool _loggedIn = false;

  AuthService() {
    _auth.authStateChanges().listen((User user) {
      _loggedIn = user != null;
      notifyListeners();
    });
    notifyListeners();
  }

  bool get loggedIn => _loggedIn;

  Future<UserCredential> register(
      String displayName, String userEmail, String userPassword) async {
    UserCredential newUser = await _auth.createUserWithEmailAndPassword(
        email: userEmail, password: userPassword);
    newUser.user.updateProfile(displayName: displayName);
    return newUser;
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().isSignedIn().then((value) => {
            if (value) {GoogleSignIn().signOut()}
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginUser(String userEmail, String userPassword) async {
    await _auth.signInWithEmailAndPassword(
        email: userEmail, password: userPassword);
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

  Future<User> getUserDetails() async {
    User user = await _auth.currentUser;
    return user;
  }

  Future<void> resetPassword(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
