import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/screens/start.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/validators/password_validator.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import '../../locator.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final authService = locator<AuthService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controllerOldPassword = TextEditingController(text: "");
  final controllerNewPassword = TextEditingController(text: "");
  final controllerConfirmNewPassword = TextEditingController(text: "");
  bool _hideOldPassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmNewPassword = true;
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
                            brightness: Brightness.dark,
                            backgroundColor: Constants.polyDark,
                            actions: [
                              IconButton(
                                icon: Image.asset(
                                    'assets/img/polytalon_logo_notext.png'),
                                onPressed: () {},
                              )
                            ],
                            title: Text("PASSWORD",
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
                                child: Text("Change Password",
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
                                          Container(
                                              padding: EdgeInsets.only(
                                                  top: 16.0, bottom: 16.0),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Old password
                                                    TextFormField(
                                                        controller:
                                                            controllerOldPassword,
                                                        maxLength: Constants
                                                            .passwordLength,
                                                        validator:
                                                            PasswordFieldValidator
                                                                .validate,
                                                        autocorrect: false,
                                                        obscureText:
                                                            _hideOldPassword,
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
                                                          hintText:
                                                              'Old Password',
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
                                                                    _hideOldPassword
                                                                        ? Icons
                                                                            .visibility_off
                                                                        : Icons
                                                                            .visibility,
                                                                    color: Constants
                                                                        .polyDark,
                                                                  ),
                                                                  onPressed:
                                                                      _toggleHideOldPassword),
                                                        )),
                                                    Divider(),
                                                    // New password
                                                    TextFormField(
                                                        controller:
                                                            controllerNewPassword,
                                                        maxLength: Constants
                                                            .passwordLength,
                                                        validator:
                                                            PasswordFieldValidator
                                                                .validate,
                                                        autocorrect: false,
                                                        obscureText:
                                                            _hideNewPassword,
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
                                                          hintText:
                                                              'New Password',
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
                                                                    _hideNewPassword
                                                                        ? Icons
                                                                            .visibility_off
                                                                        : Icons
                                                                            .visibility,
                                                                    color: Constants
                                                                        .polyDark,
                                                                  ),
                                                                  onPressed:
                                                                      _toggleHideNewPassword),
                                                        )),
                                                    Divider(),
                                                    // Confirm New Password
                                                    TextFormField(
                                                        controller:
                                                            controllerConfirmNewPassword,
                                                        maxLength: Constants
                                                            .passwordLength,
                                                        validator:
                                                            PasswordFieldValidator
                                                                .validate,
                                                        autocorrect: false,
                                                        obscureText:
                                                            _hideConfirmNewPassword,
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
                                                          hintText:
                                                              'Confirm New Password',
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
                                                                    _hideConfirmNewPassword
                                                                        ? Icons
                                                                            .visibility_off
                                                                        : Icons
                                                                            .visibility,
                                                                    color: Constants
                                                                        .polyDark,
                                                                  ),
                                                                  onPressed:
                                                                      _toggleHideConfirmNewPassword),
                                                        )),
                                                  ])),
                                          // Error Message
                                          Center(
                                              child: Text(_errorMessage,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w800))),
                                          // Button Change Password
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
                                                                        .polyGreen),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              24.0)),
                                                            )),
                                                        onPressed: () async =>
                                                            _onPressChangePassword(
                                                                context),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              "Change Password",
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

  bool _validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _onPressChangePassword(BuildContext context) async {
    final id = authService.currentUser.uid;
    final oldPassword = controllerOldPassword.text.trim();
    final newPassword = controllerNewPassword.text.trim();
    final confirmNewPassword = controllerConfirmNewPassword.text.trim();

    if (_validateAndSave()) {
      if (newPassword != confirmNewPassword) {
        setState(() {
          this._errorMessage = "Passwords do not match.";
        });
      } else {
        if (oldPassword == newPassword) {
          setState(() {
            this._errorMessage =
                "Your new password is too similar to the old one.";
          });
        } else {
          String msg =
              await this.authService.changePassword(oldPassword, newPassword);
          if (msg == "OK") {
            await authService.logout();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => StartScreen()));
          } else {
            setState(() {
              this._errorMessage = msg;
            });
          }
        }
      }
    }
  }

  void _toggleHideOldPassword() {
    setState(() {
      _hideOldPassword = !_hideOldPassword;
    });
  }

  void _toggleHideNewPassword() {
    setState(() {
      _hideNewPassword = !_hideNewPassword;
    });
  }

  void _toggleHideConfirmNewPassword() {
    setState(() {
      _hideConfirmNewPassword = !_hideConfirmNewPassword;
    });
  }
}
