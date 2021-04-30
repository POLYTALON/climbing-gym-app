import 'package:climbing_gym_app/screens/start.dart';
import 'package:climbing_gym_app/screens/navigationContainer.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // run app
  runApp(
    ChangeNotifierProvider<AuthService>(
      create: (_) => AuthService(),
      child: MaterialApp(
          title: 'Climbing App',
          theme: ThemeData(fontFamily: 'NunitoSans'),
          home: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
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
    );
  }
}
