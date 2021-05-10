import 'package:climbing_gym_app/models/Gym.dart';
import 'package:climbing_gym_app/services/gymsService.dart';
import 'package:climbing_gym_app/widgets/gymCard.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:provider/provider.dart';

class GymsScreen extends StatelessWidget {
  // The controller of the sliding panel
  final SlidingUpPanelController _panelController = SlidingUpPanelController();

  @override
  Widget build(BuildContext context) {
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
              child: ChangeNotifierProvider<GymsService>(
                  create: (context) => GymsService(),
                  child: Consumer<GymsService>(
                      builder: (context, gymsService, child) {
                    return Column(children: [
                      // Text
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Choose your Gym",
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
                            children: List.generate(gymsService.gymsList.length,
                                (index) {
                              return Container(
                                  child: GymCard(
                                      gym: Gym(
                                          name:
                                              '${gymsService.gymsList[index].name}',
                                          imageUrl:
                                              '${gymsService.gymsList[index].imageUrl}')));
                            })),
                      )
                    ]);
                  })))),

      // SlidingUpPanelWidget
      SlidingUpPanelWidget(
          controlHeight: 1.0,
          anchor: 0.6,
          panelController: _panelController,
          child: Container(
              decoration: ShapeDecoration(
                color: Constants.lightGray,
                shadows: [
                  BoxShadow(
                      blurRadius: 8.0,
                      spreadRadius: 16.0,
                      color: const Color(0x11000000))
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0))),
              ),

              // SlidingUpPanel content
              child: Column(children: <Widget>[
                // Take photo button
                Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0))),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(12.0),
                          elevation: 2,
                          primary: Constants.polyGray,
                        ),
                        onPressed: () {},
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(Icons.camera_alt_rounded,
                                  size: 48.0, color: Colors.white),
                              Text(
                                'Logo oder Bild hinzufügen',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),
                              )
                            ]))),
              ])))
    ]);
  }

  void toggleSlidingPanel() {
    if (_panelController.status == SlidingUpPanelStatus.expanded) {
      _panelController.collapse();
    } else {
      _panelController.anchor();
    }
  }
}
