import 'package:climbing_gym_app/models/Gym.dart';
import 'package:climbing_gym_app/services/gymsService.dart';
import 'package:climbing_gym_app/widgets/gymCard.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GymsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Constants.polyGreen,
          onPressed: () {},
        ),
        backgroundColor: Constants.polyDark,
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
                }))));
  }
}
