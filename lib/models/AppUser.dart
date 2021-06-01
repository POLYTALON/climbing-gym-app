import 'package:climbing_gym_app/models/UserRole.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String imageUrl;
  final String selectedGym;
  final bool isOperator;
  final Map<String, UserRole> roles;

  @override
  List<Object> get props =>
      [uid, email, displayName, imageUrl, selectedGym, isOperator, roles];

  AppUser(
      {this.uid = '',
      this.email = '',
      this.displayName = '',
      this.imageUrl = '',
      this.selectedGym = '',
      this.isOperator = false,
      this.roles = const {}});

  factory AppUser.fromFirebase(User firebaseUser, bool isOperator,
      Map<String, UserRole> userRoles, Map<String, dynamic> userDoc) {
    return AppUser(
        uid: firebaseUser.uid ?? '',
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
        imageUrl: firebaseUser.photoURL ?? '',
        selectedGym: userDoc['selectedGym'] ?? '',
        isOperator: isOperator ?? false,
        roles: userRoles ?? Map<String, UserRole>());
  }

  AppUser empty() {
    return AppUser(
        uid: '',
        email: '',
        displayName: '',
        imageUrl: '',
        selectedGym: '',
        isOperator: false,
        roles: Map<String, UserRole>());
  }
}
