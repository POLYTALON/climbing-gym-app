import 'package:climbing_gym_app/constants.dart';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/main.dart';
import 'package:flavorbanner/widgets/flavor_banner.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flavorbanner/flavor_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  FlavorConfig(
    flavor: Flavor.DEV,
    color: Colors.grey,
    values: FlavorValues(
      showBanner: true,
    ),
  );
  // run app
  runApp(MaterialApp(
    title: 'Climbing App',
    theme: ThemeData(fontFamily: 'NunitoSans', accentColor: polyGreen),
    home: MyApp(),
    builder: (context, child) => FlavorBanner(
      child: child,
    ),
  ));
}
