import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/RouteColor.dart';
import 'package:climbing_gym_app/services/routeColorService.dart';
import 'package:climbing_gym_app/services/routesService.dart';
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
  AppRoute route;
  AppUser appUser;
  _RouteCardState(this.route, this.appUser);
  final routeColorService = locator<RouteColorService>();

  @override
  void didUpdateWidget(RouteCard oldWidget) {
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
        padding: const EdgeInsets.all(8),
        child: Card(
          clipBehavior: Clip.antiAlias,
          color: Constants.polyGray,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
          child: FutureBuilder<List<RouteColor>>(
              future: routeColorService.getAvailableRouteColors(),
              builder: (context, routeColorSnapshot) {
                if (!routeColorSnapshot.hasData) {
                  return Container(width: 0.0, height: 0.0);
                }
                return Column(
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
                                image: route.imageUrl,
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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(route.name,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20)),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 0.0, 8.0, 0.0),
                                  child: Row(children: [
                                    Text('Level: ',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20)),
                                    Icon(Icons.circle,
                                        color: Color(routeColorSnapshot.data
                                            .firstWhere((routeColor) =>
                                                routeColor.color ==
                                                route.difficulty)
                                            .colorCode),
                                        size: 24)
                                  ])),
                            ),
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
                );
              }),
        ));
  }

  void onPressEdit() {
    locator<RoutesService>().showEdit(this.route);
  }

  void onPressDelete() {
    final routesService = locator<RoutesService>();
    if (this.mounted) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Delete Route',
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Would you like to delete this route?',
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("No")),
              TextButton(
                  onPressed: () async {
                    routesService.deleteRoute(this.route.id);
                    Navigator.of(context).pop();
                  },
                  child: Text("Yes")),
            ],
          );
        },
      );
    }
  }

  bool _getIsPrivileged() {
    if (appUser == null) return false;
    return (appUser.roles[appUser.selectedGym] != null &&
        (appUser.roles[appUser.selectedGym].gymuser ||
            appUser.roles[appUser.selectedGym].builder));
  }
}
