import 'package:climbing_gym_app/models/UserRole.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String imageUrl;
  final bool isOperator;
  final Map<String, UserRole> roles;

  @override
  List<Object> get props =>
      [uid, email, displayName, imageUrl, isOperator, roles];

  AppUser(
      {this.uid = '',
      this.email = '',
      this.displayName = '',
      this.imageUrl = '',
      this.isOperator = false,
      this.roles = const {}});

  factory AppUser.fromFirebase(
      User firebaseUser, bool isOperator, Map<String, UserRole> userRoles) {
    return AppUser(
        uid: firebaseUser.uid ?? '',
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
        imageUrl: firebaseUser.photoURL ?? '',
        isOperator: isOperator ?? false,
        roles: userRoles ?? Map<String, UserRole>());
  }

  AppUser empty() {
    return AppUser(
        uid: '',
        email: '',
        displayName: '',
        imageUrl: '',
        isOperator: false,
        roles: Map<String, UserRole>());
  }
}
