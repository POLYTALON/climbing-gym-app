import 'package:climbing_gym_app/validators/email_validator.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:climbing_gym_app/validators/password_validator.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'login.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controllerUsername = TextEditingController(text: "");
  final controllerEmail = TextEditingController(text: "");
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

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Text Field Username
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                    child: Text("Benutzername:",
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextFormField(
                      controller: controllerUsername,
                      enabled: !isLoggedIn,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(fontWeight: FontWeight.w800),
                      keyboardType: TextInputType.text,
                      validator: NameFieldValidator.validate,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 16.0),
                          hintText: 'Max Mustermann',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide(
                                  width: 0, style: BorderStyle.none)),
                          fillColor: Colors.white,
                          filled: true)),

                  // Text Field E-Mail
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                    child: Text("E-Mail-Adresse:",
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextFormField(
                      controller: controllerEmail,
                      enabled: !isLoggedIn,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      style: TextStyle(fontWeight: FontWeight.w800),
                      keyboardType: TextInputType.emailAddress,
                      validator: EmailFieldValidator.validate,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 16.0),
                          hintText: 'max.mustermann@polytalon.de',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide(
                                  width: 0, style: BorderStyle.none)),
                          fillColor: Colors.white,
                          filled: true)),

                  // Text Field Password
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 4.0, bottom: 4.0),
                    child: Text("Passwort:",
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextFormField(
                      controller: controllerPassword,
                      enabled: !isLoggedIn,
                      textCapitalization: TextCapitalization.none,
                      style: TextStyle(fontWeight: FontWeight.w800),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      validator: PasswordFieldValidator.validate,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 16.0),
                          hintText: '********',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              borderSide: BorderSide(
                                  width: 0, style: BorderStyle.none)),
                          fillColor: Colors.white,
                          filled: true)),
                ],
              ),
            ),

            // Spacer
            Spacer(flex: 1),

            // Error Message
            Center(
                child: Text(_errorMessage,
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w800))),

            // Spacer
            Spacer(flex: 1),

            // Button Register
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Constants.polyGreen),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0)),
                  )),
              onPressed: isLoggedIn ? null : () => doUserRegistration(),
              child: Text("Registrieren",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900)),
            ),

            // Spacer
            Spacer(),

            // Spacer
            Spacer(flex: 2),

            // Goto Login Button
            Text(
              "Du hast bereits einen Account?",
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
              onPressed: () => navigateToLogin(),
              child: Text("Anmelden",
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

  void doUserRegistration() async {
    final String username = controllerUsername.text.trim();
    final String email = controllerEmail.text.trim();
    final String password = controllerPassword.text.trim();
    final user = ParseUser.createUser(username, password, email);

    if (_validateAndSave()) {
      var response = await user.signUp();

      if (response.success) {
        navigateToLogin();
      } else {
        handleErrorMessage(response);
      }
    }
  }

  bool _validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void handleErrorMessage(ParseResponse response) {
    _errorMessage = response.error.message;
  }

  void navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
