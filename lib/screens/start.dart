import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'auth/login.dart';
import 'main/gymsPreviewScreen.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Constants.polyDark,
      child: Container(
        margin: const EdgeInsets.only(left: 64.0, right: 64.0, top: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Headline
            Text("Climbing\nApp",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 48)),

            // Spacer
            Spacer(flex: 2),

            // Polytalon Logo
            Image.asset('assets/img/polytalon_logo.png'),

            // Spacer
            Spacer(flex: 2),

            // Buttons
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Constants.polyGreen),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0)),
                  )),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text("SignIn",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900)),
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0)),
                  )),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GymsPreviewScreen()),
                );
              },
              child: Text("Available Gyms",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w900)),
            ),

            // Spacer
            Spacer(flex: 2),

            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade800),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0)),
                  )),
              onPressed: () {},
              child: Text("About Polytalon",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900)),
            ),

            // Spacer
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
