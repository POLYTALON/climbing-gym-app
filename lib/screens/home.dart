import 'package:climbing_gym_app/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:provider/provider.dart';
import 'package:climbing_gym_app/locator.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 64.0, right: 64.0, top: 32),
        color: Constants.polyDark,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Constants.polyRed),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0)),
                  )),
              onPressed: () async {
                final auth = locator<AuthService>();
                await auth.logout();
              },
              child: Text("Logout",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900)),
            )
          ],
        ));
  }
}
