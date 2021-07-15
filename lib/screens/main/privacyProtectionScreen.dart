import 'package:climbing_gym_app/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import '../../locator.dart';

class PrivacyProtectionScreen extends StatefulWidget {
  @override
  _PrivacyProtectionScreenState createState() =>
      _PrivacyProtectionScreenState();
}

class _PrivacyProtectionScreenState extends State<PrivacyProtectionScreen> {
  final authService = locator<AuthService>();

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
                    title: Text("PRIVACY POLICY",
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
                                left: 18.0,
                                right: 18.0,
                                top: 18.0,
                                bottom: 15.0),
                            child: Text("Privacy Policy",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 18.0),
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
                              child: SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.only(
                                            top: 16.0, bottom: 16.0),
                                        child: Text("",
                                            style: Constants.defaultTextWhite))
                                  ])))
                        ])))));
  }
}
