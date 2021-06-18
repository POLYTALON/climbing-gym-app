import 'package:climbing_gym_app/widgets/routes/ratingBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;

class RatingDialog extends StatefulWidget {
  RatingDialog({Function onSubmit, int myRating})
      : this.onSubmit = onSubmit,
        this.myRating = myRating;
  final int myRating;
  final Function onSubmit;

  _RatingDialogState createState() =>
      new _RatingDialogState(onSubmit, myRating);
}

class _RatingDialogState extends State<RatingDialog> {
  _RatingDialogState(this.onSubmit, this.myRating);
  int myRating;
  final Function onSubmit;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Text(
          "Rate this route",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Center(
              child: PolyRatingBar(
                  allowHalfRating: false,
                  starCount: 5,
                  rating: myRating != null ? myRating.toDouble() : 0.0,
                  size: 40.0,
                  isReadOnly: false,
                  onRated: (rating) {
                    setState(() {
                      myRating = rating.toInt();
                    });
                  },
                  activeColor: Colors.orangeAccent,
                  inactiveColor: Constants.lightGray,
                  borderColor: Colors.black,
                  spacing: 0.0))
        ]),
        actions: [
          ElevatedButton(
            child: Text(
              "Cancel",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
              child: Text(
                "Submit",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              onPressed: myRating == null
                  ? null
                  : () {
                      onSubmit(myRating);
                    })
        ]);
  }
}
