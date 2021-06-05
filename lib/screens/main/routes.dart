import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/view_models/routeEdit.dart';
import 'package:climbing_gym_app/widgets/routes/routeAddPanel.dart';
import 'package:climbing_gym_app/widgets/routes/routeCard.dart';
import 'package:climbing_gym_app/widgets/routes/routeEditPanel.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:provider/provider.dart';

class RoutesScreen extends StatefulWidget {
  @override
  _RoutesScreenState createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  final SlidingUpPanelController _routesAddPanelController =
      SlidingUpPanelController();

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
            return ChangeNotifierProvider<RouteEdit>(
                create: (_) => RouteEdit(),
                child: Stack(children: <Widget>[
                  Scaffold(
                      // Add route button
                      floatingActionButton:
                          _getFloatingActionButton(snapshot.data),
                      backgroundColor: Constants.polyDark,

                      // Page content
                      body: Container(
                          child: Column(children: [
                        // filter button
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: IconButton(
                                    icon: Icon(Icons.filter_list_rounded,
                                        size: 32.0),
                                    color: Colors.white,
                                    onPressed: () => {}),
                              )
                            ]),
                        // Grid view (with RouteCards)
                        Expanded(
                          child: StreamBuilder(
                              stream: locator<RoutesService>()
                                  .streamRoutes(snapshot.data.selectedGym),
                              builder: (context, routesSnapshot) {
                                if (snapshot.connectionState !=
                                        ConnectionState.active ||
                                    !routesSnapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  if (routesSnapshot.data.length < 1) {
                                    return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                  'There are no routes for this gym yet.',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w700))),
                                          Icon(Icons.mood_bad_rounded,
                                              color: Colors.white, size: 32.0)
                                        ]);
                                  } else {
                                    return GridView.count(
                                        crossAxisCount: 2,
                                        childAspectRatio:
                                            (itemWidth / itemHeight),
                                        children: List.generate(
                                            routesSnapshot.data.length,
                                            (index) {
                                          return Container(
                                              child: RouteCard(
                                                  route: routesSnapshot
                                                      .data[index],
                                                  appUser: snapshot.data));
                                        }));
                                  }
                                }
                              }),
                        )
                      ]))),
                  if (_getPrivileges(snapshot.data))
                    RouteAddPanel(
                        appUser: snapshot.data,
                        panelController: _routesAddPanelController),
                  if (_getPrivileges(snapshot.data)) RouteEditPanel()
                ]));
          }
        });
  }

  void toggleSlidingPanel() {
    if (_routesAddPanelController.status == SlidingUpPanelStatus.expanded) {
      _routesAddPanelController.collapse();
    } else {
      _routesAddPanelController.anchor();
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
            user.roles[user.selectedGym].gymuser ||
            user.isOperator);
  }
}
