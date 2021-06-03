import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/UserRole.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/gymService.dart';
import 'package:climbing_gym_app/services/databaseService.dart';
import 'package:climbing_gym_app/view_models/gymEdit.dart';
import 'package:climbing_gym_app/widgets/gyms/gymCard.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:climbing_gym_app/widgets/gyms/gymsAddPanel.dart';
import 'package:climbing_gym_app/widgets/gyms/gymsEditPanel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:provider/provider.dart';

class GymsScreen extends StatefulWidget {
  @override
  _GymsScreenState createState() => _GymsScreenState();
}

class _GymsScreenState extends State<GymsScreen> {
  final SlidingUpPanelController _gymsAddPanelController =
      SlidingUpPanelController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return StreamBuilder<AppUser>(
        stream: auth.streamAppUser(),
        initialData: new AppUser().empty(),
        builder: (context, snapshot) {
          print("new state");
          print(snapshot.connectionState);
          if (snapshot.connectionState != ConnectionState.active ||
              !snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ChangeNotifierProvider<GymEdit>(
                create: (_) => GymEdit(),
                child: Stack(children: <Widget>[
                  Scaffold(
                      // Add gym button
                      floatingActionButton:
                          _getFloatingActionButton(snapshot.data.isOperator),
                      backgroundColor: Constants.polyDark,

                      // Page content
                      body: Container(
                          child: Column(children: [
                        // Text
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Choose Your Gym",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24)),
                        ),

                        // GridView (with GymCards)
                        Expanded(
                          child: StreamBuilder(
                              stream: locator<GymService>().streamGyms(),
                              builder: (context, gymsSnapshot) {
                                if (snapshot.connectionState !=
                                        ConnectionState.active ||
                                    !gymsSnapshot.hasData) {
                                  //return Container(width: 0.0, height: 0.0);
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return GridView.count(
                                      crossAxisCount: 2,
                                      childAspectRatio:
                                          (itemWidth / itemHeight),
                                      children: List.generate(
                                          gymsSnapshot.data.length, (index) {
                                        return Container(
                                            child: GymCard(
                                                gym: gymsSnapshot.data[index],
                                                appUser: snapshot.data));
                                      }));
                                }
                              }),
                        )
                      ]))),
                  if (snapshot.data.isOperator)
                    GymsAddPanel(panelController: _gymsAddPanelController),
                  if (snapshot.data.isOperator ||
                      _getIsAnyGymUser(snapshot.data.roles))
                    GymsEditPanel()
                ]));
          }
        });
  }

  void toggleSlidingPanel() {
    if (_gymsAddPanelController.status == SlidingUpPanelStatus.expanded) {
      _gymsAddPanelController.collapse();
    } else {
      _gymsAddPanelController.anchor();
    }
  }

  Widget _getFloatingActionButton(bool value) {
    if (value) {
      return FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Constants.polyGreen,
        onPressed: () => toggleSlidingPanel(),
      );
    }
    return Container(width: 0.0, height: 0.0);
  }

  bool _getIsAnyGymUser(Map<String, UserRole> roles) {
    bool isAnyGymUser = false;
    roles.forEach((key, value) {
      if (value.gymuser) isAnyGymUser = true;
    });
    return isAnyGymUser;
  }
}
