import 'package:climbing_gym_app/constants.dart';
import 'package:climbing_gym_app/environment.dart';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  // run app
  runApp(MaterialApp(
      title: 'Climbing App',
      theme: ThemeData(fontFamily: 'NunitoSans', accentColor: polyGreen),
      home: MyApp(environment: EnvironmentValue.development)));
}
