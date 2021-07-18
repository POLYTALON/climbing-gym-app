import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/UserRole.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

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

  Future<void> userSetup(String uid) async {
    _firestore
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (!documentSnapshot.exists) {
        _firestore
            .collection('users')
            .doc(uid)
            .set({'routes': {}, 'email': _auth.currentUser.email});
      }
    });
  }

  User get currentUser => _auth.currentUser;

  bool get loggedIn => _loggedIn;

  Future<UserCredential> register(
      String displayName, String userEmail, String userPassword) async {
    UserCredential newUser = await _auth.createUserWithEmailAndPassword(
        email: userEmail, password: userPassword);
    newUser.user.updateDisplayName(displayName);
    return newUser;
  }

  Future<void> unregister(String userEmail, String userPassword) async {
    await userReauthenticate(userEmail, userPassword);
    try {
      await _auth.currentUser.delete();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
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

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    UserCredential firebaseUserCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    // Set the displayname on first apple sign in
    if (firebaseUserCredential.user.displayName == null) {
      firebaseUserCredential.user.updateDisplayName(
          appleCredential.givenName + " " + appleCredential.familyName);
    }
    return firebaseUserCredential;
  }

  Future<void> sendVerifyMail(UserCredential usercred) async {
    return await usercred.user.sendEmailVerification();
  }

  Future<void> resetPassword(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<String> changePassword(
      String currentPassword, String newPassword) async {
    final user = _auth.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user.email, password: currentPassword);
    String msg = "";

    try {
      await user.reauthenticateWithCredential(cred).then((value) {
        user.updatePassword(newPassword).then((_) {
          msg = "OK";
        }).catchError((error) {
          msg = error.toString();
        });
      }).catchError((err) {
        msg = err.toString();
      });
    } on FirebaseAuthException catch (e) {
      msg = e.message;
    }
    print(msg);
    return msg;
  }

  Stream<AppUser> streamAppUser() {
    if (_auth.currentUser != null) {
      return _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid ?? '')
          .snapshots()
          .asyncMap((userDoc) async {
        String selectedGym = '';
        if (userDoc.id.isNotEmpty && userDoc.data().isNotEmpty) {
          selectedGym = userDoc.data()['selectedGym'] ?? '';
        }
        bool isOperator = await getIsOperator();
        Map<String, UserRole> userRoles = await _getUserRoles();
        Map<String, dynamic> userRoutes = await getUserRoutes();
        return AppUser.fromFirebase(
            _auth.currentUser, isOperator, userRoles, selectedGym, userRoutes);
      });
    }
    return Stream.empty();
  }

  Future<bool> getIsOperator() async {
    if (_auth.currentUser != null) {
      try {
        CollectionReference<Map<String, dynamic>> docRef = _firestore
            .collection('users')
            .doc(_auth.currentUser.uid)
            .collection('private');
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await docRef.doc('operator').get();
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
        await _firestore
            .collection('users')
            .doc(_auth.currentUser.uid)
            .collection('privileges')
            .get()
            .then((doc) {
          doc.docs.forEach((gym) {
            userRoles.putIfAbsent(gym.id, () {
              return UserRole(
                  gymuser: gym.data()['gymuser'] ?? false,
                  builder: gym.data()['builder'] ?? false);
            });
          });
        });
      } on FirebaseException catch (e) {
        print(e);
      }
      return userRoles;
    }
    return Map<String, UserRole>();
  }

  Future<Map<String, dynamic>> getUserRoutes() async {
    if (_auth.currentUser != null) {
      Map<String, dynamic> userRoutes = {};
      try {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser.uid)
            .snapshots()
            .first
            .then((snapshot) {
          Map<String, dynamic> data = snapshot.data();

          if (data.containsKey('routes')) {
            userRoutes = data['routes'];
          }
        });
      } on FirebaseException catch (e) {
        print(e);
      }
      return userRoutes;
    }
    return {};
  }

  Future<void> updateUserRouteStatus(AppRoute route) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firestore.collection('users').doc(_auth.currentUser.uid).get();
    dynamic userRoutes = userDoc.data()['routes'];
    if (userRoutes == null) {
      userRoutes = Map<String, dynamic>();
    }
    if (userRoutes[route.gymId] == null) {
      userRoutes[route.gymId] = Map<String, dynamic>();
    }

    if (route.isDone || route.isTried) {
      userRoutes[route.gymId]
          [route.id] = {"difficulty": route.difficulty, "isDone": route.isDone};
    } else {
      userRoutes[route.gymId][route.id] = null;
      userRoutes[route.gymId]
          .removeWhere((String key, dynamic value) => key == route.id);
    }
    await _firestore
        .collection('users')
        .doc(_auth.currentUser.uid)
        .update({"routes": userRoutes});
  }

  Future<void> selectGym(String gymid) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser.uid)
        .update({"selectedGym": gymid});
  }

  Future<bool> deleteInAllUsersGymPrivilege(String gymid) async {
    try {
      await _firestore
          .collection('users')
          .get()
          .then((doc) => doc.docs.forEach((user) {
                _firestore
                    .collection('users')
                    .doc(user.id)
                    .collection('privileges')
                    .get()
                    .then((docu) => docu.docs.forEach((gym) {
                          if (gym.id == gymid) {
                            deleteGymPrivilege(user.id, gym.id);
                          }
                        }));
              }));
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  String getRegistrationDateFormatted() {
    String convertedDateTime = '';
    if (_auth.currentUser != null) {
      DateTime time = _auth.currentUser.metadata.creationTime;
      convertedDateTime =
          "${time.day.toString().padLeft(2, '0')}.${time.month.toString().padLeft(2, '0')}.${time.year.toString()}";
    }
    return convertedDateTime;
  }

  Future<bool> setGymOwner(String email, String gymid) async {
    try {
      var doc = await _firestore.collection('users').get();
      bool isFound = false;
      await Future.forEach(doc.docs, (user) async {
        if (user.exists) {
          if (user.data()['email'] == email) {
            await _firestore
                .collection('users')
                .doc(user.id)
                .collection('privileges')
                .doc(gymid)
                .set({'gymuser': true});
            isFound = true;
          }
        }
      });
      return isFound;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> setBuilder(String email, String gymid) async {
    try {
      await selectGym(gymid);
      var doc = await _firestore.collection('users').get();
      bool isFound = false;

      await Future.forEach(doc.docs, (user) async {
        if (user.exists) {
          if (user.data()['email'] == email) {
            await _firestore
                .collection('users')
                .doc(user.id)
                .collection('privileges')
                .doc(gymid)
                .set({'builder': true});
            isFound = true;
          }
        }
      });
      return isFound;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserCredential> userReauthenticate(
      String userEmail, String userPassword) async {
    AuthCredential credential =
        EmailAuthProvider.credential(email: userEmail, password: userPassword);
    return await _auth.currentUser.reauthenticateWithCredential(credential);
  }

  Future<bool> deleteUserAccountInDB(
      String userId, String userEmail, String userPassword) async {
    try {
      await userReauthenticate(userEmail, userPassword);
      bool isProviderPrivDeleted;
      bool isGymPrivDeleted;
      isProviderPrivDeleted = await deleteProvidePrivilege(userId);
      isGymPrivDeleted = await deleteUsersAllGymPrivileges(userId);
      if (isProviderPrivDeleted && isGymPrivDeleted) {
        await _firestore.collection('users').doc(userId).delete();
        return true;
      } else {
        return false;
      }
    } on FirebaseException catch (e) {
      return false;
    }
  }

  Future<bool> deleteProvidePrivilege(String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection("private")
          .doc("operator")
          .delete();
      return true;
    } on FirebaseException catch (e) {
      if (e.code == "permission-denied") {
        //print(e.code);
        return true;
      } else {
        print(e);
        return false;
      }
    }
  }

  Future<bool> deleteUsersAllGymPrivileges(String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection("privileges")
          .get()
          .then((doc) => doc.docs.forEach((gymPrivilege) {
                if (gymPrivilege.exists) {
                  deleteGymPrivilege(userId, gymPrivilege.id);
                }
              }));
      return true;
    } on FirebaseException catch (e) {
      if (e.code == "permission-denied") {
        //print(e.code);
        return true;
      } else {
        print(e);
        return false;
      }
    }
  }

  Future<bool> deleteGymPrivilege(String userId, String gymId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection("privileges")
          .doc(gymId)
          .delete();
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> removeGymOwnerOrBuilder(String email, String gymId) async {
    try {
      await selectGym(gymId);
      bool isFound = false;
      var doc = await _firestore.collection('users').get();
      await Future.forEach(doc.docs, (user) async {
        if (user.exists) {
          if (user.data()['email'] == email) {
            await deleteGymPrivilege(user.id, gymId);
            isFound = true;
          }
        }
      });
      return isFound;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  bool isFirebaseProvider() {
    // Returns true, if auth provider is Firebase.
    // Returns false, if provider is something else (e.g. Google, Apple, ...)
    List<UserInfo> providerData = _auth.currentUser.providerData;
    if (providerData[0] != null && providerData[0].providerId == 'password') {
      return true;
    }
    return false;
  }
}
