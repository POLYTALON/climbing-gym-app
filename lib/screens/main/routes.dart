import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppRoute.dart';
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
    final routes = locator<RoutesService>();

    return StreamBuilder<AppUser>(
        stream: auth.streamAppUser(),
        initialData: new AppUser().empty(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState != ConnectionState.active ||
              !userSnapshot.hasData) {
            return Container(width: 0.0, height: 0.0);
          } else {
            print(userSnapshot.data);
            return StreamBuilder<List<AppRoute>>(
                stream: routes.streamRoutes(userSnapshot.data.selectedGym),
                initialData: [],
                builder: (context, snapshot) {
                  print(snapshot);
                  if (snapshot.connectionState != ConnectionState.active ||
                      snapshot.data == null) {
                    return Container(width: 0.0, height: 0.0);
                  } else if (snapshot.hasError) {
                    print('dei mudda');
                  } else {
                    return Container(
                        color: Constants.polyDark,
                        child: Text(snapshot.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900)));
                  }
                });
          }
        });
  }
}
