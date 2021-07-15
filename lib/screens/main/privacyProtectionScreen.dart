import 'package:climbing_gym_app/services/authservice.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';

class PrivacyProtectionScreen extends StatefulWidget {
  @override
  _PrivacyProtectionScreenState createState() =>
      _PrivacyProtectionScreenState();
}

class _PrivacyProtectionScreenState extends State<PrivacyProtectionScreen> {
  final authService = locator<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
