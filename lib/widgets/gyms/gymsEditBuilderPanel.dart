import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/gymService.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:climbing_gym_app/widgets/slidingUpPanel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:get_it_mixin/get_it_mixin.dart';

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
    return PolySlidingUpPanel(
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
                              'Manage Setters',
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
                                maxLength: Constants.emailLength,
                                validator: NameFieldValidator.validate,
                                textCapitalization: TextCapitalization.none,
                                style: TextStyle(fontWeight: FontWeight.w800),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: 'Insert email of user',
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
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
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
                                      "Add Setter",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Cancel button
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Constants.polyRed),
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
                              ),
                            ),
                          ],
                        )),
                    Container(
                        padding:
                            EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Revoke button
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Constants.polyRed),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(24.0)),
                                      )),
                                  onPressed: () => removeBuilder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Remove Setter",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ))));
  }

  void setBuilder() async {
    final id = gymService.currentGym.value.id;
    final authService = locator<AuthService>();
    final userEmail = controllerEmail.text.trim();
    bool isSet = await authService.setBuilder(userEmail, id);
    String dialogText = isSet
        ? userEmail + ' has been added as a setter.'
        : userEmail + ' has not been found';
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            isSet ? 'Add Setter' : 'Error',
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(dialogText),
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
    if (isSet == true) {
      gymService.showEditBuilderPanel.close();
    }
  }

  void removeBuilder() async {
    final id = gymService.currentGym.value.id;
    final authService = locator<AuthService>();
    final userEmail = controllerEmail.text.trim();
    bool isRemove = await authService.removeGymOwnerOrBuilder(userEmail, id);
    String dialogText = isRemove
        ? userEmail + ' has been removed as a setter.'
        : userEmail + ' has not been found';
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            isRemove ? 'Remove Setter' : 'Error',
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(dialogText),
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
    if (isRemove) {
      gymService.showEditBuilderPanel.close();
    }
  }
}
