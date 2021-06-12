import 'dart:async';

import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/routeColorService.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:climbing_gym_app/widgets/routes/ratingBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:toggle_switch/toggle_switch.dart';
import 'package:animated_check/animated_check.dart';

class RouteDetailScreen extends StatefulWidget {
  final AppRoute route;
  RouteDetailScreen({
    Key key,
    AppRoute route,
  }) : route = route;

  @override
  _RouteDetailScreenState createState() => new _RouteDetailScreenState(route);
}

class _RouteDetailScreenState extends State<RouteDetailScreen>
    with SingleTickerProviderStateMixin {
  _RouteDetailScreenState(this.route);

  final routeColorService = locator<RouteColorService>();
  final authService = locator<AuthService>();
  final routesService = locator<RoutesService>();
  final AppRoute route;

  AlertDialog ratingDialog;
  double routeRating;
  int routeRatingCount;
  int myRating;
  int isSelected;
  bool isRatingLoading = true;
  bool isDoneIconVisible = true;

  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _animation = new Tween<double>(begin: 0, end: 1).animate(
        new CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOutCirc));
    getRouteStatus();
    getRouteRating();
    getMyRouteRating();
    super.initState();
  }

  void getRouteStatus() {
    if (route.isDone) {
      _animationController.forward();
      isSelected = 2;
    } else if (route.isTried) {
      isSelected = 1;
    } else {
      isSelected = 0;
    }
  }

  void getRouteRating() async {
    setState(() {
      isRatingLoading = true;
    });
    routesService.getRatingByRouteId(route.id).then((rating) {
      setState(() {
        routeRatingCount = rating[0];
        routeRating = rating[1];
        isRatingLoading = false;
      });
    });
  }

  void getMyRouteRating() async {
    routesService
        .getUserRatingByRouteId(authService.currentUser.uid, route.id)
        .then((rating) {
      if (rating != 0) {
        setState(() {
          myRating = rating;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Image image = new Image.network(this.route.imageUrl);
    Completer<ui.Image> completer = new Completer<ui.Image>();
    image.image
        .resolve(new ImageConfiguration())
        .addListener(new ImageStreamListener((ImageInfo info, bool s) {
      completer.complete(info.image);
    }));
    return FutureBuilder<ui.Image>(
        future: completer.future,
        builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
          if (snapshot.hasData) {
            bool hochkant = snapshot.data.width < snapshot.data.height;

            return Scaffold(
                body: CustomScrollView(slivers: [
              SliverAppBar(
                backgroundColor: Constants.polyDark,
                //pinned: true,
                expandedHeight: MediaQuery.of(context).size.height *
                    (hochkant ? 0.85 : 0.305),
                flexibleSpace: FlexibleSpaceBar(
                  //title: Text("Route"),
                  background: Stack(children: [
                    Container(
                      alignment: Alignment.center,
                      child:
                          Image.network(this.route.imageUrl, fit: BoxFit.cover),
                    ),
                    Align(
                        child: AnimatedCheck(
                      progress: _animation,
                      color: Constants.polyGreen,
                      size: 200,
                    )),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Icon(Icons.arrow_drop_up_outlined,
                            color: Colors.white)),
                  ]),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      color: Constants.polyGray,
                      child: Column(
                        children: [
                          SizedBox(height: 25),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Status",
                                    style: Constants.defaultTextWhite),
                                ToggleSwitch(
                                  initialLabelIndex: isSelected,
                                  inactiveBgColor: Constants.lightGray,
                                  inactiveFgColor: Colors.white,
                                  activeBgColors: [
                                    [Colors.lightBlueAccent],
                                    [Colors.orangeAccent],
                                    [Constants.polyGreen]
                                  ],
                                  activeFgColor: Colors.white,
                                  totalSwitches: 3,
                                  animate: true,
                                  radiusStyle: true,
                                  labels: ['Open', 'Tried', 'Done'],
                                  onToggle: (index) {
                                    isSelected = index;
                                    if (index == 2) {
                                      _animationController.forward();
                                    } else {
                                      _animationController.reset();
                                    }
                                    route.isDone = index == 2;
                                    route.isTried = index == 1;
                                    authService.updateUserRouteStatus(route);
                                  },
                                ),
                              ]),
                          Divider(color: Constants.lightGray, height: 50),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Rating",
                                    style: Constants.defaultTextWhite),
                                isRatingLoading
                                    ? SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator())
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: GestureDetector(
                                                child: myRating == null
                                                    ? Icon(
                                                        Icons.add_circle,
                                                        size: 30,
                                                        color:
                                                            Constants.lightGray,
                                                      )
                                                    : Icon(
                                                        Icons.edit,
                                                        size: 30,
                                                        color:
                                                            Constants.lightGray,
                                                      ),
                                                onTap: () {
                                                  openRatingDialog(context);
                                                }),
                                          ),
                                          PolyRatingBar(
                                              allowHalfRating: true,
                                              onRated: (v) {},
                                              starCount: 5,
                                              rating: routeRating,
                                              size: 30.0,
                                              isReadOnly: true,
                                              activeColor: Colors.orangeAccent,
                                              inactiveColor:
                                                  Constants.lightGray,
                                              borderColor: Colors.black,
                                              spacing: 0.0),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: Text(
                                                  "(" +
                                                      routeRatingCount
                                                          .toString() +
                                                      ")",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Constants
                                                          .lightGray))),
                                        ],
                                      )
                              ]),
                          Divider(color: Constants.lightGray, height: 50),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Difficulty",
                                    style: Constants.defaultTextWhite),
                                FutureBuilder<Color>(
                                    future:
                                        routeColorService.getColorFromString(
                                            this.route.difficulty),
                                    builder: (context, routeColorSnapshot) {
                                      if (!routeColorSnapshot.hasData) {
                                        return CircularProgressIndicator();
                                      }
                                      return Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Text(this.route.difficulty,
                                                style:
                                                    Constants.defaultTextWhite),
                                          ),
                                          Icon(Icons.circle,
                                              color: routeColorSnapshot.data),
                                        ],
                                      );
                                    }),
                              ]),
                          Divider(color: Constants.lightGray, height: 50),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Date", style: Constants.defaultTextWhite),
                                Text(
                                    DateFormat('dd.MM.yyyy')
                                        .format(this.route.date),
                                    style: Constants.defaultTextWhite)
                              ]),
                          Divider(color: Constants.lightGray, height: 50),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Setter",
                                    style: Constants.defaultTextWhite),
                                Text(this.route.builder,
                                    style: Constants.defaultTextWhite)
                              ]),
                          Divider(color: Constants.lightGray, height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Category",
                                  style: Constants.defaultTextWhite),
                              Text(this.route.type,
                                  style: Constants.defaultTextWhite)
                            ],
                          ),
                          Divider(color: Constants.lightGray, height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Holds", style: Constants.defaultTextWhite),
                              Text(this.route.holds,
                                  style: Constants.defaultTextWhite)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]));
          } else {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        });
  }

  void openRatingDialog(BuildContext context) {
    ratingDialog = AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Text(
          "Rate this route",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Center(
              child: PolyRatingBar(
                  allowHalfRating: false,
                  starCount: 5,
                  rating: myRating != null ? myRating.toDouble() : 3.0,
                  size: 40.0,
                  isReadOnly: false,
                  onRated: (rating) {
                    myRating = rating.toInt();
                  },
                  activeColor: Colors.orangeAccent,
                  inactiveColor: Constants.lightGray,
                  borderColor: Colors.black,
                  spacing: 0.0))
        ]),
        actions: [
          TextButton(
            child: Text(
              "Cancel",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              "Submit",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            onPressed: () async {
              await routesService.updateRouteRating(
                  authService.currentUser.uid, route, myRating);
              getRouteRating();
              Navigator.pop(context);
            },
          )
        ]);

    //show the dialog
    showDialog(
      context: context,
      builder: (context) => ratingDialog,
    );
  }
}
