import 'dart:io';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/services/routeColorService.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RouteEditPanel extends StatefulWidget {
  RouteEditPanel({
    Key key,
  }) : super(key: key);

  @override
  _RouteEditPanelState createState() => _RouteEditPanelState();
}

class _RouteEditPanelState extends State<RouteEditPanel> {
  final PanelController _panelController = PanelController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final routeColorService = locator<RouteColorService>();
  final controllerRouteName = TextEditingController(text: "");
  final controllerRouteSetter = TextEditingController(text: "");
  final controllerRouteType = TextEditingController(text: "");
  final controllerRouteHolds = TextEditingController(text: "");
  File _image;
  int selectedColorIndex = 0;
  final picker = ImagePicker();
  final routesService = locator<RoutesService>();

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
        topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0));

    routesService.addListener(() {
      if (routesService.showEditPanel == true) {
        controllerRouteName.text = routesService.currentRoute.name;
        controllerRouteSetter.text = routesService.currentRoute.builder;
        controllerRouteType.text = routesService.currentRoute.type;
        controllerRouteHolds.text = routesService.currentRoute.holds;
        _panelController.open();
      } else {
        controllerRouteName.text = "";
        controllerRouteSetter.text = "";
        controllerRouteType.text = "";
        controllerRouteHolds.text = "";
        _panelController.close();
      }
    });

    return SlidingUpPanel(
        minHeight: 0.0,
        snapPoint: 0.75,
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
                                  // The name keyboard is optimized for names and phone numbers
                                  // Therefore we should use the default keyboard
                                  keyboardType: TextInputType.text,
                                  // The route should consist of only one line
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
                                  // The name keyboard is optimized for names (and phone numbers)
                                  keyboardType: TextInputType.name,
                                  // The setter should consist of only one line
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
                                  child: FutureBuilder(
                                      future: routeColorService
                                          .getAvailableRouteColors(),
                                      builder: (context, routeColorSnapshot) {
                                        if (!routeColorSnapshot.hasData) {
                                          return Container(
                                              width: 0.0, height: 0.0);
                                        }
                                        return Container(
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
                                                    routeColorSnapshot
                                                        .data.length, (index) {
                                                  return Center(
                                                      child: Column(children: <
                                                          Widget>[
                                                    RawMaterialButton(
                                                        child: Icon(
                                                            Icons.circle,
                                                            color: Color(
                                                                routeColorSnapshot
                                                                    .data[index]
                                                                    .colorCode),
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
                                                        routeColorSnapshot
                                                            .data[index].color,
                                                        textAlign:
                                                            TextAlign.center,
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
                                  // The name keyboard is optimized for names and phone numbers
                                  // Therefore we should use the default keyboard
                                  keyboardType: TextInputType.text,
                                  // The route should consist of only one line
                                  maxLines: 1,
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
                                  // The name keyboard is optimized for names and phone numbers
                                  // Therefore we should use the default keyboard
                                  keyboardType: TextInputType.text,
                                  // The holds should consist of only one line
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
                                child: TextButton(
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
                                  onPressed: () => editRoute(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Update Route",
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
                                child: TextButton(
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
                                  onPressed: () => _panelController.close(),
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

                    // Delete Button
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 100, right: 100),
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Constants.polyRed),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.0)),
                                    )),
                                onPressed: () => onPressDelete(context),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Delete Route",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )))));
  }

  void toggleSlidingPanel() {
    if (_panelController.isPanelOpen) {
      _panelController.close();
    } else {
      _panelController.open();
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
    final routeName = controllerRouteName.text.trim();
    final builder = controllerRouteSetter.text.trim();
    final routeColors = await routeColorService.getAvailableRouteColors();
    final difficulty = routeColors[this.selectedColorIndex].color;
    final id = routesService.currentRoute.id;
    final gymId = routesService.currentRoute.gymId;
    final holds = controllerRouteHolds.text.trim();
    final type = controllerRouteType.text.trim();

    if (_validateAndSave()) {
      // edit Route
      await routesService.editRoute(id, routeName, gymId, difficulty, type,
          holds, builder, DateTime.now(), _image);
      _panelController.close();
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

  void onPressDelete(BuildContext context) {
    final id = routesService.currentRoute.id;
    if (this.mounted) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Delete Route',
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Would you like to delete this route?',
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("No")),
              TextButton(
                  onPressed: () async {
                    routesService.deleteRoute(id);
                    Navigator.of(context).pop();
                    _panelController.close();
                  },
                  child: Text("Yes")),
            ],
          );
        },
      );
    }
  }
}
