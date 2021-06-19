import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/Gym.dart';
import 'package:climbing_gym_app/services/gymService.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:transparent_image/transparent_image.dart';
import '../../locator.dart';

class GymCard extends StatefulWidget {
  final Gym gym;
  final AppUser appUser;
  GymCard({Gym gym, AppUser appUser})
      : this.gym = gym,
        this.appUser = appUser;

  _GymCardState createState() => new _GymCardState(gym, appUser);
}

class _GymCardState extends State<GymCard> {
  Gym gym;
  AppUser appUser;
  _GymCardState(this.gym, this.appUser);

  @override
  void didUpdateWidget(GymCard oldWidget) {
    if (gym != widget.gym || appUser != widget.appUser) {
      setState(() {
        gym = widget.gym;
        appUser = widget.appUser;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final auth = locator<AuthService>();
    return StreamBuilder<AppUser>(
        stream: auth.streamAppUser(),
        initialData: new AppUser().empty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active ||
              !snapshot.hasData) {
            return Container();
          } else {
            return Container(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () {
                  auth.selectGym(gym.id);
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  color: Constants.polyGray,
                  shape: snapshot.data.selectedGym == gym.id
                      ? RoundedRectangleBorder(
                          side: BorderSide(
                            color: Constants.polyGreen,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(8))
                      : RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // Image
                      Expanded(
                          flex: 4,
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
                            if (_getIsPrivileged())
                              FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Container(
                                    color: Colors.grey[400],
                                    child: Column(
                                      //mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          color: Colors.white,
                                          onPressed: onPressEdit,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.account_circle_outlined),
                                          color: Colors.white,
                                          onPressed: () =>
                                              onPressAccountButton(),
                                        )
                                      ],
                                    )),
                              ),
                          ])),
                      // Title
                      Expanded(
                          flex: 6,
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
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 0.0, 8.0, 0.0),
                                      child: Text(gym.city,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 20)),
                                    ),
                                  )),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  void onPressEdit() {
    locator<GymService>().showEdit(this.gym);
  }

  bool _getIsPrivileged() {
    if (appUser == null) return false;
    return appUser.isOperator ||
        (appUser.roles[gym.id] != null && appUser.roles[gym.id].gymuser);
  }

  void onPressAccountButton() {
    if (appUser.isOperator) {
      locator<GymService>().showSetOwner(this.gym);
    } else if (appUser.roles.containsKey(this.gym.id)) {
      locator<GymService>().showEditBuilder(this.gym);
    }
  }
}
