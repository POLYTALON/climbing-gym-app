import 'dart:io';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:image_picker/image_picker.dart';

class RouteAddPanel extends StatefulWidget {
  final AppUser appUser;
  final SlidingUpPanelController _panelController;
  RouteAddPanel(
      {Key key,
      AppUser appUser,
      @required SlidingUpPanelController panelController})
      : this.appUser = appUser,
        this._panelController = panelController,
        super(key: key);

  @override
  _RouteAddPanelState createState() =>
      _RouteAddPanelState(appUser, _panelController);
}

class _RouteAddPanelState extends State<RouteAddPanel> {
  final AppUser appUser;
  final SlidingUpPanelController _panelController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _RouteAddPanelState(this.appUser, this._panelController);

  final routesService = locator<RoutesService>();
  final controllerRouteName = TextEditingController(text: "");
  final controllerRouteSetter = TextEditingController(text: "");
  final controllerRouteType = TextEditingController(text: "");
  final controllerRouteHolds = TextEditingController(text: "");
  String _errorMessage = "";
  File _image;
  int selectedColorIndex = 0;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanelWidget(
        controlHeight: 1.0,
        anchor: 0.9,
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
                                  controller: controllerRouteName,
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
                                  controller: controllerRouteSetter,
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
                                                  shape: (selectedColorIndex ==
                                                          index)
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
                                  controller: controllerRouteType,
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
                                  controller: controllerRouteHolds,
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

                    // Error Message
                    Center(
                        child: Text(_errorMessage,
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w800))),
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
                              onPressed: () => addRoute(appUser.selectedGym),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Create Route",
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
                        )),
                    SizedBox(height: 100)
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

  void addRoute(String gymId) async {
    final routeName = controllerRouteName.text.trim();
    final builder = controllerRouteSetter.text.trim();
    final difficulty = Constants.availableRouteColors[this.selectedColorIndex];
    final holds = controllerRouteHolds.text.trim();
    final type = controllerRouteType.text.trim();

    if (_validateAndSave()) {
      if (_image != null) {
        // add Route
        await routesService.addRoute(routeName, gymId, difficulty.color, type,
            holds, builder, _image, DateTime.now());
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

  void _setSelectedRouteColorIndex(int index) {
    setState(() {
      selectedColorIndex = index;
    });
  }
}
