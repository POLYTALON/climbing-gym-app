import 'package:climbing_gym_app/screens/start.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climbing App',
      theme: ThemeData(fontFamily: 'NunitoSans'),
      home: StartScreen(),
    );
  }
}
