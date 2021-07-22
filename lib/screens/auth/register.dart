import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/validators/email_validator.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:climbing_gym_app/validators/password_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:url_launcher/url_launcher.dart';

import 'login.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controllerDisplayName = TextEditingController(text: "");
  final controllerEmail = TextEditingController(text: "");
  final controllerPassword = TextEditingController(text: "");
  final controllerPasswordRepeat = TextEditingController(text: "");
  String _errorMessage = "";
  bool isLoggedIn = false;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Constants.polyDark,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 64.0, right: 64.0, top: 32),
          height: MediaQuery.of(context).size.height,
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
                      child:
                          Text("Name:", style: TextStyle(color: Colors.white)),
                    ),
                    TextFormField(
                        controller: controllerDisplayName,
                        autofillHints: [AutofillHints.name],
                        enabled: !isLoggedIn,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        style: TextStyle(fontWeight: FontWeight.w800),
                        // Provides a keyboard optimized for typing in names
                        keyboardType: TextInputType.name,
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
                      child: Text("E-Mail-Address:",
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextFormField(
                        controller: controllerEmail,
                        autofillHints: [
                          AutofillHints.newUsername,
                          AutofillHints.email
                        ],
                        enabled: !isLoggedIn,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        style: TextStyle(fontWeight: FontWeight.w800),
                        // it's a text field to type in an email-address, duh!
                        keyboardType: TextInputType.emailAddress,
                        validator: EmailFieldValidator.validate,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 16.0),
                            hintText: 'max.mustermann@polytalon.com',
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
                      child: Text("Password:",
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextFormField(
                        controller: controllerPassword,
                        autofillHints: [AutofillHints.newPassword],
                        enabled: !isLoggedIn,
                        textCapitalization: TextCapitalization.none,
                        style: TextStyle(fontWeight: FontWeight.w800),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        // it's a text field to type in a password, duh!
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

                    // Text Field Password (repeat)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 4.0, bottom: 4.0),
                      child: Text("Repeat password:",
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextFormField(
                        controller: controllerPasswordRepeat,
                        autofillHints: [AutofillHints.newPassword],
                        enabled: !isLoggedIn,
                        textCapitalization: TextCapitalization.none,
                        style: TextStyle(fontWeight: FontWeight.w800),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        // it's a text field to type in a password, duh!
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

              //Text Privat policy
              Center(
                  child: RichText(
                      text: TextSpan(children: [
                TextSpan(
                  text: "I have read and accepted the",
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                    text: " Privacy Policy.",
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launch("https://polytalon.com/datenschutz-grip-guide/");
                      })
              ]))),

              // Button Register
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Constants.polyGreen),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                    )),
                onPressed:
                    isLoggedIn && isChecked ? null : () => doUserRegistration(),
                child: Text("Register",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900)),
              ),

              // Spacer
              Spacer(),

              // Spacer
              Spacer(flex: 2),

              // Goto Login Button
              Text(
                "You are already signed up?",
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                    )),
                onPressed: () => navigateToLogin(),
                child: Text("Sign In",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w900)),
              ),

              // Spacer
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  void doUserRegistration() async {
    final String displayName = controllerDisplayName.text.trim();
    final String email = controllerEmail.text.trim();
    final String password = controllerPassword.text.trim();
    final String passwordRepeat = controllerPasswordRepeat.text.trim();
    if (_validateAndSave()) {
      if (password == passwordRepeat) {
        try {
          final auth = locator<AuthService>();
          final usercred = await auth.register(displayName, email, password);
          await auth.sendVerifyMail(usercred);
          await auth.userSetup(usercred.user.uid.toString());

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,
          );
        } catch (e) {
          setState(() {
            _errorMessage = e.toString();
          });
        }
      } else {
        setState(() {
          _errorMessage = "Die Passwörter stimmen nicht überein!";
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

  void navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
