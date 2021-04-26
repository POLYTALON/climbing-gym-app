import 'package:climbing_gym_app/screens/navigationContainer.dart';
import 'package:climbing_gym_app/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controllerUsername = TextEditingController(text: "");
  final controllerPassword = TextEditingController(text: "");
  String _errorMessage = "";
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Constants.polyDark,
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
              child:
                  Text("Benutzername:", style: TextStyle(color: Colors.white)),
            ),
            TextField(
                controller: controllerUsername,
                enabled: !isLoggedIn,
                autocorrect: false,
                textCapitalization: TextCapitalization.words,
                style: TextStyle(fontWeight: FontWeight.w800),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 16.0),
                    hintText: 'Max Mustermann',
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
                controller: controllerPassword,
                enabled: !isLoggedIn,
                textCapitalization: TextCapitalization.none,
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

            // Error Message
            Center(
                child: Text(_errorMessage,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w800))),

            // Spacer
            Spacer(flex: 1),

            // Button Login
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Constants.polyGreen),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0)),
                  )),
              onPressed: isLoggedIn ? null : () => doUserLogin(),
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
              onPressed: () => navigateToRegister(),
              child: Text("Registrieren",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w900)),
            ),

            // Spacer
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  void doUserLogin() async {
    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();
    final user = ParseUser(username, password, null);

    // TODO: null check for empty input fields
    var response = await user.login();

    if (response.success) {
      navigateToHome();
    } else {
      handleErrorMessage(response);
    }
  }

  void handleErrorMessage(ParseResponse response) {
    _errorMessage = response.error.message;
  }

  void navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => NavigationContainer()),
      (Route<dynamic> route) => false,
    );
  }

  void navigateToRegister() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
