import 'dart:io';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/services/RoutesService.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:image_picker/image_picker.dart';

class RouteEditPanel extends StatefulWidget {
  RouteEditPanel({
    Key key,
  }) : super(key: key);

  @override
  _RouteEditPanelState createState() => _RouteEditPanelState();
}

class _RouteEditPanelState extends State<RouteEditPanel> {
  final SlidingUpPanelController _panelController = SlidingUpPanelController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final controllerGymName = TextEditingController(text: "");
  final controllerLocation = TextEditingController(text: "");
  File _image;
  int selectedColorIndex;
  final picker = ImagePicker();

  final routesService = locator<RoutesService>();

  @override
  Widget build(BuildContext context) {
    final routesService = locator<RoutesService>();

    routesService.addListener(() {
      if (routesService.showEditPanel == true) {
        controllerGymName.text = routesService.currentRoute.name;
        controllerLocation.text = routesService.currentRoute.difficulty.color;
        _panelController.anchor();
      } else {
        controllerGymName.text = "";
        controllerLocation.text = "";
        _panelController.collapse();
      }
    });

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
                child: SingleChildScrollView(
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
                                'Change photo',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),
                              ),
                            ],
                          )),
                    ),
                    // Container for route name
                    Container(
                        padding:
                            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name of route
                              Text(
                                'Route Name',
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

                    // Setter (Builder)
                    Container(
                        padding:
                            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Setter',
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
                                      filled: true)),
                            ])),

                    // Difficulty (Color)
                    Container(
                        padding:
                            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Difficulty',
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
                              SizedBox(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16.0))),
                                      child: GridView.count(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          primary: true,
                                          shrinkWrap: true,
                                          crossAxisCount: 5,
                                          padding: EdgeInsets.all(8.0),
                                          children: List.generate(
                                              Constants.availableRouteColors
                                                  .length, (index) {
                                            return Center(
                                                child:
                                                    Column(children: <Widget>[
                                              RawMaterialButton(
                                                  child: Icon(Icons.circle,
                                                      color: Constants
                                                          .availableRouteColors[
                                                              index]
                                                          .colorCode,
                                                      size: 24),
                                                  onPressed: () =>
                                                      _setSelectedRouteColorIndex(
                                                          index),
                                                  shape: (selectedColorIndex != null &&
                                                          Constants.availableRouteColors[selectedColorIndex] ==
                                                              Constants.availableRouteColors[
                                                                  index])
                                                      ? CircleBorder(
                                                          side: BorderSide(
                                                              width: 3.0,
                                                              color: Constants
                                                                  .polyGray))
                                                      : CircleBorder(
                                                          side: BorderSide(
                                                              width: 0.0,
                                                              color: Colors
                                                                  .transparent))),
                                              Text(
                                                  Constants
                                                      .availableRouteColors[
                                                          index]
                                                      .color,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ]));
                                          }))))
                            ])),
                    // Type
                    Container(
                        padding:
                            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Route Type',
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
                                      hintText: 'e.g. Competition',
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
                    // Holds
                    Container(
                        padding:
                            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Holds',
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
                                      filled: true)),
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
                            onPressed: () => editRoute(),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Update Gym",
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
                )))));
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

  void editRoute() async {
    /*final gymName = controllerGymName.text.trim();
    final gymLocation = controllerLocation.text.trim();
    final id = routesService.currentGym.id;

    if (_validateAndSave()) {
      // edit Gym
      await routesService.editGym(id, gymName, gymLocation, _image);
      _panelController.collapse();
    }*/
  }

  bool _validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _setSelectedRouteColorIndex(int index) {
    print(index);
    selectedColorIndex = index;
  }
}
