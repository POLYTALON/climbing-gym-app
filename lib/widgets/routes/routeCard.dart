import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/services/RoutesService.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:transparent_image/transparent_image.dart';

import '../../locator.dart';

class RouteCard extends StatefulWidget {
  final AppRoute route;
  final AppUser appUser;
  RouteCard({AppRoute route, AppUser appUser})
      : this.route = route,
        this.appUser = appUser;

  _RouteCardState createState() => new _RouteCardState(route, appUser);
}

class _RouteCardState extends State<RouteCard> {
  final AppRoute route;
  final AppUser appUser;
  _RouteCardState(this.route, this.appUser);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Constants.polyGray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Image
            Expanded(
                flex: 5,
                child: Stack(children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: route.imageUrls[0],
                        fit: BoxFit.fill),
                  ),
                ])),
            // Title
            Expanded(
                flex: 7,
                child: Column(
                  children: [
                    FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(route.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20)),
                          ),
                        )),
                    FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Text(route.difficulty,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20)),
                          ),
                        )),
                    if (_getIsPrivileged())
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.white,
                            onPressed: onPressEdit,
                          ),
                        ],
                      )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void onPressEdit() {
    locator<RoutesService>().showEdit(this.route);
  }

  /* TODO: get builder */
  bool _getIsPrivileged() {
    if (appUser == null) return false;
    return appUser.isOperator ||
        (appUser.roles[route.id] != null && appUser.roles[route.id].gymuser);
  }
}
