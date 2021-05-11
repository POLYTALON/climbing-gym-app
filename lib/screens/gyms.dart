import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:climbing_gym_app/models/Gym.dart';
import 'package:climbing_gym_app/widgets/gymCard.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class GymsScreen extends StatefulWidget {
  @override
  _GymsScreenState createState() => _GymsScreenState();
}

class _GymsScreenState extends State<GymsScreen> {
  // The controller of the sliding panel
  final SlidingUpPanelController _panelController = SlidingUpPanelController();
  Image _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var gyms = Provider.of<List<Gym>>(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return Stack(children: <Widget>[
      Scaffold(
          // Add gym button
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            backgroundColor: Constants.polyGreen,
            onPressed: () => toggleSlidingPanel(),
          ),
          backgroundColor: Constants.polyDark,

          // Page content
          body: Container(
              child: Column(children: [
            // Text
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Halle auswählen",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 24)),
            ),

            // GridView (with GymCards)
            Expanded(
              child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (itemWidth / itemHeight),
                  children: List.generate(gyms.length, (index) {
                    return Container(child: GymCard(gym: gyms[index]));
                  })),
            )
          ]))),

      // SlidingUpPanelWidget
      SlidingUpPanelWidget(
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
                          onPressed: () => _showImageSourceActionSheet(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(Icons.camera_alt_rounded,
                                  size: 48.0, color: Colors.white),
                              Text(
                                'Banner hinzufügen',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),
                              )
                            ],
                          ))),
                  // Container for gym name
                  Container(
                      padding:
                          EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            // Name of Gym
                            Text(
                              'Name der Kletterhalle',
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
                            TextField(
                                autocorrect: false,
                                textCapitalization: TextCapitalization.words,
                                style: TextStyle(fontWeight: FontWeight.w800),
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 16.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.white,
                                    filled: true))
                          ]))),

                  // Location
                  Container(
                      padding:
                          EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(
                              'Standort',
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
                            TextField(
                                autocorrect: false,
                                textCapitalization: TextCapitalization.words,
                                style: TextStyle(fontWeight: FontWeight.w800),
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 16.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.white,
                                    filled: true))
                          ]))),

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
                                    borderRadius: BorderRadius.circular(24.0)),
                              )),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Halle anlegen",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),

                        // Cancel button
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Constants.polyRed),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0)),
                              )),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Abbrechen",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )))
    ]);
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
                      child: Text('Kamera'),
                      onPressed: () {
                        Navigator.pop(context);
                        _getImage(ImageSource.camera);
                      }),
                  CupertinoActionSheetAction(
                    child: Text('Gallerie'),
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
                    title: Text('Kamera'),
                    onTap: () {
                      Navigator.pop(context);
                      _getImage(ImageSource.camera);
                    }),
                ListTile(
                    leading: Icon(Icons.photo_album),
                    title: Text('Gallerie'),
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
        // check if app is running on web platform
        if (kIsWeb) {
          _image = Image.network(pickedFile.path);
        } else {
          _image = Image.file(File(pickedFile.path));
        }
      } else {
        print('No image selected.');
      }
    });
  }
}
