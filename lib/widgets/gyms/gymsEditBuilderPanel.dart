import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/gymService.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class GymsEditBuilderPanel extends StatefulWidget
    with GetItStatefulWidgetMixin {
  GymsEditBuilderPanel({Key key}) : super(key: key);

  @override
  _GymsEditBuilderPanel createState() => _GymsEditBuilderPanel();
}

class _GymsEditBuilderPanel extends State<GymsEditBuilderPanel>
    with GetItStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _GymsEditBuilderPanel();

  final controllerEmail = TextEditingController(text: "");

  final gymService = locator<GymService>();

  BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0));

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
        minHeight: 0.0,
        snapPoint: 0.50,
        borderRadius: radius,
        controller: gymService.showEditBuilderPanel,
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
                              'Set Builder',
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
                            //Set Builder Button
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
                              onPressed: () => setBuilder(),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "SET BUILDER",
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
                              onPressed: () =>
                                  gymService.showEditBuilderPanel.close(),
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
    if (gymService.showEditBuilderPanel.isPanelOpen) {
      gymService.showEditBuilderPanel.close();
    } else {
      gymService.showEditBuilderPanel.open();
    }
  }

  void setBuilder() async {
    final id = gymService.currentGym.value.id;
    final authService = locator<AuthService>();
    final userEmail = controllerEmail.text.trim();
    bool isSet = await authService.setBuilder(userEmail, id);
    if (isSet == true) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Set Builder',
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    userEmail + ' has been set as a builder.',
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                  child: Text("Close")),
            ],
          );
        },
      );
      gymService.showEditBuilderPanel.close();
    } else {
      print("error");
    }
  }
}
