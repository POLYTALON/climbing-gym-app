import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/gymService.dart';
import 'package:climbing_gym_app/services/newsService.dart';
import 'package:climbing_gym_app/services/pageviewService.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:climbing_gym_app/widgets/slidingUpPanel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:image_picker/image_picker.dart';

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
  final pageviewService = locator<PageViewService>();

  @override
  Widget build(BuildContext context) {
    watchX((GymService x) {
      controllerGymName.text = x.currentGym.value.name;
      controllerLocation.text = x.currentGym.value.city;
      return x.currentGym;
    });

    return PolySlidingUpPanel(
        controller: gymService.panelControl,
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
                                  maxLength: Constants.gymNameLength,
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
                                  maxLength: Constants.locationLength,
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
                                  child: AutoSizeText("Update Gym",
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
                                  child: AutoSizeText("Cancel",
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                          ),
                          Divider()
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
                                          left: 24.0, right: 24.0),
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
                                              AutoSizeText("Delete Gym",
                                                  maxLines: 1,
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
                        }),
                    Divider(
                      height: 64,
                    ),
                  ],
                )))));
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
                      await authService.deleteInAllUsersGymPrivilege(id);

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
