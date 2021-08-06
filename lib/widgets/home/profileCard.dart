import 'package:auto_size_text/auto_size_text.dart';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/screens/settings/userSettings.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/gymService.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;

class ProfileCard extends StatefulWidget {
  final AppRoute route;
  final AppUser appUser;
  ProfileCard({AppRoute route, AppUser appUser})
      : this.route = route,
        this.appUser = appUser;

  _ProfileCardState createState() => new _ProfileCardState(route, appUser);
}

class _ProfileCardState extends State<ProfileCard> {
  AppRoute route;
  AppUser appUser;
  _ProfileCardState(this.route, this.appUser);

  final gymService = locator<GymService>();
  final authService = locator<AuthService>();

  @override
  void didUpdateWidget(ProfileCard oldWidget) {
    if (route != widget.route || appUser != widget.appUser) {
      setState(() {
        route = widget.route;
        appUser = widget.appUser;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Constants.polyGray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 8, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                          padding: EdgeInsets.only(top: 16),
                          alignment: Alignment.centerLeft,
                          child: CircleAvatar(
                              minRadius: 16.0,
                              maxRadius: 32.0,
                              //backgroundImage: NetworkImage(appUser.imageUrl),
                              child: AutoSizeText(
                                  _getUserInitials(appUser.displayName),
                                  maxLines: 1,
                                  style: Constants.subHeaderTextWhite))),
                    ),
                    Expanded(
                        flex: 7,
                        child: Container(
                          padding: EdgeInsets.only(left: 8, top: 16),
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          AutoSizeText(
                                            appUser.displayName ?? '',
                                            maxLines: 1,
                                            style: Constants.headerTextWhite,
                                            textAlign: TextAlign.left,
                                          ),
                                        ]),
                                    AutoSizeText(
                                      appUser.email ?? '',
                                      maxLines: 1,
                                      style: Constants.smallTextWhite600,
                                      textAlign: TextAlign.left,
                                    ),
                                    AutoSizeText(
                                      'Registered since: ' +
                                              authService
                                                  .getRegistrationDateFormatted() ??
                                          '',
                                      maxLines: 1,
                                      style: Constants.smallTextWhite600,
                                      textAlign: TextAlign.left,
                                    ),
                                  ])),
                        )),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(top: 8),
                        child: RawMaterialButton(
                            onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UserSettingsScreen()),
                                  )
                                },
                            elevation: 2.0,
                            child: Icon(
                              Icons.settings_rounded,
                              size: 30,
                              color: Colors.grey,
                            ),
                            shape: CircleBorder()),
                      ),
                    ),
                  ]),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  children: <Widget>[
                    Divider(
                      color: Colors.white24,
                      thickness: 2,
                      height: 20,
                    ),
                    Row(children: <Widget>[
                      Expanded(
                          flex: 3,
                          child: AutoSizeText(
                            'Gym:',
                            maxLines: 1,
                            style: Constants.headerTextWhite,
                            textAlign: TextAlign.left,
                          )),
                      Expanded(
                          flex: 7,
                          child: FutureBuilder<String>(
                              future: _getGymNameById(appUser.selectedGym),
                              builder: (context, gymSnapshot) {
                                return AutoSizeText(
                                  gymSnapshot.data ?? '',
                                  maxLines: 1,
                                  style: Constants.headerTextWhite,
                                  textAlign: TextAlign.right,
                                );
                              })),
                    ]),
                    if (_getPrivileges(appUser))
                      Divider(
                        color: Colors.white24,
                        thickness: 2,
                        height: 20,
                      ),
                    if (_getPrivileges(appUser))
                      Row(children: <Widget>[
                        Expanded(
                            flex: 3,
                            child: AutoSizeText(
                              'Permission:',
                              maxLines: 1,
                              style: Constants.headerTextWhite,
                              textAlign: TextAlign.left,
                            )),
                        Expanded(
                            flex: 7,
                            child: AutoSizeText(
                              _getUserRoleForCurrentGym(appUser) ?? '',
                              maxLines: 1,
                              style: Constants.headerTextWhite,
                              textAlign: TextAlign.right,
                            ))
                      ])
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool _getPrivileges(AppUser user) {
    if (user == null) return false;
    if (user.isOperator) return true;
    if (user.roles == null || user.roles[user.selectedGym] == null)
      return false;
    if (user.roles[user.selectedGym].gymuser) return true;
    if (user.roles[user.selectedGym].builder) return true;
    return false;
  }

  String _getUserInitials(String displayName) {
    String initials = '';
    displayName.split(' ').forEach((substr) {
      if (substr.length > 0) {
        initials += substr[0].toUpperCase();
      }
    });
    return initials;
  }

  Future<String> _getGymNameById(String gymId) async {
    return gymService.getGymNameById(gymId);
  }

  String _getUserRoleForCurrentGym(AppUser user) {
    if (user.isOperator) return 'Operator';
    if (user == null ||
        user.roles == null ||
        user.roles[user.selectedGym] == null) return '';
    if (user.roles[user.selectedGym].gymuser) return 'Gym Owner';
    if (user.roles[user.selectedGym].builder) return 'Setter';
    return '';
  }
}
