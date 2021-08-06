import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/RouteColor.dart';
import 'package:climbing_gym_app/widgets/routes/ratingBar.dart';
import 'package:climbing_gym_app/widgets/routes/routeDetail.dart';
import 'package:climbing_gym_app/services/routeColorService.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
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
    return GestureDetector(
      onTap: onPressRoute,
      child: Container(
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
                        flex: 7,
                        child: Stack(children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Hero(
                              tag: route.id,
                              child: CachedNetworkImage(
                                  placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                          color: Constants.polyGreen,
                                        ),
                                      ),
                                  imageUrl: route.imageUrl,
                                  fit: BoxFit.cover),
                            ),
                          ),
                          if (_getIsPrivileged())
                            Align(
                              alignment: Alignment.topRight,
                              child: FittedBox(
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon:
                                              const Icon(Icons.edit, size: 20),
                                          color: Colors.white,
                                          onPressed: onPressEdit,
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                        ])),
                    // Title
                    Expanded(
                        flex: 6,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Center(
                                              child: AutoSizeText(
                                                  truncate(route.type, 15),
                                                  maxLines: 1,
                                                  style: Constants
                                                      .defaultTextWhite),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: PolyRatingBar(
                                                  allowHalfRating: true,
                                                  onRated: (v) {},
                                                  starCount: 5,
                                                  rating: route.rating,
                                                  size: 17.0,
                                                  isReadOnly: true,
                                                  activeColor:
                                                      Colors.orangeAccent,
                                                  inactiveColor:
                                                      Constants.lightGray,
                                                  borderColor: Colors.black,
                                                  spacing: 0.0),
                                            )),
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FutureBuilder<Color>(
                                          future: routeColorService
                                              .getColorFromString(
                                                  this.route.difficulty),
                                          builder:
                                              (context, routeColorSnapshot) {
                                            if (!routeColorSnapshot.hasData) {
                                              return Container();
                                            }
                                            return Expanded(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Icon(Icons.circle,
                                                      size: 20,
                                                      color: routeColorSnapshot
                                                          .data),
                                                ),
                                              ),
                                            );
                                          }),
                                      FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0),
                                            child: route.isDone
                                                ? Row(
                                                    children: [
                                                      Icon(Icons.check_circle,
                                                          size: 20,
                                                          color: Colors.white),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 2.0),
                                                        child: AutoSizeText(
                                                            "Done",
                                                            maxLines: 1,
                                                            style: Constants
                                                                .defaultTextWhite),
                                                      ),
                                                    ],
                                                  )
                                                : route.isTried
                                                    ? Row(
                                                        children: [
                                                          Icon(Icons.pending,
                                                              size: 20,
                                                              color:
                                                                  Colors.white),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 2.0),
                                                            child: AutoSizeText(
                                                                "Tried",
                                                                maxLines: 1,
                                                                style: Constants
                                                                    .defaultTextWhite),
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .circle_outlined,
                                                              size: 20,
                                                              color:
                                                                  Colors.white),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 2.0),
                                                            child: AutoSizeText(
                                                                "Open",
                                                                maxLines: 1,
                                                                style: Constants
                                                                    .defaultTextWhite),
                                                          ),
                                                        ],
                                                      ),
                                          ))
                                    ]),
                              ]),
                        ))
                  ],
                );
              }),
        ),
      ),
    );
  }

  void onPressEdit() {
    locator<RoutesService>().showEdit(this.route);
  }

  void onPressRoute() {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RouteDetailScreen(route: this.route)))
        .then((newRating) {
      if (newRating != null) {
        setState(() {
          route.rating = newRating;
        });
      }
    });
  }

  bool _getIsPrivileged() {
    if (appUser == null) return false;
    return (appUser.roles[appUser.selectedGym] != null &&
        (appUser.roles[appUser.selectedGym].gymuser ||
            appUser.roles[appUser.selectedGym].builder));
  }

  String truncate(String str, int amt) {
    return str.length > 4 && str.length > amt
        ? str.substring(0, amt) + '...'
        : str;
  }
}
