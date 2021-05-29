import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/services/RoutesService.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:provider/provider.dart';

class RoutesScreen extends StatefulWidget {
  @override
  _RoutesScreenState createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final routes = Provider.of<RoutesService>(context, listen: false);

    return StreamBuilder<AppUser>(
        stream: auth.streamAppUser(),
        initialData: new AppUser().empty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return Container(width: 0.0, height: 0.0);
          } else {
            return StreamBuilder<List<Route>>(
                stream: routes.streamRoutes(snapshot.data.selectedGym ?? '')
                    as Stream<List<Route>>,
                initialData: [],
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.active) {
                    return Container(width: 0.0, height: 0.0);
                  } else {
                    return Container(
                        color: Constants.polyDark,
                        child: Text(routes.toString()));
                  }
                });
          }
        });
  }
}
