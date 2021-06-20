import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/RouteColor.dart';
import 'package:climbing_gym_app/services/routeColorService.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/widgets/routes/routeAddPanel.dart';
import 'package:climbing_gym_app/widgets/routes/routeCard.dart';
import 'package:climbing_gym_app/widgets/routes/routeEditPanel.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class RoutesScreen extends StatefulWidget {
  @override
  _RoutesScreenState createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  final PanelController _routesAddPanelController = PanelController();
  final routesService = locator<RoutesService>();
  final routeColorService = locator<RouteColorService>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  String _sortFilter = 'Date descending';
  List<RouteColor> _routeColorFilter = [];
  String _categoryFilter = 'All';
  int _routeStateFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = locator<AuthService>();
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return StreamBuilder<AppUser>(
        stream: auth.streamAppUser(),
        initialData: new AppUser().empty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active ||
              !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data.selectedGym == null ||
                snapshot.data.selectedGym.isEmpty) {
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
                      snapshot.data.selectedGym, snapshot.data.userRoutes),
                  child:
                      Consumer<List<AppRoute>>(builder: (context, routes, _) {
                    return FutureBuilder<List<RouteColor>>(
                        future: routeColorService.getAvailableRouteColors(),
                        initialData: [],
                        builder: (context, routeColorSnapshot) {
                          if (!routeColorSnapshot.hasData) {
                            return Container(width: 0.0, height: 0.0);
                          } else {
                            return ChangeNotifierProvider<RoutesService>(
                                create: (_) => RoutesService(),
                                child: Stack(children: <Widget>[
                                  Scaffold(
                                      key: _scaffoldKey,
                                      // Add route button
                                      floatingActionButton:
                                          _getFloatingActionButton(
                                              snapshot.data),
                                      backgroundColor: Constants.polyDark,
                                      endDrawer: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16.0),
                                              bottomLeft:
                                                  Radius.circular(16.0)),
                                          child: Drawer(
                                              elevation: 2.0,
                                              child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      16.0, 8.0, 16.0, 8.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  16.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  16.0)),
                                                      color:
                                                          Constants.polyGray),
                                                  child: Column(
                                                      children: <Widget>[
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Container(),
                                                                Text(
                                                                  "Filter",
                                                                  style: Constants
                                                                      .subHeaderTextWhite,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                IconButton(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .close,
                                                                        size:
                                                                            32.0),
                                                                    color: Colors
                                                                        .white,
                                                                    onPressed: () =>
                                                                        closeDrawer()),
                                                              ],
                                                            )),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                // Sort
                                                                Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                  Text("Sort",
                                                                      style: Constants
                                                                          .subHeaderTextWhite),
                                                                  // Dropdown Sorting
                                                                  StatefulBuilder(builder: (BuildContext
                                                                          context,
                                                                      StateSetter
                                                                          setState) {
                                                                    return DropdownButton<
                                                                            String>(
                                                                        value:
                                                                            _sortFilter,
                                                                        dropdownColor:
                                                                            Constants
                                                                                .polyDark,
                                                                        underline: Container(
                                                                            width:
                                                                                0.0,
                                                                            height:
                                                                                0.0),
                                                                        style: Constants
                                                                            .defaultTextWhite,
                                                                        items: <
                                                                            String>[
                                                                          'Date ascending',
                                                                          'Date descending',
                                                                          'Rating ascending',
                                                                          'Rating descending'
                                                                        ].map((String
                                                                            value) {
                                                                          return DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                                value,
                                                                            child:
                                                                                new Text(
                                                                              value,
                                                                              style: Constants.defaultTextWhite,
                                                                            ),
                                                                          );
                                                                        }).toList(),
                                                                        onChanged:
                                                                            (String
                                                                                newValue) {
                                                                          setState(
                                                                              () {
                                                                            _sortFilter =
                                                                                newValue;
                                                                          });
                                                                        });
                                                                  })
                                                                ])),

                                                        Divider(
                                                          color: Colors.white24,
                                                          thickness: 2,
                                                          height: 20,
                                                        ),
                                                        // Category
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      "Category",
                                                                      style: Constants
                                                                          .subHeaderTextWhite),
                                                                  Container(),

                                                                  // Dropdown Categories
                                                                  StatefulBuilder(builder: (BuildContext
                                                                          context,
                                                                      StateSetter
                                                                          setState) {
                                                                    return DropdownButton<
                                                                            String>(
                                                                        value:
                                                                            _categoryFilter,
                                                                        dropdownColor:
                                                                            Constants
                                                                                .polyDark,
                                                                        underline: Container(
                                                                            width:
                                                                                0.0,
                                                                            height:
                                                                                0.0),
                                                                        style: Constants
                                                                            .defaultTextWhite,
                                                                        items: _getAvailableCategories(routes).map((String
                                                                            value) {
                                                                          return DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                                value,
                                                                            child:
                                                                                new Text(
                                                                              value,
                                                                              style: Constants.defaultTextWhite,
                                                                            ),
                                                                          );
                                                                        }).toList(),
                                                                        onChanged:
                                                                            (String
                                                                                newValue) {
                                                                          setState(
                                                                              () {
                                                                            _categoryFilter =
                                                                                newValue;
                                                                          });
                                                                        });
                                                                  })
                                                                ])),
                                                        Divider(
                                                          color: Colors.white24,
                                                          thickness: 2,
                                                          height: 20,
                                                        ),
                                                        // Difficulty
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text("Difficulty",
                                                                  style: Constants
                                                                      .subHeaderTextWhite),
                                                              ElevatedButton(
                                                                  child: Text(
                                                                      'Colors'),
                                                                  onPressed:
                                                                      () async {
                                                                    await showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (_) {
                                                                          return MultiSelectDialog(
                                                                              backgroundColor: Constants.polyGray,
                                                                              itemsTextStyle: Constants.defaultTextBlack700,
                                                                              selectedItemsTextStyle: Constants.defaultTextWhite900,
                                                                              searchTextStyle: Constants.defaultTextWhite700,
                                                                              searchHintStyle: Constants.defaultTextWhite,
                                                                              closeSearchIcon: Icon(
                                                                                Icons.close,
                                                                                color: Colors.white,
                                                                              ),
                                                                              searchIcon: Icon(Icons.search, color: Colors.white),
                                                                              cancelText: Text('Cancel', style: Constants.defaultTextWhite),
                                                                              confirmText: Text('Confirm', style: Constants.defaultTextWhite),
                                                                              title: Text('Route Colors', style: Constants.defaultTextWhite),
                                                                              initialValue: _routeColorFilter,
                                                                              items: routeColorSnapshot.data.map((e) => MultiSelectItem(e, e.color)).toList(),
                                                                              colorator: (item) {
                                                                                return Color((item as RouteColor).colorCode);
                                                                              },
                                                                              listType: MultiSelectListType.CHIP,
                                                                              onConfirm: ((values) {
                                                                                _routeColorFilter = values;
                                                                              }));
                                                                        });
                                                                  })
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.white24,
                                                          thickness: 2,
                                                          height: 20,
                                                        ),
                                                        // Toggle Switch
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                    8.0),
                                                            child: ToggleSwitch(
                                                                initialLabelIndex:
                                                                    _routeStateFilterIndex,
                                                                totalSwitches:
                                                                    3,
                                                                labels: [
                                                                  'Open',
                                                                  'Tried',
                                                                  'Done'
                                                                ],
                                                                activeBgColors: [
                                                                  [
                                                                    Colors
                                                                        .lightBlueAccent
                                                                  ],
                                                                  [
                                                                    Colors
                                                                        .orangeAccent
                                                                  ],
                                                                  [
                                                                    Constants
                                                                        .polyGreen
                                                                  ]
                                                                ],
                                                                inactiveBgColor:
                                                                    Constants
                                                                        .lightGray,
                                                                activeFgColor:
                                                                    Colors
                                                                        .white,
                                                                inactiveFgColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 12.0,
                                                                radiusStyle:
                                                                    true,
                                                                animate: true,
                                                                curve:
                                                                    Curves.ease,
                                                                onToggle:
                                                                    (index) {
                                                                  _routeStateFilterIndex =
                                                                      index;
                                                                })),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 32.0),
                                                            child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: <
                                                                    Widget>[
                                                                  RawMaterialButton(
                                                                    onPressed: () =>
                                                                        setState(
                                                                            () {}),
                                                                    elevation:
                                                                        2.0,
                                                                    fillColor:
                                                                        Constants
                                                                            .polyGreen,
                                                                    child: Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: Colors
                                                                          .white,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            15.0),
                                                                    shape:
                                                                        CircleBorder(),
                                                                  ),
                                                                  RawMaterialButton(
                                                                    onPressed: () =>
                                                                        _resetFilters(),
                                                                    elevation:
                                                                        2.0,
                                                                    fillColor:
                                                                        Constants
                                                                            .polyRed,
                                                                    child: Icon(
                                                                      Icons
                                                                          .undo,
                                                                      color: Colors
                                                                          .white,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            15.0),
                                                                    shape:
                                                                        CircleBorder(),
                                                                  )
                                                                ]))
                                                      ])))),

                                      // Page content
                                      body: Container(
                                          child: Column(children: [
                                        // filter button
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8.0),
                                                child: IconButton(
                                                    icon: Icon(
                                                        Icons
                                                            .filter_list_rounded,
                                                        size: 32.0),
                                                    color: Colors.white,
                                                    onPressed: () =>
                                                        openDrawer()),
                                              )
                                            ]),
                                        // Grid view (with RouteCards)
                                        Expanded(
                                          child: StreamBuilder<List<AppRoute>>(
                                              stream: locator<RoutesService>()
                                                  .streamRoutes(
                                                      snapshot.data.selectedGym,
                                                      snapshot.data.userRoutes),
                                              builder:
                                                  (context, routesSnapshot) {
                                                if (snapshot.connectionState !=
                                                        ConnectionState
                                                            .active ||
                                                    !routesSnapshot.hasData) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else {
                                                  if (routesSnapshot
                                                          .data.length <
                                                      1) {
                                                    return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          FittedBox(
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                              child: Text(
                                                                  'There are no routes for this gym yet.',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700))),
                                                          Icon(
                                                              Icons
                                                                  .mood_bad_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 32.0)
                                                        ]);
                                                  } else {
                                                    List<AppRoute>
                                                        filteredRoutes =
                                                        _applyRouteFilters(
                                                            routes,
                                                            snapshot.data);
                                                    return GridView.builder(
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          childAspectRatio:
                                                              (itemWidth /
                                                                  itemHeight),
                                                        ),
                                                        itemCount:
                                                            filteredRoutes
                                                                .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Container(
                                                              child: RouteCard(
                                                                  route:
                                                                      filteredRoutes[
                                                                          index],
                                                                  appUser:
                                                                      snapshot
                                                                          .data));
                                                        });
                                                  }
                                                }
                                              }),
                                        )
                                      ]))),
                                  if (_getPrivileges(snapshot.data))
                                    RouteAddPanel(
                                        appUser: snapshot.data,
                                        panelController:
                                            _routesAddPanelController),
                                  if (_getPrivileges(snapshot.data))
                                    RouteEditPanel()
                                ]));
                          }
                        });
                  }));
            }
          }
        });
  }

  void toggleSlidingPanel() {
    if (_routesAddPanelController.isPanelOpen) {
      _routesAddPanelController.close();
    } else {
      _routesAddPanelController.open();
    }
  }

  Widget _getFloatingActionButton(AppUser user) {
    if (_getPrivileges(user)) {
      return FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Constants.polyGreen,
        onPressed: () => toggleSlidingPanel(),
      );
    }
    return Container(width: 0.0, height: 0.0);
  }

  bool _getPrivileges(AppUser user) {
    return user.roles[user.selectedGym] != null &&
        (user.roles[user.selectedGym].builder ||
            user.roles[user.selectedGym].gymuser);
  }

  void openDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
  }

  void closeDrawer() {
    Navigator.pop(context);
  }

  List<String> _getAvailableCategories(List<AppRoute> routes) {
    List<String> result = [];
    if (routes.isNotEmpty) result.add('All');
    result.addAll(routes.map((route) => route.type).toSet().toList());
    return result;
  }

  List<AppRoute> _filterRoutesByColor(List<AppRoute> routes) {
    List<AppRoute> result = [];
    if (_routeColorFilter.isNotEmpty) {
      routes.forEach((route) {
        _routeColorFilter.forEach((color) {
          if (route.difficulty == color.color) {
            result.add(route);
          }
        });
      });
      return result;
    }
    return routes;
  }

  List<AppRoute> _filterRoutesByCategory(List<AppRoute> routes) {
    if (_categoryFilter == 'All') {
      return routes;
    }
    return routes.where((route) => route.type == _categoryFilter).toList();
  }

  List<AppRoute> _filterRoutesByState(List<AppRoute> routes, AppUser user) {
    switch (_routeStateFilterIndex) {
      case 1:
        return routes.where((route) => route.isTried).toList();
      case 2:
        return routes.where((route) => route.isDone).toList();
      case 0:
        return routes
            .where((route) => !route.isDone)
            .where((route) => !route.isTried)
            .toList();

      default:
        return [];
    }
  }

  List<AppRoute> _sortRoutes(List<AppRoute> routes) {
    switch (_sortFilter) {
      case 'Date ascending':
        routes.sort((a, b) => a.date.compareTo(b.date));
        break;

      case 'Date descending':
        routes.sort((a, b) => b.date.compareTo(a.date));
        break;

      case 'Rating ascending':
        routes.sort((a, b) => a.rating.compareTo(b.rating));
        break;

      case 'Rating descending':
        routes.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return routes;
  }

  List<AppRoute> _applyRouteFilters(List<AppRoute> routes, AppUser user) {
    List<AppRoute> result = routes;
    if (routes.isEmpty)
      return [];
    else {
      result = routes;
      result = _filterRoutesByCategory(result);
      result = _filterRoutesByColor(result);
      result = _filterRoutesByState(result, user);
      result = _sortRoutes(result);
      return result;
    }
  }

  void _resetFilters() {
    setState(() {
      _sortFilter = 'Date descending';
      _routeColorFilter = [];
      _categoryFilter = 'All';
      _routeStateFilterIndex = 0;
    });
  }
}
