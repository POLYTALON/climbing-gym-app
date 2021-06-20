import 'dart:io';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/services/newsService.dart';
import 'package:climbing_gym_app/validators/content_validator.dart';
import 'package:climbing_gym_app/validators/title_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class NewsAddPanel extends StatefulWidget {
  NewsAddPanel(
      {Key key, @required PanelController panelController, String gymid})
      : _panelController = panelController,
        gymid = gymid,
        super(key: key);

  final PanelController _panelController;
  final String gymid;

  @override
  _NewsAddPanelState createState() =>
      _NewsAddPanelState(_panelController, gymid);
}

class _NewsAddPanelState extends State<NewsAddPanel> {
  final PanelController _panelController;
  final String gymid;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _NewsAddPanelState(this._panelController, this.gymid);

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
    final newsServ = locator<NewsService>();

    BorderRadiusGeometry radius = BorderRadius.only(
        topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0));

    return SlidingUpPanel(
        minHeight: 0.0,
        borderRadius: radius,
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
                            _image == null
                                ? Icon(Icons.camera_alt_rounded,
                                    size: 48.0, color: Colors.white)
                                : Image.file(
                                    _image,
                                    // fit: BoxFit.fitWidth,
                                    height: 48,
                                  ),
                            Text(
                              _image == null ? 'Add banner' : 'Banner added',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
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
                                  // Default keyboard to enter news-title
                                  keyboardType: TextInputType.text,
                                  // The title should contain only a single line
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      hintText: 'Title',
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
                                  // The news body may contains multiple lines, so enter should insert a newline
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      hintText: 'Text',
                                      contentPadding: EdgeInsets.all(16.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
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
                                  // The forward link should be an url, therefore we provice the url-keyboard
                                  keyboardType: TextInputType.url,
                                  decoration: InputDecoration(
                                      hintText: 'Link',
                                      contentPadding: EdgeInsets.all(16.0),
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
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                onPressed: () =>
                                    createNews(newsServ, AppUser()),
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
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
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

  void createNews(NewsService db, AppUser user) async {
    final newsTitle = controllerNewsTitle.text.trim();
    final newsContent = controllerNewsContent.text.trim();
    String newsLink = "";
    String newsURL = controllerNewsLink.text.trim();
    if (!newsURL.startsWith("http://") || !newsURL.startsWith("https://")) {
      newsLink = "https://" + newsURL;
    }
    newsLink = Uri.encodeFull(newsLink);
    final gymid = this.gymid ?? "";
    if (_validateAndSave()) {
      if (_image != null) {
        // create Gym
        await db.addNews(newsTitle, newsContent, newsLink, _image, gymid);
        controllerNewsTitle.clear();
        controllerNewsContent.clear();
        controllerNewsLink.clear();
        _panelController.close();
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
