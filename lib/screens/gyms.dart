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
          anchor: 0.6,
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
              child: Column(children: <Widget>[
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
                        /* onPressed: () async {
                          final cameras = await availableCameras();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TakePictureScreen(camera: cameras.first)),
                          );
                        }, */
                        onPressed: () => _showImageSourceActionSheet(context),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(Icons.camera_alt_rounded,
                                  size: 48.0, color: Colors.white),
                              Text(
                                'Logo oder Bild hinzufügen',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),
                              )
                            ]))),
              ])))
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
                        // selectImageSource(ImageSource.camera);
                      }),
                  CupertinoActionSheetAction(
                    child: Text('Gallerie'),
                    onPressed: () {
                      Navigator.pop(context);
                      // selectImageSource(ImageSource.gallery);
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
