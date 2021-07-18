import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/screens/main/privacyProtectionScreen.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'changePasswordScreen.dart';
import 'deleteAccountScreen.dart';

class Content extends StatefulWidget {
  const Content({
    this.title,
    this.screenPage,
    this.disabled = false,
  });

  final String title;
  final Widget screenPage;
  final bool disabled;

  @override
  _ContentState createState() => _ContentState(disabled);
}

class _ContentState extends State<Content> {
  _ContentState(this.disabled);
  final bool disabled;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!this.disabled) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widget.screenPage),
            );
          }
        },
        child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            decoration: BoxDecoration(
                color: Constants.polyGray,
                border: Border(
                    bottom: BorderSide(color: Colors.white38, width: 0.5))),
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 15.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(widget.title,
                            style: this.disabled
                                ? TextStyle(
                                    color: Colors.white30,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)
                                : Constants.defaultTextWhite700),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: InkWell(
                      child: Icon(
                        Icons.chevron_right,
                        size: 25.0,
                        color: this.disabled ? Colors.white30 : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}

class UserSettingsScreen extends StatefulWidget {
  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final _auth = locator<AuthService>();
  @override
  Widget build(BuildContext context) {
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
                    icon: Image.asset('assets/img/polytalon_logo_notext.png'),
                    onPressed: () {},
                  )
                ],
                title: Text("SETTINGS",
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(2.0),
                  child: Container(
                    color: Colors.white38,
                    height: 2.0,
                    margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                  ),
                ))),
        body: ListView(
          padding: EdgeInsets.only(top: 32.0),
          children: [
            Content(
                title: 'Change password',
                screenPage: ChangePasswordScreen(),
                disabled: !getIsFirebaseProvider()),
            Content(title: 'Delete account', screenPage: DeleteAccountScreen()),
            Divider(height: 24.0),
            Content(
                title: 'Privacy Policy', screenPage: PrivacyProtectionScreen())
          ],
        ));
  }

  bool getIsFirebaseProvider() {
    return this._auth.isFirebaseProvider();
  }
}
