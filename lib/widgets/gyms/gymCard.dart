import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/Gym.dart';
import 'package:climbing_gym_app/view_models/gymEdit.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class GymCard extends StatefulWidget {
  final Gym gym;
  final AppUser appUser;
  GymCard({Gym gym, AppUser appUser})
      : this.gym = gym,
        this.appUser = appUser;

  _GymCardState createState() => new _GymCardState(gym, appUser);
}

class _GymCardState extends State<GymCard> {
  final Gym gym;
  final AppUser appUser;
  _GymCardState(this.gym, this.appUser);

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
                flex: 5,
                child: Stack(children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: gym.imageUrl,
                        fit: BoxFit.fill),
                  ),
                ])),
            // Title
            Expanded(
                flex: 7,
                child: Column(
                  children: [
                    FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(gym.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20)),
                          ),
                        )),
                    FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Text(gym.city,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20)),
                          ),
                        )),
                    if (_getIsPrivileged())
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors.white,
                            onPressed: onPressEdit,
                          ),
                        ],
                      )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void onPressEdit() {
    final gymEdit = Provider.of<GymEdit>(context, listen: false);
    gymEdit.showEdit(this.gym);
  }

  bool _getIsPrivileged() {
    if (appUser == null) return false;
    return appUser.isOperator ||
        (appUser.roles[gym.id] != null && appUser.roles[gym.id].gymuser);
  }
}
