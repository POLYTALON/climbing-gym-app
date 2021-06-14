import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/RouteColor.dart';
import 'package:climbing_gym_app/screens/start.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/gymService.dart';
import 'package:climbing_gym_app/services/routeColorService.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:climbing_gym_app/widgets/routes/home/profileCard.dart';
import 'package:fl_chart/fl_chart.dart';
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
            if (userSnapshot.data.selectedGym == null ||
                userSnapshot.data.selectedGym.isEmpty) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text('Please choose a gym first.',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700))),
                    Icon(Icons.place, color: Colors.white, size: 32.0)
                  ]);
            } else {
              return StreamProvider<List<AppRoute>>.value(
                  initialData: [],
                  value: routesService.streamRoutes(
                      userSnapshot.data.selectedGym,
                      userSnapshot.data.userRoutes),
                  child:
                      Consumer<List<AppRoute>>(builder: (context, routes, _) {
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
                                            } else {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  ProfileCard(
                                                      appUser:
                                                          userSnapshot.data),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(8),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          if (routes.length > 0)
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 16.0,
                                                                      bottom:
                                                                          16),
                                                                  child: Text(
                                                                      'Accomplished routes in the current gym:',
                                                                      style: Constants
                                                                          .subHeaderTextWhite600),
                                                                ),
                                                                LinearPercentIndicator(
                                                                    lineHeight:
                                                                        32.0,
                                                                    percent: _getAccomplishedRoutesRatioInCurrentGym(
                                                                        userSnapshot
                                                                            .data,
                                                                        routes),
                                                                    backgroundColor:
                                                                        Constants
                                                                            .polyGray,
                                                                    progressColor:
                                                                        Constants
                                                                            .polyGreen,
                                                                    animation:
                                                                        true,
                                                                    animationDuration:
                                                                        1000,
                                                                    center: Text(
                                                                        (_getAccomplishedRoutesRatioInCurrentGym(userSnapshot.data, routes) * 100).toStringAsPrecision(3) +
                                                                            '%',
                                                                        style: Constants
                                                                            .defaultTextWhite700)),
                                                                // Currently accomplished routes

                                                                Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top:
                                                                            16.0,
                                                                        bottom:
                                                                            16.0),
                                                                    child: Text(
                                                                        'Currently accomplished routes:',
                                                                        style: Constants
                                                                            .subHeaderTextWhite600)),
                                                                GridView
                                                                    .builder(
                                                                        gridDelegate:
                                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                          crossAxisCount:
                                                                              3,
                                                                          childAspectRatio:
                                                                              1,
                                                                        ),
                                                                        controller:
                                                                            scrollController,
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount: routeAmountColorSnapshot
                                                                            .data
                                                                            .entries
                                                                            .length,
                                                                        itemBuilder:
                                                                            (BuildContext context,
                                                                                int index) {
                                                                          final colorStrings = routeAmountColorSnapshot
                                                                              .data
                                                                              .keys
                                                                              .toList();
                                                                          final amount = routeAmountColorSnapshot
                                                                              .data
                                                                              .values
                                                                              .toList();
                                                                          return Column(children: <
                                                                              Widget>[
                                                                            CircularPercentIndicator(
                                                                                radius: 90.0,
                                                                                backgroundColor: Constants.polyGray,
                                                                                animation: true,
                                                                                animationDuration: 1000,
                                                                                percent: (_getAccomplishedRoutesAmount(userSnapshot.data, colorStrings[index], routes) / amount[index]).clamp(0.0, 1.0).toDouble(),
                                                                                center: Text(_getAccomplishedRoutesAmount(userSnapshot.data, colorStrings[index], routes).toString() + '/' + amount[index].toString(), style: Constants.headerTextWhite),
                                                                                progressColor: _getRouteColor(colorStrings[index], routeColorSnapshot.data)),
                                                                            Text(colorStrings[index],
                                                                                style: Constants.smallTextWhite600),
                                                                          ]);
                                                                        }),
                                                              ],
                                                            ),
                                                          if (_getTotalAccomplishedRouteAmountPerColor(
                                                                  userSnapshot
                                                                      .data)
                                                              .isNotEmpty)
                                                            // All accomplished routes
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            16.0),
                                                                child: Text(
                                                                    'All accomplished routes: ' +
                                                                        _getTotalAccomplishedRoutesAmount(userSnapshot.data)
                                                                            .toString(),
                                                                    style: Constants
                                                                        .subHeaderTextWhite600)),
                                                          if (_getTotalAccomplishedRouteAmountPerColor(
                                                                  userSnapshot
                                                                      .data)
                                                              .isNotEmpty)
                                                            Row(
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                      flex: 5,
                                                                      child: Column(
                                                                          children: <
                                                                              Widget>[
                                                                            SizedBox(
                                                                              height: 230,
                                                                              child:
                                                                                  // Pie chart
                                                                                  PieChart(
                                                                                _getPieChartData(userSnapshot.data, routeColorSnapshot.data),
                                                                                swapAnimationDuration: Duration(milliseconds: 150),
                                                                                swapAnimationCurve: Curves.linear,
                                                                              ),
                                                                            ),
                                                                          ])),
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child: GridView.builder(
                                                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                          crossAxisCount:
                                                                              2,
                                                                          childAspectRatio:
                                                                              1,
                                                                        ),
                                                                        controller: scrollController,
                                                                        shrinkWrap: true,
                                                                        itemCount: _getTotalAccomplishedRouteAmountPerColor(userSnapshot.data).entries.length,
                                                                        itemBuilder: (BuildContext context, int index) {
                                                                          List<MapEntry<String, int>>
                                                                              data =
                                                                              _getTotalAccomplishedRouteAmountPerColor(userSnapshot.data).entries.toList();
                                                                          return Container(
                                                                              child: Row(children: <Widget>[
                                                                            Icon(Icons.circle,
                                                                                color: Color(routeColorSnapshot.data.firstWhere((routeColor) => routeColor.color == data[index].key).colorCode),
                                                                                size: 24),
                                                                            Padding(
                                                                                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                                                                                child: Text(data[index].value.toString(), style: Constants.subHeaderTextWhite600))
                                                                          ]));
                                                                        }),
                                                                  )
                                                                ]),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 16.0,
                                                                    bottom: 16),
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStateProperty.all(Constants
                                                                              .polyRed),
                                                                      shape: MaterialStateProperty
                                                                          .all<
                                                                              RoundedRectangleBorder>(
                                                                        RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(24.0)),
                                                                      )),
                                                              onPressed:
                                                                  () async {
                                                                final auth =
                                                                    locator<
                                                                        AuthService>();
                                                                await auth
                                                                    .logout();
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                StartScreen()));
                                                              },
                                                              child: Text(
                                                                  "Logout",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900)),
                                                            ),
                                                          )
                                                        ]),
                                                  )
                                                ],
                                              );
                                            }
                                          });
                                    }))));
                  }));
            }
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

  double _getAccomplishedRoutesRatioInCurrentGym(
      AppUser user, List<AppRoute> routes) {
    if (routes.isEmpty ||
        user.userRoutes.isEmpty ||
        (routes.isNotEmpty && routes.length <= 0)) return 0.0;
    Map<String, dynamic> gymRoutes = user.userRoutes[user.selectedGym];
    int doneCounter = 0;
    // Black magic. Handle with care. May need to get more efficient.
    if (gymRoutes != null &&
        gymRoutes.entries.isNotEmpty &&
        routes.isNotEmpty) {
      gymRoutes.entries.forEach((entry) {
        if (entry.value['isDone'] != null && entry.value['isDone'])
          routes.forEach((route) {
            if (route.id == entry.key) doneCounter++;
          });
      });
    }
    return doneCounter / routes.length;
  }

  int _getTotalAccomplishedRoutesAmount(AppUser user) {
    MapEntry<String, dynamic> gymRoutes = user.userRoutes.entries.firstWhere(
        (element) => element.key == user.selectedGym,
        orElse: () => null);
    int doneCounter = 0;
    // Black magic. Handle with care. May need to get more efficient.
    if (gymRoutes != null && gymRoutes.value.entries.isNotEmpty) {
      gymRoutes.value.entries.forEach((entry) {
        if (entry.value['isDone'] != null && entry.value['isDone'])
          doneCounter++;
      });
    }
    return doneCounter;
  }

  int _getAccomplishedRoutesAmount(
      AppUser user, String color, List<AppRoute> gymRoutes) {
    Map<String, int> amountPerColor =
        _getTotalAccomplishedCurrentRouteAmountPerColor(user, gymRoutes);
    if (amountPerColor.isNotEmpty && amountPerColor[color] != null) {
      return amountPerColor[color];
    }
    return 0;
  }

  Map<String, int> _getTotalAccomplishedCurrentRouteAmountPerColor(
      AppUser user, List<AppRoute> currentGymRoutes) {
    Map<String, int> result = {};
    Map<String, dynamic> userGymRoutes = user.userRoutes[user.selectedGym];
    if (userGymRoutes != null) {
      userGymRoutes.forEach((routeKey, routeValue) {
        // check if route is currently actvie
        AppRoute currentRoute = currentGymRoutes
            .firstWhere((route) => route.id == routeKey, orElse: () => null);
        if (currentRoute != null) {
          if (routeValue['isDone'] == true) {
            if (result[routeValue['difficulty']] != null) {
              result[routeValue['difficulty']] += 1;
            } else {
              result[routeValue['difficulty']] = 1;
            }
          }
        }
      });
    }
    return result;
  }

  Map<String, int> _getTotalAccomplishedRouteAmountPerColor(AppUser user) {
    Map<String, int> result = {};
    Map<String, dynamic> gymRoutes = user.userRoutes[user.selectedGym];
    if (gymRoutes != null) {
      gymRoutes.forEach((routeKey, routeValue) {
        if (routeValue['isDone'] == true) {
          if (result[routeValue['difficulty']] != null) {
            result[routeValue['difficulty']] += 1;
          } else {
            result[routeValue['difficulty']] = 1;
          }
        }
      });
    }
    return result;
  }

  PieChartData _getPieChartData(
      AppUser user, List<RouteColor> availableColors) {
    Map<String, int> data = _getTotalAccomplishedRouteAmountPerColor(user);
    if (data.isEmpty) {
      return PieChartData(sections: [], centerSpaceRadius: 0.0);
    }
    List<PieChartSectionData> sectionData = [];
    data.entries.forEach((entry) {
      sectionData.add(PieChartSectionData(
        value: entry.value.toDouble(),
        color: Color(availableColors
            .firstWhere((routeColor) => routeColor.color == entry.key)
            .colorCode),
        radius: 80.0,
        showTitle: false,
      ));
    });

    return PieChartData(sections: sectionData, centerSpaceRadius: 0.0);
  }
}
