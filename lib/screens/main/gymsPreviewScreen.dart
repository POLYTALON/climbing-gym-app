import 'package:climbing_gym_app/models/Gym.dart';
import 'package:climbing_gym_app/screens/start.dart';
import 'package:climbing_gym_app/services/gymService.dart';
import 'package:climbing_gym_app/widgets/gyms/gymCard.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:climbing_gym_app/widgets/gyms/gymPreviewCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class GymsPreviewScreen extends StatefulWidget {
  @override
  _GymsPreviewScreenState createState() => _GymsPreviewScreenState();
}

class _GymsPreviewScreenState extends State<GymsPreviewScreen> {
  final PanelController _gymsAddPanelController = PanelController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return StreamProvider<List<Gym>>.value(
        initialData: [],
        value: GymService().streamGyms(),
        child: Consumer<List<Gym>>(builder: (context, gyms, _) {
          return Stack(children: <Widget>[
            Scaffold(
                backgroundColor: Constants.polyDark,
                // Page content
                body: Container(
                    child: Column(children: [
                  Row(children: [
                    // Back Button
                    Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 48.0, 0.0, 16.0),
                        child: RawMaterialButton(
                            onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (countext) => StartScreen()))
                                },
                            elevation: 2.0,
                            fillColor: Colors.grey,
                            child: Icon(Icons.arrow_back_rounded, size: 32.0),
                            padding: EdgeInsets.all(8.0),
                            shape: CircleBorder())),
                    // Text
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
                      child: Text("Available Gyms",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 24)),
                    ),
                  ]),
                  // GridView (with GymPreviewCards)
                  Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (itemWidth / itemHeight),
                        children: List.generate(gyms.length, (index) {
                          return Container(
                              child: GymPreviewCard(gym: gyms[index]));
                        })),
                  )
                ]))),
          ]);
        }));
  }

  void toggleSlidingPanel() {
    if (_gymsAddPanelController.isPanelOpen) {
      _gymsAddPanelController.close();
    } else {
      _gymsAddPanelController.open();
    }
  }
}
