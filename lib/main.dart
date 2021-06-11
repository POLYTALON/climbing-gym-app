import 'package:climbing_gym_app/constants.dart';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/screens/start.dart';
import 'package:climbing_gym_app/screens/navigationContainer.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  // run app
  runApp(MaterialApp(
      title: 'Climbing App',
      theme: ThemeData(fontFamily: 'NunitoSans', accentColor: polyGreen),
      //home: MyApp(environment: EnvironmentValue.development)));
      home: MyApp()));
}

class MyApp extends StatelessWidget {
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final auth = locator<AuthService>();
  //final Environment environment;

  //MyApp({Key key, this.environment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: auth.loggedIn ? NavigationContainer() : StartScreen());
  }
}
