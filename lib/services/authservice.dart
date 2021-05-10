import 'package:climbing_gym_app/services/databaseservice.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthService with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  //FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _loggedIn = false;

  bool get loggedIn => _loggedIn;
  //get auth => _auth;

  bool checkLoggedIn() {
    return _loggedIn = _auth.currentUser != null;
  }

  Future<UserCredential> register(String userEmail, String userPassword) async {
    return _auth.createUserWithEmailAndPassword(
        email: userEmail, password: userPassword);
    //  .then((user) async {
    //print("Got IT: " + user.user.toString());
    //print("userid: " + user.user.uid.toString());
    // create users record
    //final auth = Provider.of<DatabaseService>(null, listen: false);
    //await auth.userSetup(user.user.uid.toString());
    //});
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().isSignedIn().then((value) => {
            if (value) {GoogleSignIn().signOut()}
          });
      _loggedIn = false;
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> loginUser(String userEmail, String userPassword) async {
    await _auth.signInWithEmailAndPassword(
        email: userEmail, password: userPassword);
    _loggedIn = true;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    _loggedIn = true;
    notifyListeners();
  }

/*
  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }
  */
}
