import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/screens/start.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/validators/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controllerEmail = TextEditingController(text: "");
  String _message = "";
  Color _messageColor = Colors.red;

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
                ],
              ),
            ),
            // Spacer
            Spacer(flex: 1),

            // Error Message
            Center(
                child: Text(_message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: _messageColor, fontWeight: FontWeight.w800))),

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
              onPressed: resetPassword,
              child: Text("Reset password",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900)),
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

  void resetPassword() async {
    final email = controllerEmail.text.trim();
    if (_validateAndSave()) {
      try {
        final auth = locator<AuthService>();
        await auth.resetPassword(email);
        controllerEmail.clear();
        setState(() {
          _message =
              'E-Mail zum Zurücksetzen des Passworts wurde erfolgreich gesendet';
          _messageColor = Constants.polyGreen;
        });
      } on FirebaseAuthException catch (e) {
        String message;
        print(e);
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else {
          message = 'Something went wrong :(';
        }
        setState(() {
          _message = message;
          _messageColor = Colors.red;
        });
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
}
