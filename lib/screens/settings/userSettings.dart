import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/screens/settings/authorizeOperatorScreen.dart';
import 'package:climbing_gym_app/screens/settings/legalNotesScreen.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:url_launcher/url_launcher.dart';
import '../start.dart';
import 'changePasswordScreen.dart';
import 'deleteAccountScreen.dart';

class Content extends StatelessWidget {
  const Content(
      {this.title,
      this.screenPage,
      this.disabled = false,
      this.fontColor = Colors.white,
      this.overrideOnTap});

  final String title;
  final Widget screenPage;
  final bool disabled;
  final Color fontColor;
  final Function overrideOnTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (overrideOnTap == null) {
            if (!this.disabled) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screenPage),
              );
            }
          } else {
            overrideOnTap();
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
                        Text(title,
                            style: this.disabled
                                ? TextStyle(
                                    color: Colors.white30,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)
                                : TextStyle(
                                    color: this.fontColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)),
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
        body: Column(children: <Widget>[
          Flexible(
              child: ListView(
                  shrinkWrap: false,
                  padding: EdgeInsets.only(top: 32.0),
                  children: [
                Content(
                    title: 'Change password',
                    screenPage: ChangePasswordScreen(),
                    disabled: !getIsFirebaseProvider()),
                FutureBuilder(
                    future: this._auth.getIsOperator(),
                    initialData: false,
                    builder: (context, operatorSnapshot) {
                      if (!operatorSnapshot.hasData || !operatorSnapshot.data) {
                        return Container();
                      } else {
                        return Content(
                            title: 'Manage Operators',
                            screenPage: AuthorizeOperatorScreen(),
                            fontColor: Colors.greenAccent,
                            disabled: !operatorSnapshot.data);
                      }
                    }),
                Divider(height: 24.0),
                Content(
                  title: 'Logout',
                  screenPage: Container(),
                  fontColor: Colors.redAccent,
                  overrideOnTap: () async {
                    final auth = locator<AuthService>();
                    await auth.logout();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => StartScreen()));
                  },
                ),
                Divider(height: 48.0),
                Content(
                    title: 'License',
                    screenPage: Container(),
                    overrideOnTap: () async {
                      launch(
                          "https://github.com/POLYTALON/climbing-gym-app/blob/main/LICENSE");
                    }),
                Content(
                    title: 'Legal Notes',
                    screenPage: Container(),
                    fontColor: Colors.white,
                    overrideOnTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LegalNotesScreen()));
                    }),
                Content(
                    title: 'Privacy Policy',
                    screenPage: Container(),
                    overrideOnTap: () async {
                      launch("https://polytalon.com/datenschutz-grip-guide/");
                    }),
                Content(
                    title: 'Impress',
                    screenPage: Container(),
                    overrideOnTap: () async {
                      launch("https://polytalon.com/impressum/");
                    }),
              ])),
          Content(
            title: 'Delete account',
            screenPage: DeleteAccountScreen(),
            fontColor: Colors.redAccent,
          ),
          Padding(padding: EdgeInsets.only(bottom: 48.0))
        ]));
  }

  bool getIsFirebaseProvider() {
    return this._auth.isFirebaseProvider();
  }
}
