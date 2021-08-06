import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/Gym.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;

class GymPreviewCard extends StatefulWidget {
  final Gym gym;
  GymPreviewCard({Gym gym, AppUser appUser}) : this.gym = gym;

  _GymPreviewCardState createState() => new _GymPreviewCardState(gym);
}

class _GymPreviewCardState extends State<GymPreviewCard> {
  Gym gym;
  AppUser appUser;
  _GymPreviewCardState(this.gym);

  @override
  void didUpdateWidget(GymPreviewCard oldWidget) {
    if (gym != widget.gym) {
      setState(() {
        gym = widget.gym;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Constants.polyGray,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Image
            Expanded(
              flex: 4,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CachedNetworkImage(
                    placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: Constants.polyGreen,
                          ),
                        ),
                    imageUrl: gym.imageUrl,
                    fit: BoxFit.fill),
              ),
            ),
            // Title
            Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AutoSizeText(gym.name,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18)),
                          ),
                        )),
                    FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: AutoSizeText(gym.city,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18)),
                          ),
                        )),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
