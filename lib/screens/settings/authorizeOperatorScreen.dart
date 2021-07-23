import 'package:auto_size_text/auto_size_text.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/validators/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import '../../locator.dart';

class AuthorizeOperatorScreen extends StatefulWidget {
  @override
  _AuthorizeOperatorScreenState createState() =>
      _AuthorizeOperatorScreenState();
}

class _AuthorizeOperatorScreenState extends State<AuthorizeOperatorScreen> {
  final authService = locator<AuthService>();
  final controllerEmail = TextEditingController(text: "");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _errorMessage = "";
  var _confirmMessage = "";
  final _auth = locator<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Constants.polyDark,
        child: Scaffold(
            // AppBar
            backgroundColor: Constants.polyDark,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(64.0),
                child: AppBar(
                    brightness: Brightness.dark,
                    backgroundColor: Constants.polyDark,
                    actions: [
                      IconButton(
                        icon:
                            Image.asset('assets/img/polytalon_logo_notext.png'),
                        onPressed: () {},
                      )
                    ],
                    title: AutoSizeText("AUTHORIZE OPERATOR",
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w900)),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(2.0),
                      child: Container(
                        color: Colors.white38,
                        height: 2.0,
                        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                      ),
                    ))),
            body: SingleChildScrollView(
                child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Constants.polyGray,
              ),
              margin: const EdgeInsets.only(
                  left: 19.0, right: 19.0, top: 30.0, bottom: 50.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0, right: 18.0, top: 18.0, bottom: 15.0),
                      child: Text("Authorize Operator",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: PreferredSize(
                        preferredSize: Size.fromHeight(2.0),
                        child: Container(
                          color: Colors.white38,
                          height: 1.0,
                          margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                        ),
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                        child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(
                                        top: 16.0, bottom: 16.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                              'Please enter a valid e-mail-address to authorize as operator.',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white,
                                              ),
                                              maxLines: 1),
                                          Divider(
                                            height: 20,
                                          ),
                                          TextFormField(
                                              controller: controllerEmail,
                                              validator:
                                                  EmailFieldValidator.validate,
                                              autocorrect: false,
                                              enableSuggestions: false,
                                              textCapitalization:
                                                  TextCapitalization.none,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800),
                                              // The name keyboard is optimized for names (and phone numbers)
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              // The setter should consist of only one line
                                              maxLines: 1,
                                              decoration: InputDecoration(
                                                hintText: 'E-Mail-Address',
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 16.0),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24.0),
                                                    borderSide: BorderSide(
                                                        width: 0,
                                                        style:
                                                            BorderStyle.none)),
                                                fillColor: Colors.white,
                                                filled: true,
                                              )),
                                        ])),
                                // Error Message
                                Center(
                                    child: Text(_errorMessage,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w800))),
                                // Button Authorize Operator
                                Container(
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Constants.polyGreen),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    24.0)),
                                                  )),
                                              onPressed: () =>
                                                  _onPressAuthorizeOperator(
                                                      true, context),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    "Authorize Operator",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                Container(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, bottom: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Constants.polyRed),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    24.0)),
                                                  )),
                                              onPressed: () =>
                                                  _onPressAuthorizeOperator(
                                                      false, context),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    "Unauthorize Operator",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                // Confirmation Message
                                Center(
                                    child: Text(_confirmMessage,
                                        style: TextStyle(
                                            color: Colors.greenAccent,
                                            fontWeight: FontWeight.w800))),
                                Divider(),
                              ],
                            ))))
                  ]),
            ))));
  }

  void _onPressAuthorizeOperator(bool isAuthorizing, BuildContext context) {
    final email = this.controllerEmail.text.trim();

    if (this._validateAndSave()) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              isAuthorizing ? 'Authorize Operator' : 'Unauthorize Operator',
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  isAuthorizing
                      ? Text(
                          'Are you sure you want to authorize this account as operator?',
                        )
                      : Text(
                          'Are you sure you want to unauthorize this account as operator?',
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
                    var found = isAuthorizing
                        ? await this._auth.setOperator(email)
                        : await this._auth.removeOperator(email);
                    setState(() {
                      this._confirmMessage = found
                          ? (isAuthorizing
                              ? 'Successfully authorized operator.'
                              : 'Successfully unauthorized operator.')
                          : '';
                      this._errorMessage = found ? '' : 'E-Mail not found.';
                    });
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
}
