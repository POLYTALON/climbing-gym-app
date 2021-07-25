import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/RouteColor.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/routeColorService.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:climbing_gym_app/widgets/routes/imageEditorScreen.dart';
import 'package:climbing_gym_app/widgets/slidingUpPanel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RouteAddPanel extends StatefulWidget {
  final AppUser appUser;
  final PanelController panelController;
  RouteAddPanel(
      {Key key, AppUser appUser, @required PanelController panelController})
      : this.appUser = appUser,
        this.panelController = panelController,
        super(key: key);

  @override
  _RouteAddPanelState createState() =>
      _RouteAddPanelState(appUser, panelController);
}

class _RouteAddPanelState extends State<RouteAddPanel> {
  final AppUser appUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PanelController _panelController;

  _RouteAddPanelState(this.appUser, this._panelController);
  final authService = locator<AuthService>();
  final routesService = locator<RoutesService>();
  final routeColorService = locator<RouteColorService>();
  final controllerRouteSetter = TextEditingController(text: "");
  final controllerRouteType = TextEditingController(text: "");
  final controllerRouteHolds = TextEditingController(text: "");
  final FocusNode fnSetter = new FocusNode();
  final FocusNode fnType = new FocusNode();
  final FocusNode fnHolds = new FocusNode();
  String _errorMessage = "";
  File _image;
  int selectedColorIndex = 0;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
        topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0));

    if (controllerRouteSetter.text == "") {
      controllerRouteSetter.text = authService.currentUser.displayName;
    }
    return PolySlidingUpPanel(
        controller: _panelController,
        panelBuilder: (ScrollController sc) {
          return Container(
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
                      controller: sc,
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
                              child: _image == null
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(12.0),
                                        elevation: 2,
                                        primary: Constants.polyGray,
                                      ),
                                      onPressed: () async =>
                                          _showImageSourceActionSheet(context),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
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
                                      ))
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.all(12.0),
                                                elevation: 2,
                                                fixedSize:
                                                    Size(double.infinity, 64),
                                                primary: Constants.polyGray,
                                              ),
                                              onPressed: () async =>
                                                  _showImageSourceActionSheet(
                                                      context),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  Image.file(
                                                    _image,
                                                  ),
                                                  Text(
                                                    'Change',
                                                    style: Constants
                                                        .defaultTextWhite,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  fixedSize:
                                                      Size(double.infinity, 64),
                                                  padding: EdgeInsets.all(12.0),
                                                  elevation: 2,
                                                  primary: Constants.polyGray,
                                                ),
                                                onPressed: () => {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImageEditorScreen(
                                                                imageFile:
                                                                    _image)),
                                                  ).then((newImage) {
                                                    if (newImage != null) {
                                                      setState(() {
                                                        _image = newImage;
                                                      });
                                                    }
                                                  })
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Icon(Icons
                                                        .location_searching),
                                                    Text('Mark holds',
                                                        style: Constants
                                                            .defaultTextWhite),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ])),
                          // Setter (Builder)
                          Container(
                              padding: EdgeInsets.only(
                                  top: 16.0, left: 16.0, right: 16.0),
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
                                        focusNode: fnSetter,
                                        controller: controllerRouteSetter,
                                        maxLength: Constants.setterNameLength,
                                        validator: (value) {
                                          String result =
                                              NameFieldValidator.validate(
                                                  value);
                                          if (result != null)
                                            fnSetter.requestFocus();
                                          return result;
                                        },
                                        autocorrect: false,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
                                        // The name keyboard is optimized for names (and phone numbers)
                                        keyboardType: TextInputType.name,
                                        // The setter should consist of only one line
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                            hintText: 'Name',
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 16.0),
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
                              padding: EdgeInsets.only(
                                  top: 16.0, left: 16.0, right: 16.0),
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
                                        child: FutureBuilder<List<RouteColor>>(
                                            future: routeColorService
                                                .getAvailableRouteColors(),
                                            builder:
                                                (context, routeColorSnapshot) {
                                              if (!routeColorSnapshot.hasData) {
                                                return Container(
                                                    width: 0.0, height: 0.0);
                                              }
                                              return Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  16.0))),
                                                  child: GridView.count(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      primary: true,
                                                      shrinkWrap: true,
                                                      crossAxisCount: 5,
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      children: List.generate(
                                                          routeColorSnapshot
                                                              .data
                                                              .length, (index) {
                                                        return Center(
                                                            child: Column(
                                                                children: <
                                                                    Widget>[
                                                              FittedBox(
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  child: RawMaterialButton(
                                                                      child: Icon(
                                                                          Icons
                                                                              .circle,
                                                                          color: Color(routeColorSnapshot
                                                                              .data[
                                                                                  index]
                                                                              .colorCode),
                                                                          size:
                                                                              24),
                                                                      onPressed: () =>
                                                                          _setSelectedRouteColorIndex(
                                                                              index),
                                                                      shape: (selectedColorIndex ==
                                                                              index)
                                                                          ? CircleBorder(
                                                                              side: BorderSide(width: 3.0, color: Constants.polyGray))
                                                                          : CircleBorder(side: BorderSide(width: 0.0, color: Colors.transparent)))),
                                                              AutoSizeText(
                                                                  routeColorSnapshot
                                                                      .data[
                                                                          index]
                                                                      .color,
                                                                  maxLines: 1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700)),
                                                            ]));
                                                      })));
                                            }))
                                  ])),
                          // Type
                          Container(
                              padding: EdgeInsets.only(
                                  top: 16.0, left: 16.0, right: 16.0),
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
                                        focusNode: fnType,
                                        controller: controllerRouteType,
                                        maxLength: Constants.routeTypeLength,
                                        validator: (value) {
                                          String result =
                                              NameFieldValidator.validate(
                                                  value);
                                          if (result != null)
                                            fnType.requestFocus();
                                          return result;
                                        },
                                        autocorrect: false,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
                                        // The name keyboard is optimized for names and phone numbers
                                        // Therefore we should use the default keyboard
                                        keyboardType: TextInputType.text,
                                        // The type should consist of only one line
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                            hintText: 'e.g. Competition',
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 16.0),
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
                              padding: EdgeInsets.only(
                                  top: 16.0, left: 16.0, right: 16.0),
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
                                        focusNode: fnHolds,
                                        controller: controllerRouteHolds,
                                        maxLength: Constants.holdsLength,
                                        validator: (value) {
                                          String result =
                                              NameFieldValidator.validate(
                                                  value);
                                          if (result != null)
                                            fnHolds.requestFocus();
                                          return result;
                                        },
                                        autocorrect: false,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
                                        // The name keyboard is optimized for names and phone numbers
                                        // Therefore we should use the default keyboard
                                        keyboardType: TextInputType.text,
                                        // The hols should consist of only one line
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                            hintText: 'Name',
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 16.0),
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
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Accept button
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Constants.polyGreen),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.0)),
                                            )),
                                        onPressed: () =>
                                            addRoute(appUser.selectedGym),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: AutoSizeText("Create Route",
                                              maxLines: 1,
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
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10),
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
                                        onPressed: () =>
                                            _panelController.close(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: AutoSizeText("Cancel",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Divider()
                        ],
                      ))));
        });
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
    final pickedFile = await picker.getImage(source: source, imageQuality: 25);
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(pickedFile.path);
    File compressedFile = await FlutterNativeImage.compressImage(
        pickedFile.path,
        quality: 25,
        targetWidth: 1024,
        targetHeight: (properties.height * 1024 / properties.width).round());
    setState(() {
      if (pickedFile != null) {
        _image = File(compressedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void addRoute(String gymId) async {
    final builder = controllerRouteSetter.text.trim();
    final routeColors = await routeColorService.getAvailableRouteColors();
    final difficulty = routeColors[this.selectedColorIndex];
    final holds = controllerRouteHolds.text.trim();
    final type = controllerRouteType.text.trim();

    if (_validateAndSave()) {
      if (_image != null) {
        // add Route
        routesService.addRoute(gymId, difficulty.color, type, holds, builder,
            _image, DateTime.now());
        _panelController.close();
        controllerRouteSetter.clear();
        controllerRouteHolds.clear();
        controllerRouteType.clear();
        selectedColorIndex = 0;
        _image = null;
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
