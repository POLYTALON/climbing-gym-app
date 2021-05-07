import 'package:climbing_gym_app/widgets/gymCard.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;

const polyDark = Color(0x121212);

class GymsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return Column(
        // padding: const EdgeInsets.all(8),
        // color: Constants.polyDark,
        children: [
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
                children: List.generate(100, (index) {
                  return Center(child: GymCard());
                })),
          )
        ]);
  }
}
