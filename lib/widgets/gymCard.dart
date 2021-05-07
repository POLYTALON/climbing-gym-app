import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;

class GymCard extends StatelessWidget {
  final String _title = 'Kletterhalle\nXYZ';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Constants.polyGray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Image
            Expanded(
                flex: 5,
                child: Image.network(
                    'https://i.pinimg.com/originals/45/a7/26/45a726dd36938ee9c6376a12fa6bac52.jpg',
                    fit: BoxFit.fill)),
            // Title
            Expanded(
                flex: 5,
                child: Center(
                  child: Text(_title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 20)),
                )),
          ],
        ),
      ),
    );
  }
}
