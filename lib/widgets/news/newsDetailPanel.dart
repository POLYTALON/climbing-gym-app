import 'dart:io';

import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/databaseService.dart';
import 'package:climbing_gym_app/validators/name_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewsDetailPanel extends StatefulWidget {
  NewsDetailPanel({
    Key key,
    @required SlidingUpPanelController panelController,
  })  : _panelController = panelController,
        super(key: key);

  final SlidingUpPanelController _panelController;

  @override
  _NewsDetailPanelState createState() =>
      _NewsDetailPanelState(_panelController);
}

class _NewsDetailPanelState extends State<NewsDetailPanel> {
  final SlidingUpPanelController _panelController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _NewsDetailPanelState(this._panelController);

  final TextEditingController controllerNewsTitle =
      TextEditingController(text: "");
  final TextEditingController controllerNewsSubtitle =
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
            child: Container(
              child: Text("Lol"),
            )));
  }

  void toggleSlidingPanel() {
    if (_panelController.status == SlidingUpPanelStatus.expanded) {
      _panelController.collapse();
    } else {
      _panelController.anchor();
    }
  }
}
