import 'package:flutter/material.dart';

import 'login.dart';

MaterialColor polyGreen = MaterialColor(0x00bb56, const <int, Color>{
  50: Color.fromRGBO(0, 187, 86, .1),
  100: Color.fromRGBO(0, 187, 86, .2),
  200: Color.fromRGBO(0, 187, 86, .3),
  300: Color.fromRGBO(0, 187, 86, .4),
  400: Color.fromRGBO(0, 187, 86, .5),
  500: Color.fromRGBO(0, 187, 86, .6),
  600: Color.fromRGBO(0, 187, 86, .7),
  700: Color.fromRGBO(0, 187, 86, .8),
  800: Color.fromRGBO(0, 187, 86, .9),
  900: Color.fromRGBO(0, 187, 86, 1),
});

const polyDark = Color(0x121212);

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: polyDark,
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
                  backgroundColor: MaterialStateProperty.all(polyGreen[900]),
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
              child: Text("Anmelden",
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
              onPressed: () {},
              child: Text("Verfügbare Hallen",
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
              child: Text("Über Polytalon",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }
}
