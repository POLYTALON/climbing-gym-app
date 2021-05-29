import 'dart:io';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/services/databaseService.dart';
import 'package:climbing_gym_app/services/gymService.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class GymsAddPanel extends StatefulWidget {
  GymsAddPanel({
    Key key,
    @required SlidingUpPanelController panelController,
  })  : _panelController = panelController,
        super(key: key);

  final SlidingUpPanelController _panelController;

  @override
  _GymsAddPanelState createState() => _GymsAddPanelState(_panelController);
}

class _GymsAddPanelState extends State<GymsAddPanel> {
  final SlidingUpPanelController _panelController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _GymsAddPanelState(this._panelController);
  final controllerGymName = TextEditingController(text: "");
  final controllerLocation = TextEditingController(text: "");
  String _errorMessage = "";
  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanelWidget(
        controlHeight: 1.0,
        anchor: 0.75,
        panelController: _panelController,
        child: Container(
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
                              Icon(Icons.camera_alt_rounded,
                                  size: 48.0, color: Colors.white),
                              Text(
                                'Add picture',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),
                              ),
                            ],
                          )),
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
                                  keyboardType: TextInputType.name,
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
                                  keyboardType: TextInputType.name,
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

                              // Error Message
                              Center(
                                  child: Text(_errorMessage,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w800))),
                            ])),

                    // Buttons
                    Container(
                      padding:
                          EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Accept button
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
                            onPressed: () => createGym(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Create Gym",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),

                          // Cancel button
                          TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Constants.polyRed),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(24.0)),
                                )),
                            onPressed: () => _panelController.collapse(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Cancel",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ))));
  }

  void toggleSlidingPanel() {
    if (_panelController.status == SlidingUpPanelStatus.expanded) {
      _panelController.collapse();
    } else {
      _panelController.anchor();
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

  void createGym() async {
    final gymName = controllerGymName.text.trim();
    final gymLocation = controllerLocation.text.trim();

    final gymService = locator<GymService>();
    if (_validateAndSave()) {
      if (_image != null) {
        // create Gym
        await gymService.addGym(gymName, gymLocation, _image);
        _panelController.collapse();
      } else {
        setState(() {
          _errorMessage = 'Please add a picture.';
        });
      }
    }
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
