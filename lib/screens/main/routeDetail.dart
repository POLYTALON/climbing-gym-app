import 'dart:async';

import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:climbing_gym_app/services/routeColorService.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RouteDetailScreen extends StatefulWidget {
  final AppRoute route;
  RouteDetailScreen({
    Key key,
    AppRoute route,
  }) : route = route;

  @override
  _RouteDetailScreenState createState() => new _RouteDetailScreenState(route);
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  _RouteDetailScreenState(this.route);

  final routeColorService = locator<RouteColorService>();

  final AppRoute route;

/*
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(),
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(64.0),
                child: AppBar(
                  brightness: Brightness.dark,
                  backgroundColor: Constants.polyDark,
                  //automaticallyImplyLeading: false, // removes back-arrow
                  actions: [
                    IconButton(
                      icon: Image.asset('assets/img/polytalon_logo_notext.png'),
                      onPressed: () {},
                    )
                  ],
                  title: Text("ROUTE",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                )),
            body: Container(child: Text(this.route.toString()))));
  }
  */

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
                      child: Image.network(
                          //'https://www.bda-bund.de/wp-content/uploads/2018/06/1371_Bild_2-1280x720.jpg'),
                          this.route.imageUrl,
                          fit: BoxFit.cover),
                    ),
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
                      padding: EdgeInsets.all(16),
                      color: Constants.polyDark,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Setter: Nils",
                              style: Constants.defaultTextWhite),
                          Row(
                            children: [
                              Text("Date: ", style: Constants.defaultTextWhite),
                              Text(
                                  DateFormat('dd.MM.yyyy')
                                      .format(this.route.date),
                                  style: Constants.defaultTextWhite),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      color: Constants.polyGray,
                      child: Column(
                        children: [
                          SizedBox(height: 25),
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
                                Text("Rating",
                                    style: Constants.defaultTextWhite),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.yellow),
                                    Icon(Icons.star, color: Colors.yellow),
                                    Icon(Icons.star, color: Colors.yellow),
                                    Icon(Icons.star_outline),
                                    Icon(Icons.star_outline)
                                  ],
                                )
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
                          Divider(color: Constants.lightGray, height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Attempts",
                                  style: Constants.defaultTextWhite),
                              Text("18", style: Constants.defaultTextWhite)
                            ],
                          ),
                          Divider(color: Constants.lightGray, height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Status", style: Constants.defaultTextWhite),
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text("done",
                                      style: Constants.defaultTextWhite),
                                ),
                                Icon(Icons.check, color: Constants.polyGreen)
                              ])
                            ],
                          )
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
}
