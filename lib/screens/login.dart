import 'package:climbing_gym_app/screens/navigationContainer.dart';
import 'package:flutter/material.dart';

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

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: polyDark,
      child: Container(
        margin: const EdgeInsets.only(left: 64.0, right: 64.0, top: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Polytalon Logo
            Image.asset('assets/img/polytalon_logo.png'),

            // Spacer
            Spacer(flex: 1),

            // Text Field E-Mail
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
              child: Text("E-Mail-Adresse:",
                  style: TextStyle(color: Colors.white)),
            ),
            TextField(
                style: TextStyle(fontWeight: FontWeight.w800),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 16.0),
                    hintText: 'max.mustermann@polytalon.de',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none)),
                    fillColor: Colors.white,
                    filled: true)),

            // Text Field Password
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
              child: Text("Passwort:", style: TextStyle(color: Colors.white)),
            ),
            TextField(
                style: TextStyle(fontWeight: FontWeight.w800),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 16.0),
                    hintText: '********',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide:
                            BorderSide(width: 0, style: BorderStyle.none)),
                    fillColor: Colors.white,
                    filled: true)),

            // Spacer
            Spacer(flex: 1),

            // Button Login
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
                  MaterialPageRoute(
                      builder: (context) => NavigationContainer()),
                );
              },
              child: Text("Anmelden",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900)),
            ),
            Text(
              "Passwort vergessen?",
              style: TextStyle(
                  color: Colors.blue[400],
                  decoration: TextDecoration.underline),
              textAlign: TextAlign.center,
            ),

            // Spacer
            Spacer(),

            // Button Login with Google
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0)),
                  )),
              onPressed: () {},
              child: Text("Mit Google anmelden",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900)),
            ),

            // Spacer
            Spacer(flex: 2),

            // Register Button
            Text(
              "Noch keinen Account?",
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0)),
                  )),
              onPressed: () {},
              child: Text("Registrieren",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }
}
