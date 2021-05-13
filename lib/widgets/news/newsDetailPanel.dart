import 'dart:io';

import 'package:climbing_gym_app/view_models/newsDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class NewsDetailPanel extends StatefulWidget {
  NewsDetailPanel({
    Key key,
  }) : super(key: key);

  @override
  _NewsDetailPanelState createState() => _NewsDetailPanelState();
}

class _NewsDetailPanelState extends State<NewsDetailPanel> {
  _NewsDetailPanelState();

  final SlidingUpPanelController _panelController = SlidingUpPanelController();

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsDetails>(context, listen: true);

    newsProvider.addListener(() {
      if (newsProvider.showPanel == true) {
        _panelController.anchor();
      } else {
        _panelController.collapse();
      }
    });

    return Container(
      constraints: BoxConstraints.expand(),
      padding: EdgeInsets.only(left: 16, right: 16),
      child: SlidingUpPanelWidget(
        controlHeight: 1.0,
        anchor: 1.0,
        panelController: _panelController,
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 8, bottom: 8, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          newsProvider.currentNewsDetails.title ?? "",
                          style: Constants.headerText,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            this._panelController.collapse();
                          },
                          icon: const Icon(Icons.close)),
                    ],
                  ),
                  Container(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 16.0,
                      ),
                      constraints:
                          BoxConstraints(minHeight: 100, maxHeight: 200),
                      child: Stack(
                        children: <Widget>[
                          Center(child: CircularProgressIndicator()),
                          Center(
                            child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image:
                                    newsProvider.currentNews.imageUrls != null
                                        ? newsProvider.currentNews.imageUrls[0]
                                        : ""),
                          ),
                        ],
                      )),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(newsProvider.currentNews.subtitle ?? "",
                            style: Constants.subHeaderText),
                        Text(newsProvider.currentNews.content ?? "",
                            style: Constants.defaultText)
                      ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
