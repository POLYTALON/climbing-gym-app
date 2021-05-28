import 'dart:io';

import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/databaseService.dart';
import 'package:climbing_gym_app/validators/content_validator.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:climbing_gym_app/validators/title_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewsAddPanel extends StatefulWidget {
  NewsAddPanel({
    Key key,
    @required SlidingUpPanelController panelController,
  })  : _panelController = panelController,
        super(key: key);

  final SlidingUpPanelController _panelController;

  @override
  _NewsAddPanelState createState() => _NewsAddPanelState(_panelController);
}

class _NewsAddPanelState extends State<NewsAddPanel> {
  final SlidingUpPanelController _panelController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _NewsAddPanelState(this._panelController);

  final TextEditingController controllerNewsTitle =
      TextEditingController(text: "");
  final TextEditingController controllerNewsLink =
      TextEditingController(text: "");
  final TextEditingController controllerNewsContent =
      TextEditingController(text: "");
  String _errorMessage = "";
  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<DatabaseService>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);

    return SlidingUpPanelWidget(
      controlHeight: 1.0,
      anchor: 1.0,
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
                        onPressed: () => _showImageSourceActionSheet(context),
                        child: _bannerRow()),
                  ),
                  // Title
                  Container(
                      padding:
                          EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name of Gym
                            Text('News Title',
                                style: Constants.defaultTextWhite),
                            Divider(
                              color: Constants.polyGray,
                              thickness: 2,
                              height: 20,
                            ),
                            TextFormField(
                                controller: controllerNewsTitle,
                                validator: TitleFieldValidator.validate,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.words,
                                style: Constants.defaultText,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    hintText: 'Title',
                                    contentPadding:
                                        const EdgeInsets.only(left: 16.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.white,
                                    filled: true))
                          ])),

                  // Content
                  Container(
                      padding:
                          EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('News Text',
                                style: Constants.defaultTextWhite),
                            Divider(
                              color: Constants.polyGray,
                              thickness: 2,
                              height: 20,
                            ),
                            TextFormField(
                                minLines: 5,
                                maxLines: 30,
                                controller: controllerNewsContent,
                                validator: ContentFieldValidator.validate,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.words,
                                style: Constants.defaultText,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    hintText: 'Text',
                                    contentPadding: EdgeInsets.all(16.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.white,
                                    filled: true))
                          ])),

                  // Link
                  Container(
                      padding:
                          EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Forward Link',
                                style: Constants.defaultTextWhite),
                            Divider(
                              color: Constants.polyGray,
                              thickness: 2,
                              height: 20,
                            ),
                            TextFormField(
                                controller: controllerNewsLink,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.words,
                                style: Constants.defaultText,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    hintText: 'Link',
                                    contentPadding: EdgeInsets.all(16.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
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
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Accept button

                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Constants.polyGreen),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24.0)),
                                  )),
                              onPressed: () => createNews(db, auth),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Publish",
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
                            margin: const EdgeInsets.only(left: 10, right: 10),
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
                              onPressed: () => _panelController.collapse(),
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
                  )
                ],
              )))),
    );
  }

  Row _bannerRow() {
    String text = 'Add banner';
    Widget preview =
        Icon(Icons.camera_alt_rounded, size: 48.0, color: Colors.white);

    if (_image != null) {
      text = 'Banner added';
      preview = Image.file(
        _image,
        // fit: BoxFit.fitWidth,
        height: 48,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        preview,
        Text(
          text,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white),
        ),
      ],
    );
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
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void createNews(DatabaseService db, AuthService auth) async {
    final newsTitle = controllerNewsTitle.text.trim();
    final newsContent = controllerNewsContent.text.trim();
    final newsLink = controllerNewsLink.text.trim();
    final user = await auth.getUserDetails();
    final creator = user.displayName;
    if (_validateAndSave()) {
      if (_image != null) {
        // create Gym
        await db.addNews(newsTitle, newsContent, newsLink, creator, _image);
        controllerNewsTitle.clear();
        controllerNewsContent.clear();
        controllerNewsLink.clear();
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
