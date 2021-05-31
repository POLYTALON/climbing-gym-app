import 'package:climbing_gym_app/constants.dart';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/screens/start.dart';
import 'package:climbing_gym_app/screens/navigationContainer.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'models/News.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  // run app
  runApp(
    MultiProvider(
      providers: [
        StreamProvider<List<News>>(
          initialData: [],
          create: (context) => DatabaseService().streamNews(""),
        ),
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => DatabaseService()),
      ],
      child: MaterialApp(
          title: 'Climbing App',
          theme: ThemeData(fontFamily: 'NunitoSans', accentColor: polyGreen),
          home: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
        onWillPop: () => Future.value(false),
        child: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // setupLocator();
              return Consumer<AuthService>(
                builder: (_, auth, __) {
                  if (auth.loggedIn) return NavigationContainer();
                  return StartScreen();
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}
