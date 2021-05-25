import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/UserRole.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  Future<UserCredential> loginUser(
      String userEmail, String userPassword) async {
    return await _auth.signInWithEmailAndPassword(
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

  Future<void> sendVerifyMail(UserCredential usercred) async {
    return await usercred.user.sendEmailVerification();
  }

  Future<User> getUserDetails() async {
    User user = _auth.currentUser;
    return user;
  }

  Future<void> resetPassword(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Stream<AppUser> streamAppUser() {
    if (_auth.currentUser != null) {
      return _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid ?? '')
          .snapshots()
          .asyncMap((userDoc) async {
        bool isOperator = await _getIsOperator();
        Map<String, UserRole> userRoles = await _getUserRoles();
        return AppUser.fromFirebase(_auth.currentUser, isOperator, userRoles);
      });
    }
    return Stream.empty();
  }

  Future<bool> _getIsOperator() async {
    if (_auth.currentUser != null) {
      try {
        CollectionReference docRef = _firestore
            .collection('users')
            .doc(_auth.currentUser.uid)
            .collection('private');
        DocumentSnapshot snapshot = await docRef.doc('operator').get();
        if (snapshot.exists) {
          return snapshot.data()['operator'];
        }
      } on FirebaseException catch (e) {
        print(e);
      }
    }
    return false;
  }

  Future<Map<String, UserRole>> _getUserRoles() async {
    if (_auth.currentUser != null) {
      Map<String, UserRole> userRoles = Map<String, UserRole>();
      try {
        CollectionReference privileges = _firestore
            .collection('users')
            .doc(_auth.currentUser.uid)
            .collection('privileges');
        QuerySnapshot snapshot = await privileges.snapshots().first;
        await Future.wait(snapshot.docs.map((gym) async {
          DocumentSnapshot roles = await privileges
              .doc(gym.id)
              .collection('private')
              .doc('roles')
              .get();
          if (roles.exists) {
            userRoles.putIfAbsent(gym.id, () {
              return UserRole(gymuser: roles.data()['gymuser'] ?? false);
            });
          }
        }));
      } on FirebaseException catch (e) {
        print(e);
      }
      return userRoles;
    }
    return Map<String, UserRole>();
  }
}
