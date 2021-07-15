import 'package:climbing_gym_app/services/authservice.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final authService = locator<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
