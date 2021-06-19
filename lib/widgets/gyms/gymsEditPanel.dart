import 'dart:io';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/gymService.dart';
import 'package:climbing_gym_app/services/newsService.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class GymsEditPanel extends StatefulWidget with GetItStatefulWidgetMixin {
  GymsEditPanel({Key key}) : super(key: key);

  @override
  _GymsEditPanelState createState() => _GymsEditPanelState();
}

class _GymsEditPanelState extends State<GymsEditPanel> with GetItStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _GymsEditPanelState();

  final controllerGymName = TextEditingController(text: "");
  final controllerLocation = TextEditingController(text: "");
  File _image;
  final picker = ImagePicker();

  final gymService = locator<GymService>();
  final authService = locator<AuthService>();
  BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0));

  @override
  Widget build(BuildContext context) {
    watchX((GymService x) {
      controllerGymName.text = x.currentGym.value.name;
      controllerLocation.text = x.currentGym.value.city;
      return x.currentGym;
    });

    return SlidingUpPanel(
        minHeight: 0.0,
        borderRadius: radius,
        controller: gymService.panelControl,
        onPanelClosed: (() {
          setState(() {});
        }),
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

            // SlidingUpPanel content
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Take photo button
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0))),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(12.0),
                          elevation: 2,
                          primary: Constants.polyGray,
                        ),
                        onPressed: () async =>
                            _showImageSourceActionSheet(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            _image == null
                                ? Icon(Icons.camera_alt_rounded,
                                    size: 48.0, color: Colors.white)
                                : Image.file(
                                    _image,
                                    // fit: BoxFit.fitWidth,
                                    height: 48,
                                  ),
                            Text(
                              _image == null
                                  ? 'Change banner'
                                  : 'Banner changed',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container for gym name
                    Container(
                        padding:
                            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name of Gym
                              Text(
                                'Gym name',
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
                                  controller: controllerGymName,
                                  validator: NameFieldValidator.validate,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.words,
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                  // The name keyboard is optimized for names and phone numbers
                                  // Therefore we should use the default keyboard
                                  keyboardType: TextInputType.text,
                                  // The name should consist of only one line
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      hintText: 'Name',
                                      contentPadding:
                                          const EdgeInsets.only(left: 16.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      fillColor: Colors.white,
                                      filled: true))
                            ])),

                    // Location
                    Container(
                        padding:
                            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Location',
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
                                  controller: controllerLocation,
                                  validator: NameFieldValidator.validate,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.words,
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                  // The name keyboard is optimized for names and phone numbers
                                  // Therefore we should use the default keyboard
                                  keyboardType: TextInputType.text,
                                  // The location should consist of only one line
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      hintText: 'Location',
                                      contentPadding:
                                          const EdgeInsets.only(left: 16.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      fillColor: Colors.white,
                                      filled: true)),
                            ])),

                    // Buttons
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Accept button
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Constants.polyGreen),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.0)),
                                    )),
                                onPressed: () => editGym(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Update Gym",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
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
                                    backgroundColor: MaterialStateProperty.all(
                                        Constants.polyRed),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.0)),
                                    )),
                                onPressed: () =>
                                    gymService.panelControl.close(),
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
                      ),
                    ),

                    // Delete Button
                    FutureBuilder<bool>(
                        future: authService.getIsOperator(),
                        builder: (context, operatorSnapshot) {
                          if (!operatorSnapshot.hasData ||
                              operatorSnapshot.data == false) {
                            return Container();
                          } else {
                            return Container(
                              padding: EdgeInsets.only(bottom: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 100, right: 100),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Constants.polyRed),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.0)),
                                            )),
                                        onPressed: () => onPressDelete(context),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Icon(Icons.delete,
                                                    size: 20),
                                              ),
                                              Text("Delete Gym",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        })
                  ],
                ))));
  }

  void toggleSlidingPanel() {
    if (gymService.panelControl.isPanelOpen) {
      gymService.panelControl.close();
    } else {
      gymService.panelControl.open();
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    // iOS
    if (Platform.isIOS) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                      child: Text('Camera'),
                      onPressed: () {
                        Navigator.pop(context);
                        _getImage(ImageSource.camera);
                      }),
                  CupertinoActionSheetAction(
                    child: Text('Gallery'),
                    onPressed: () {
                      Navigator.pop(context);
                      _getImage(ImageSource.gallery);
                    },
                  )
                ],
              ));
      // Android
    } else {
      showModalBottomSheet(
          context: context,
          builder: (context) => ListView(children: [
                ListTile(
                    leading: Icon(Icons.camera_alt_rounded),
                    title: Text('Camera'),
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(ImageSource.camera);
                    }),
                ListTile(
                    leading: Icon(Icons.photo_album),
                    title: Text('Gallery'),
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(ImageSource.gallery);
                    })
              ]));
    }
  }

  Future _getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void editGym() async {
    final gymName = controllerGymName.text.trim();
    final gymLocation = controllerLocation.text.trim();
    final id = getX((GymService x) => x.currentGym.value.id);

    if (_validateAndSave()) {
      // edit Gym
      await gymService.editGym(id, gymName, gymLocation, _image);
      gymService.panelControl.close();
    }
  }

  void onPressDelete(BuildContext context) {
    final gymService = locator<GymService>();
    final authService = locator<AuthService>();
    final newsService = locator<NewsService>();
    final routeService = locator<RoutesService>();
    final id = getX((GymService x) => x.currentGym.value.id);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Delete Gym',
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Would you like to delete this gym?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                child: Text("No")),
            TextButton(
                onPressed: () async {
                  bool isRoutesForGymDelted =
                      await routeService.cleanUpRoutesForGym(id);
                  bool isNewsForGymDeleted =
                      await newsService.cleanUpNewsForGym(id);
                  bool isGymDeleted = await gymService.deleteGym(id);
                  bool isUserPrivilegesDeleted =
                      await authService.deleteUsersGymPrivileges(id);

                  if (isRoutesForGymDelted &&
                      isGymDeleted &&
                      isUserPrivilegesDeleted &&
                      isNewsForGymDeleted) {
                    Navigator.of(context, rootNavigator: true).pop();
                    gymService.panelControl.close();
                  }
                },
                child: Text("Yes")),
          ],
        );
      },
    );
  }

  bool _validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

class SlidingUpPanelController {}
