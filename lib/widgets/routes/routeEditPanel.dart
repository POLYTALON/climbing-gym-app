import 'dart:io';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppRoute.dart';
import 'package:climbing_gym_app/services/routeColorService.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:climbing_gym_app/widgets/routes/imageEditorScreen.dart';
import 'package:climbing_gym_app/widgets/slidingUpPanel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:image_picker/image_picker.dart';

class RouteEditPanel extends StatefulWidget with GetItStatefulWidgetMixin {
  RouteEditPanel({
    Key key,
  }) : super(key: key);

  @override
  _RouteEditPanelState createState() => _RouteEditPanelState();
}

class _RouteEditPanelState extends State<RouteEditPanel> with GetItStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final routesService = locator<RoutesService>();
  final routeColorService = locator<RouteColorService>();
  final controllerRouteName = TextEditingController(text: "");
  final controllerRouteSetter = TextEditingController(text: "");
  final controllerRouteType = TextEditingController(text: "");
  final controllerRouteHolds = TextEditingController(text: "");
  File _image;
  int selectedColorIndex = 0;
  final picker = ImagePicker();
  bool isImageLoading = true;
  @override
  Widget build(BuildContext context) {
    watchX((RoutesService x) {
      if (x.currentRoute.value.gymId != null) {
        controllerRouteName.text = x.currentRoute.value.name;
        controllerRouteSetter.text = x.currentRoute.value.builder;
        controllerRouteType.text = x.currentRoute.value.type;
        controllerRouteHolds.text = x.currentRoute.value.holds;
      }
      return x.currentRoute;
    });

    return PolySlidingUpPanel(
        controller: routesService.editRoutePanelController,
        onPanelClosed: () {
          routesService.currentRoute.value = AppRoute();
          controllerRouteName.clear();
          controllerRouteSetter.clear();
          controllerRouteHolds.clear();
          controllerRouteType.clear();
          _image = null;
        },
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
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(12.0),
                                          elevation: 2,
                                          fixedSize: Size(double.infinity, 64),
                                          primary: Constants.polyGray,
                                        ),
                                        onPressed: () async =>
                                            _showImageSourceActionSheet(
                                                context),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            _image != null
                                                ? Image.file(_image)
                                                : getX((RoutesService x) => x
                                                            .currentRoute
                                                            .value
                                                            .imageUrl) !=
                                                        null
                                                    ? Image.network(getX(
                                                        (RoutesService x) => x
                                                            .currentRoute
                                                            .value
                                                            .imageUrl))
                                                    : Container(),
                                            Text(
                                              'Change',
                                              style: Constants.defaultTextWhite,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize:
                                                Size(double.infinity, 64),
                                            padding: EdgeInsets.all(12.0),
                                            elevation: 2,
                                            primary: Constants.polyGray,
                                          ),
                                          onPressed: () async => {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageEditorScreen(
                                                            imageFile: _image,
                                                            imageUrl: getX(
                                                                (RoutesService x) => x
                                                                    .currentRoute
                                                                    .value
                                                                    .imageUrl)))).then(
                                                (newImage) {
                                              if (newImage != null) {
                                                setState(() {
                                                  _image = newImage;
                                                });
                                              }
                                            })
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(Icons.location_searching),
                                              Text('Mark holds',
                                                  style: Constants
                                                      .defaultTextWhite),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ])),
                          // Container for route name
                          Container(
                              padding: EdgeInsets.only(
                                  top: 16.0, left: 16.0, right: 16.0),
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
                                        textCapitalization:
                                            TextCapitalization.words,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
                                        // The name keyboard is optimized for names and phone numbers
                                        // Therefore we should use the default keyboard
                                        keyboardType: TextInputType.text,
                                        // The route should consist of only one line
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
                                            filled: true))
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
                                        controller: controllerRouteSetter,
                                        validator: NameFieldValidator.validate,
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
                                        child: FutureBuilder(
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
                                                                      onPressed: () => _setSelectedRouteColorIndex(
                                                                          routeColorSnapshot
                                                                              .data[
                                                                                  index]
                                                                              .color,
                                                                          index),
                                                                      shape: (selectedColorIndex ==
                                                                              index)
                                                                          ? CircleBorder(
                                                                              side: BorderSide(width: 3.0, color: Constants.polyGray))
                                                                          : CircleBorder(side: BorderSide(width: 0.0, color: Colors.transparent)))),
                                                              Text(
                                                                  routeColorSnapshot
                                                                      .data[
                                                                          index]
                                                                      .color,
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
                                        controller: controllerRouteType,
                                        validator: NameFieldValidator.validate,
                                        autocorrect: false,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
                                        // The name keyboard is optimized for names and phone numbers
                                        // Therefore we should use the default keyboard
                                        keyboardType: TextInputType.text,
                                        // The route should consist of only one line
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
                                        controller: controllerRouteHolds,
                                        validator: NameFieldValidator.validate,
                                        autocorrect: false,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
                                        // The name keyboard is optimized for names and phone numbers
                                        // Therefore we should use the default keyboard
                                        keyboardType: TextInputType.text,
                                        // The holds should consist of only one line
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
                          // Buttons
                          Container(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                        onPressed: () => routesService
                                            .editRoutePanelController
                                            .close(),
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
                            padding: EdgeInsets.only(bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                              child:
                                                  Icon(Icons.delete, size: 20),
                                            ),
                                            Text("Delete Route",
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
                          )
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
    final id = getX((RoutesService x) => x.currentRoute.value.id);
    final gymId = getX((RoutesService x) => x.currentRoute.value.gymId);
    final holds = controllerRouteHolds.text.trim();
    final type = controllerRouteType.text.trim();

    if (_validateAndSave()) {
      // edit Route
      routesService.editRoute(id, routeName, gymId, difficulty, type, holds,
          builder, DateTime.now(), _image);
      routesService.editRoutePanelController.close();
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

  void _setSelectedRouteColorIndex(String color, int index) {
    setState(() {
      selectedColorIndex = index;
    });
  }

  void onPressDelete(BuildContext context) {
    final id = getX((RoutesService x) => x.currentRoute.value.id);
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
                    routesService.editRoutePanelController.close();
                  },
                  child: Text("Yes")),
            ],
          );
        },
      );
    }
  }
}
