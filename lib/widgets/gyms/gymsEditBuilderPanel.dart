import 'dart:io';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/gymService.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class GymsEditBuilderPanel extends StatefulWidget {
  GymsEditBuilderPanel({Key key}) : super(key: key);

  @override
  _GymsEditBuilderPanel createState() => _GymsEditBuilderPanel();
}

class _GymsEditBuilderPanel extends State<GymsEditBuilderPanel> {
  final PanelController _panelController = PanelController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _GymsEditBuilderPanel();

  final controllerEmail = TextEditingController(text: "");

  final gymService = locator<GymService>();

  BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0));

  @override
  Widget build(BuildContext context) {
    gymService.addListener(() {
      if (gymService.showEditBuilderPanel == true) {
        _panelController.open();
      } else {
        controllerEmail.text = "";
        _panelController.close();
      }
    });

    return SlidingUpPanel(
        minHeight: 0.0,
        snapPoint: 0.50,
        borderRadius: radius,
        controller: _panelController,
        panel: Container(
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

            //SlidingUpPanel content
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Container for gym owner
                    Container(
                        padding:
                            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Gym Owner
                            Text(
                              'Who is a builder?',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                            Divider(
                              color: Constants.polyGray,
                              thickness: 2,
                              height: 20,
                            ),
                            TextFormField(
                                controller: controllerEmail,
                                validator: NameFieldValidator.validate,
                                textCapitalization: TextCapitalization.none,
                                style: TextStyle(fontWeight: FontWeight.w800),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: 'Insert email of new builder',
                                    contentPadding:
                                        const EdgeInsets.only(left: 16.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.white,
                                    filled: true))
                          ],
                        )),
                    //Buttons
                    Container(
                        padding:
                            EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //Set Gym Owner Button
                            TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Constants.polyGreen),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0)),
                                  )),
                              onPressed: () => setGymOwner(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "CREATE SETTER",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            //Cancel Button
                            // Cancel button
                            TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.red[400]),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0)),
                                  )),
                              onPressed: () => _panelController.close(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Cancel",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        ))
                  ],
                ))));
  }

  void toggleSlidingPanel() {
    if (_panelController.isPanelOpen) {
      _panelController.close();
    } else {
      _panelController.open();
    }
  }

  void setGymOwner() async {
    final id = gymService.currentGym.id;
    final authService = locator<AuthService>();
    final userEmail = controllerEmail.text.trim();
    bool isSet = await authService.setBuilder(userEmail, id);
    if (isSet == true) {
      _panelController.close();
    } else {
      print("error");
    }
  }
}
