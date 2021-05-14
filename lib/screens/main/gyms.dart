import 'package:climbing_gym_app/models/Gym.dart';
import 'package:climbing_gym_app/widgets/gyms/gymCard.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:climbing_gym_app/widgets/gyms/gymsAddPanel.dart';
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
    var gyms = Provider.of<List<Gym>>(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return Stack(children: <Widget>[
      Scaffold(
          // Add gym button
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            backgroundColor: Constants.polyGreen,
            onPressed: () => toggleSlidingPanel(),
          ),
          backgroundColor: Constants.polyDark,

          // Page content
          body: Container(
              child: Column(children: [
            // Text
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Halle auswählen",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 24)),
            ),

            // GridView (with GymCards)
            Expanded(
              child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (itemWidth / itemHeight),
                  children: List.generate(gyms.length, (index) {
                    return Container(child: GymCard(gym: gyms[index]));
                  })),
            )
          ]))),
      GymsAddPanel(panelController: _gymsAddPanelController)
    ]);
  }

  void toggleSlidingPanel() {
    if (_gymsAddPanelController.status == SlidingUpPanelStatus.expanded) {
      _gymsAddPanelController.collapse();
    } else {
      _gymsAddPanelController.anchor();
    }
  }
}
