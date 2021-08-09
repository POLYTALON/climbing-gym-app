import 'package:auto_size_text/auto_size_text.dart';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/validators/email_validator.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:climbing_gym_app/validators/password_validator.dart';
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
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Scaffold(
          body: Container(
        color: Constants.polyDark,
        child: Stack(children: <Widget>[
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 64.0, right: 64.0),
              height: constraints.maxHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Spacer(flex: 2),
                  // Polytalon Logo
                  Container(
                      height: 50,
                      child:
                          Image.asset('assets/img/polytalon_logo_notext.png')),

                  // Spacer
                  Spacer(flex: 1),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Text Field Username
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, bottom: 4.0),
                          child: Text("Name:",
                              style: TextStyle(color: Colors.white)),
                        ),
                        TextFormField(
                            controller: controllerDisplayName,
                            autofillHints: [AutofillHints.name],
                            maxLength: Constants.displayNameLength,
                            enabled: !isLoggedIn,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.words,
                            style: TextStyle(fontWeight: FontWeight.w800),
                            // Provides a keyboard optimized for typing in names
                            keyboardType: TextInputType.name,
                            validator: NameFieldValidator.validate,
                            decoration: InputDecoration(
                                counterStyle:
                                    const TextStyle(color: Colors.white),
                                contentPadding:
                                    const EdgeInsets.only(left: 16.0),
                                hintText: 'Max Mustermann',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                    borderSide: BorderSide(
                                        width: 0, style: BorderStyle.none)),
                                fillColor: Colors.white,
                                filled: true)),

                        // Text Field E-Mail
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, bottom: 4.0),
                          child: Text("E-Mail-Address:",
                              style: TextStyle(color: Colors.white)),
                        ),
                        TextFormField(
                            controller: controllerEmail,
                            autofillHints: [
                              AutofillHints.newUsername,
                              AutofillHints.email
                            ],
                            maxLength: Constants.emailLength,
                            enabled: !isLoggedIn,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            style: TextStyle(fontWeight: FontWeight.w800),
                            // it's a text field to type in an email-address, duh!
                            keyboardType: TextInputType.emailAddress,
                            validator: EmailFieldValidator.validate,
                            decoration: InputDecoration(
                                counterStyle:
                                    const TextStyle(color: Colors.white),
                                contentPadding:
                                    const EdgeInsets.only(left: 16.0),
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
                            maxLength: Constants.passwordLength,
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
                                counterStyle:
                                    const TextStyle(color: Colors.white),
                                contentPadding:
                                    const EdgeInsets.only(left: 16.0),
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
                            maxLength: Constants.passwordLength,
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
                                counterStyle:
                                    const TextStyle(color: Colors.white),
                                contentPadding:
                                    const EdgeInsets.only(left: 16.0),
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
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Constants.polyGreen),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                        )),
                    onPressed: isLoggedIn && isChecked
                        ? null
                        : () => doUserRegistration(),
                    child: Text("Register",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w900)),
                  ),

                  // Text Privat policy
                  FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Row(children: [
                            AutoSizeText("I have read and accepted the ",
                                style: Constants.defaultTextWhite, maxLines: 1),
                            TextButton(
                                onPressed: () => launch(
                                    "https://polytalon.com/datenschutz-grip-guide/"),
                                child: AutoSizeText(
                                    "Terms of Use and Privacy Policy",
                                    style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline),
                                    maxLines: 1))
                          ]))),

                  // Spacer
                  Spacer(flex: 1)
                ],
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 48.0, 0.0, 16.0),
                // back button
                child: RawMaterialButton(
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (countext) => LoginScreen()))
                        },
                    elevation: 2.0,
                    fillColor: Colors.grey,
                    child: Icon(Icons.arrow_back_rounded, size: 32.0),
                    padding: EdgeInsets.all(8.0),
                    shape: CircleBorder()),
              )
            ]),
          ),
        ]),
      ));
    });
  }

  void doUserRegistration() async {
    final String displayName = controllerDisplayName.text.trim();
    final String email = controllerEmail.text.trim().toLowerCase();
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
            _errorMessage = e.message;
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
