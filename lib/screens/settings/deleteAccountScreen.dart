import 'package:auto_size_text/auto_size_text.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/validators/password_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import '../../locator.dart';
import '../start.dart';

class DeleteAccountScreen extends StatefulWidget {
  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final authService = locator<AuthService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controllerEmail = TextEditingController(text: "");
  final controllerPassword = TextEditingController(text: "");
  bool _hidePassword = true;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Constants.polyDark,
        child: StreamBuilder<AppUser>(
            stream: authService.streamAppUser(),
            initialData: new AppUser().empty(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.active ||
                  !snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(color: Constants.polyGreen),
                );
              } else {
                return Scaffold(
                    // AppBar
                    backgroundColor: Constants.polyDark,
                    appBar: PreferredSize(
                        preferredSize: Size.fromHeight(64.0),
                        child: AppBar(
                            centerTitle: true,
                            brightness: Brightness.dark,
                            backgroundColor: Constants.polyDark,
                            actions: [
                              IconButton(
                                icon: Image.asset(
                                    'assets/img/polytalon_logo_notext.png'),
                                onPressed: () {},
                              )
                            ],
                            title: Text("ACCOUNT",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w900)),
                            bottom: PreferredSize(
                              preferredSize: Size.fromHeight(2.0),
                              child: Container(
                                color: Colors.white38,
                                height: 2.0,
                                margin: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                              ),
                            ))),
                    body: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 19.0, right: 19.0, top: 30.0, bottom: 50.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0,
                                    right: 18.0,
                                    top: 18.0,
                                    bottom: 15.0),
                                child: Text("Delete Account",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, right: 18.0),
                                child: PreferredSize(
                                  preferredSize: Size.fromHeight(2.0),
                                  child: Container(
                                    color: Colors.white38,
                                    height: 1.0,
                                    margin: const EdgeInsets.only(
                                        left: 0.0, right: 0.0),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 16.0, left: 16.0, right: 16.0),
                                  child: Form(
                                      key: _formKey,
                                      child: SingleChildScrollView(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          // Container Delete User Account
                                          Container(
                                              padding: EdgeInsets.only(
                                                  top: 16.0,
                                                  left: 16.0,
                                                  right: 16.0),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    AutoSizeText(
                                                        'Please enter your password to confirm.',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.white,
                                                        ),
                                                        maxLines: 1),
                                                    Divider(
                                                      height: 20,
                                                    ),
                                                    TextFormField(
                                                        controller:
                                                            controllerPassword,
                                                        maxLength: Constants
                                                            .passwordLength,
                                                        validator:
                                                            PasswordFieldValidator
                                                                .validate,
                                                        autocorrect: false,
                                                        obscureText:
                                                            _hidePassword,
                                                        enableSuggestions:
                                                            false,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .none,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                        // The name keyboard is optimized for names (and phone numbers)
                                                        keyboardType:
                                                            TextInputType
                                                                .visiblePassword,
                                                        // The setter should consist of only one line
                                                        maxLines: 1,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: '********',
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 16.0),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24.0),
                                                              borderSide: BorderSide(
                                                                  width: 0,
                                                                  style:
                                                                      BorderStyle
                                                                          .none)),
                                                          fillColor:
                                                              Colors.white,
                                                          filled: true,
                                                          suffixIcon:
                                                              IconButton(
                                                                  icon: Icon(
                                                                    _hidePassword
                                                                        ? Icons
                                                                            .visibility_off
                                                                        : Icons
                                                                            .visibility,
                                                                    color: Constants
                                                                        .polyDark,
                                                                  ),
                                                                  onPressed:
                                                                      _toggleHidePassword),
                                                        )),
                                                  ])),
                                          // Error Message
                                          Center(
                                              child: Text(_errorMessage,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w800))),
                                          // Button Delete User Account
                                          Container(
                                              padding: EdgeInsets.all(16),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Constants
                                                                        .polyRed),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              24.0)),
                                                            )),
                                                        onPressed: () =>
                                                            onPressDeleteUserAccount(
                                                                context),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              "Delete User Account",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      )))),
                            ]),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Constants.polyGray,
                        ),
                      ),
                    ));
              }
            }));
  }

  void onPressDeleteUserAccount(BuildContext context) {
    final id = authService.currentUser.uid;
    final userEmail = authService.currentUser.email;
    final userPassword = controllerPassword.text.trim();

    if (this._validateAndSave()) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Delete Account',
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Are you sure you want to delete your account? This step cannot be undone.',
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  child: Text("No")),
              TextButton(
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    try {
                      bool isUserDeleted = await authService.unregister(
                          id, userEmail, userPassword);
                      if (isUserDeleted) {
                        authService.logout();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => StartScreen()),
                            (Route<dynamic> route) => false);
                      }
                    } on FirebaseAuthException catch (e) {
                      String message;
                      if (e.code == 'wrong-password') {
                        message = 'Wrong password provided for that user.';
                      } else {
                        message = 'Something went wrong :(';
                      }
                      setState(() {
                        this._errorMessage = message;
                      });
                    }
                  },
                  child: Text("Yes")),
            ],
          );
        },
      );
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

  void _toggleHidePassword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }
}
