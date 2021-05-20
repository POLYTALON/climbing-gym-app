import 'package:climbing_gym_app/screens/auth/passwordReset.dart';
import 'package:climbing_gym_app/screens/auth/register.dart';
import 'package:climbing_gym_app/screens/start.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/databaseService.dart';
import 'package:climbing_gym_app/validators/email_validator.dart';
import 'package:climbing_gym_app/validators/password_validator.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controllerEmail = TextEditingController(text: "");
  final controllerPassword = TextEditingController(text: "");
  String _errorMessage = "";
  bool isLoggedIn = false;
  bool _hidePassword = true;

  void _toggleHidePassword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

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
                  // Text Field Email-Address
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                    child: Text("E-Mail-Adresse:",
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextFormField(
                      controller: controllerEmail,
                      enabled: !isLoggedIn,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
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
                      obscureText: _hidePassword,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.visiblePassword,
                      validator: PasswordFieldValidator.validate,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 16.0),
                        hintText: '********',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none)),
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: IconButton(
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Constants.polyDark,
                            ),
                            onPressed: _toggleHidePassword),
                      )),
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

            // Button Login
            TextButton(
              style: Constants.polyGreenButton,
              onPressed: isLoggedIn ? null : () => doUserLogin(),
              child: Text("Anmelden",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900)),
            ),
            TextButton(
              onPressed: navigateToPasswordReset,
              child: Text(
                "Passwort vergessen?",
                style: TextStyle(
                    color: Colors.blue[400],
                    decoration: TextDecoration.underline),
                textAlign: TextAlign.center,
              ),
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
              onPressed: () => doGoogleLogin(),
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
            Spacer(flex: 1),

            // back button
            RawMaterialButton(
                onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (countext) => StartScreen()))
                    },
                elevation: 2.0,
                fillColor: Colors.grey,
                child: Icon(Icons.arrow_back_rounded, size: 32.0),
                padding: EdgeInsets.all(8.0),
                shape: CircleBorder()),

            // Spacer
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  void doUserLogin() async {
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();
    if (_validateAndSave()) {
      try {
        final auth = Provider.of<AuthService>(context, listen: false);
        await auth.loginUser(email, password);
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => MyApp()));
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
        } else {
          message = 'Something went wrong :(';
        }
        setState(() {
          _errorMessage = message;
        });
      }
    }
  }

  void doGoogleLogin() async {
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final usercred = await auth.signInWithGoogle();
      final db = Provider.of<DatabaseService>(context, listen: false);
      await db.userSetup(usercred.user.uid.toString());

      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MyApp()));
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        message = 'Something went wrong :(';
      }
      setState(() {
        _errorMessage = message;
      });
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

  void navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  void navigateToPasswordReset() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordResetScreen()),
    );
  }
}
