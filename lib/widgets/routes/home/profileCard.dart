import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 2,
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                            flex: 3,
                            child: CircleAvatar(
                                minRadius: 16.0,
                                maxRadius: 32.0,
                                //backgroundImage: NetworkImage(appUser.imageUrl),
                                child: Text(
                                    _getUserInitials(appUser.displayName),
                                    style: Constants.subHeaderTextWhite))),
                        Expanded(
                            flex: 7,
                            child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Column(children: <Widget>[
                                  Text(
                                    appUser.displayName ?? '',
                                    style: Constants.headerTextWhite,
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    appUser.email ?? '',
                                    style: Constants.smallTextWhite600,
                                    textAlign: TextAlign.left,
                                  ),
                                ])))
                      ]),
                      Divider(
                        color: Colors.white24,
                        thickness: 2,
                        height: 20,
                      ),
                      Row(children: <Widget>[
                        Expanded(
                            child: Text(
                          'Gym:',
                          style: Constants.headerTextWhite,
                          textAlign: TextAlign.left,
                        )),
                        Expanded(
                            child: FutureBuilder<String>(
                                future: _getGymNameById(appUser.selectedGym),
                                builder: (context, gymSnapshot) {
                                  return Text(
                                    gymSnapshot.data,
                                    style: Constants.headerTextWhite,
                                    textAlign: TextAlign.right,
                                  );
                                })),
                      ])
                    ]))));
  }

  String _getUserInitials(String displayName) {
    String initials = '';
    displayName
        .split(' ')
        .forEach((substr) => initials += substr[0].toUpperCase());
    return initials;
  }

  Future<String> _getGymNameById(String gymId) async {
    return gymService.getGymNameById(gymId);
  }
}
