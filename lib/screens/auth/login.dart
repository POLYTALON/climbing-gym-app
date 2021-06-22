import 'package:climbing_gym_app/screens/auth/passwordReset.dart';
import 'package:climbing_gym_app/screens/auth/register.dart';
import 'package:climbing_gym_app/screens/start.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/validators/email_validator.dart';
import 'package:climbing_gym_app/validators/password_validator.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:climbing_gym_app/locator.dart';

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
          child: Stack(children: [
            Container(
              child: Positioned(
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
                                      builder: (countext) => StartScreen()))
                            },
                        elevation: 2.0,
                        fillColor: Colors.grey,
                        child: Icon(Icons.arrow_back_rounded, size: 32.0),
                        padding: EdgeInsets.all(8.0),
                        shape: CircleBorder()),
                  )
                ]),
              ),
            ),
            Container(
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
                            padding:
                                const EdgeInsets.only(left: 16.0, bottom: 4.0),
                            child: Text("E-Mail-Adresse:",
                                style: TextStyle(color: Colors.white)),
                          ),
                          TextFormField(
                              controller: controllerEmail,
                              enabled: !isLoggedIn,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.words,
                              style: TextStyle(fontWeight: FontWeight.w800),
                              // it's a text field to type in an email address, duh!
                              keyboardType: TextInputType.emailAddress,
                              validator: EmailFieldValidator.validate,
                              decoration: InputDecoration(
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
                              enabled: !isLoggedIn,
                              textCapitalization: TextCapitalization.none,
                              style: TextStyle(fontWeight: FontWeight.w800),
                              obscureText: _hidePassword,
                              enableSuggestions: false,
                              autocorrect: false,
                              // it's a text field to type in a password, duh!
                              keyboardType: TextInputType.visiblePassword,
                              validator: PasswordFieldValidator.validate,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(left: 16.0),
                                hintText: '********',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                    borderSide: BorderSide(
                                        width: 0, style: BorderStyle.none)),
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
                                color: Colors.red,
                                fontWeight: FontWeight.w800))),

                    // Spacer
                    Spacer(flex: 1),

                    // Button Login
                    ElevatedButton(
                      style: Constants.polyGreenButton,
                      onPressed: isLoggedIn ? null : () => doUserLogin(),
                      child: Text("SignIn",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900)),
                    ),
                    TextButton(
                      onPressed: navigateToPasswordReset,
                      child: Text(
                        "Forgot your password?",
                        style: TextStyle(
                            color: Colors.blue[400],
                            decoration: TextDecoration.underline),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Spacer
                    Spacer(),

                    // Button Login with Google
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0)),
                          )),
                      onPressed: () => doGoogleLogin(),
                      child: Text("SignIn with Google",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900)),
                    ),

                    // Spacer
                    Spacer(flex: 2),

                    // Register Button
                    Text(
                      "No account yet?",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0)),
                          )),
                      onPressed: () => navigateToRegister(),
                      child: Text("SignUp",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900)),
                    ),

                    // Spacer
                    Spacer(flex: 1),
                  ]),
            ),
          ]),
        ));
  }

  void doUserLogin() async {
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();
    if (_validateAndSave()) {
      try {
        final auth = locator<AuthService>();
        final usercred = await auth.loginUser(email, password);
        //update user.emailVerified status
        await usercred.user.reload();

        if (usercred.user.emailVerified) {
          await Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => MyApp()));
        } else {
          createInvalidVerificationDialog(context, usercred);
          throw FirebaseAuthException(code: 'invalid-email-verified');
        }
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
        } else if (e.code == 'invalid-email-verified') {
          message = 'Email has not been verified yet.';
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
      final auth = locator<AuthService>();
      final usercred = await auth.signInWithGoogle();
      await auth.userSetup(usercred.user.uid.toString());

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

  createInvalidVerificationDialog(
      BuildContext context, UserCredential usercred) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                "Email has not been verified. Please check your spam mailbox.",
                style: TextStyle(color: Colors.white)),
            backgroundColor: Constants.polyDark,
            actions: <Widget>[
              MaterialButton(
                  elevation: 5.0,
                  child: Text('Resend Verification Email',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    usercred.user.sendEmailVerification();
                  }),
              MaterialButton(
                  elevation: 5.0,
                  child: Text('Exit', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pop(context, true);
                  })
            ],
          );
        });
  }
}
