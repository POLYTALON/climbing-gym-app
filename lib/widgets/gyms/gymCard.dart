import 'package:climbing_gym_app/models/Gym.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/databaseService.dart';
import 'package:climbing_gym_app/view_models/gymEdit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class GymCard extends StatefulWidget {
  final Gym gym;
  GymCard({Gym gym}) : this.gym = gym;

  _GymCardState createState() => new _GymCardState(gym);
}

class _GymCardState extends State<GymCard> {
  final Gym gym;
  _GymCardState(this.gym);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final db = Provider.of<DatabaseService>(context, listen: false);

    return //FutureBuilder<bool>(
        //future: _getPrivileges(db, auth, gym),
        //builder: (context, snapshot) {
        // if (snapshot.connectionState != ConnectionState.done) {
        //  return Container(width: 0.0, height: 0.0);
        // } else {
        Container(
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
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(gym.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 20)),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        child: Text(gym.city,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 20)),
                      ),
                    ),
                    //if (snapshot.data)
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

  /* Privileges */
  /*Future<bool> _getIsGymUser(
      DatabaseService db, AuthService auth, Gym gym) async {
    User currentUser = await auth.getUserDetails();
    return await db.hasRoleGymUser(currentUser.uid, gym.id);
  }

  Future<bool> _getIsOperator(DatabaseService db, AuthService auth) async {
    User currentUser = await auth.getUserDetails();
    return await db.hasRoleOperator(currentUser.uid);
  }

  Future<bool> _getPrivileges(
      DatabaseService db, AuthService auth, Gym gym) async {
    return await _getIsOperator(db, auth) || await _getIsGymUser(db, auth, gym);
  } */
}
