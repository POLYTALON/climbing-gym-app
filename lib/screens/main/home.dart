import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/RouteColor.dart';
import 'package:climbing_gym_app/screens/start.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/gymService.dart';
import 'package:climbing_gym_app/services/routeColorService.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authService = locator<AuthService>();
  final gymService = locator<GymService>();
  final routesService = locator<RoutesService>();
  final routeColorService = locator<RouteColorService>();

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return StreamBuilder<AppUser>(
        stream: authService.streamAppUser(),
        initialData: new AppUser().empty(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState != ConnectionState.active ||
              !userSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return StreamProvider<List<AppRoute>>.value(
                initialData: [],
                value:
                    routesService.streamRoutes(userSnapshot.data.selectedGym),
                child: Consumer<List<AppRoute>>(builder: (context, routes, _) {
                  return ChangeNotifierProvider<RoutesService>(
                      create: (_) => RoutesService(),
                      child: SingleChildScrollView(
                          controller: scrollController,
                          child: Container(
                              margin: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 32),
                              color: Constants.polyDark,
                              child: FutureBuilder<List<RouteColor>>(
                                  future: routeColorService
                                      .getAvailableRouteColors(),
                                  builder: (context, routeColorSnapshot) {
                                    if (!routeColorSnapshot.hasData) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    return FutureBuilder<Map<String, int>>(
                                        future: _getRouteAmountPerColor(
                                            userSnapshot.data.selectedGym),
                                        builder: (context,
                                            routeAmountColorSnapshot) {
                                          if (!routeAmountColorSnapshot
                                              .hasData) {
                                            return Container(
                                              width: 0.0,
                                              height: 0.0,
                                            );
                                          }
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 16.0, bottom: 16.0),
                                                  child: Text(
                                                      'Accomplished routes in the current gym:',
                                                      style: Constants
                                                          .subHeaderTextWhite600)),
                                              LinearPercentIndicator(
                                                  lineHeight: 24.0,
                                                  percent: 0.5,
                                                  backgroundColor:
                                                      Constants.polyGray,
                                                  progressColor:
                                                      Constants.polyGreen,
                                                  animation: true,
                                                  animationDuration: 1000,
                                                  center: Text('50%',
                                                      style: Constants
                                                          .defaultTextWhite700)),
                                              // Currently accomplished routes
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 16.0, bottom: 16.0),
                                                  child: Text(
                                                      'Currently accomplished routes:',
                                                      style: Constants
                                                          .subHeaderTextWhite600)),
                                              GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    childAspectRatio: 1,
                                                  ),
                                                  controller: scrollController,
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      routeAmountColorSnapshot
                                                          .data.entries.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final colorStrings =
                                                        routeAmountColorSnapshot
                                                            .data.keys
                                                            .toList();
                                                    final amount =
                                                        routeAmountColorSnapshot
                                                            .data.values
                                                            .toList();
                                                    return Column(children: <
                                                        Widget>[
                                                      CircularPercentIndicator(
                                                          radius: 80.0,
                                                          backgroundColor:
                                                              Constants
                                                                  .polyGray,
                                                          animation: true,
                                                          animationDuration:
                                                              1000,
                                                          percent: 0.7,
                                                          center: Text(
                                                              amount[index]
                                                                  .toString(),
                                                              style: Constants
                                                                  .headerTextWhite),
                                                          progressColor:
                                                              _getRouteColor(
                                                                  colorStrings[
                                                                      index],
                                                                  routeColorSnapshot
                                                                      .data)),
                                                      Text(colorStrings[index],
                                                          style: Constants
                                                              .smallTextWhite600)
                                                    ]);
                                                  }),
                                              TextButton(
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
                                                onPressed: () async {
                                                  final auth =
                                                      locator<AuthService>();
                                                  await auth.logout();
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              StartScreen()));
                                                },
                                                child: Text("Logout",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w900)),
                                              )
                                            ],
                                          );
                                        });
                                  }))));
                }));
          }
        });
  }

  Color _getRouteColor(String color, List<RouteColor> availableColors) {
    return Color(availableColors
        .firstWhere((routeColor) => routeColor.color == color)
        .colorCode);
  }

  Future<Map<String, int>> _getRouteAmountPerColor(String gymId) async {
    return await routesService.getRouteAmountPerColor(gymId);
  }
}
