import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/services/newsService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPanel extends StatefulWidget {
  NewsDetailPanel({
    Key key,
  }) : super(key: key);

  @override
  _NewsDetailPanelState createState() => _NewsDetailPanelState();
}

class _NewsDetailPanelState extends State<NewsDetailPanel> {
  _NewsDetailPanelState();

  final PanelController _panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    final newsProvider = locator<NewsService>();

    BorderRadiusGeometry radius = BorderRadius.only(
        topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0));

    newsProvider.addListener(() {
      setState(() {}); //TODO: Work around!!!!!
      if (newsProvider.showPanel == true) {
        _panelController.open();
      } else {
        _panelController.close();
      }
    });

    return Container(
      constraints: BoxConstraints.expand(),
      child: SlidingUpPanel(
          margin: EdgeInsets.only(left: 16, right: 16),
          minHeight: 0.0,
          borderRadius: radius,
          controller: _panelController,
          panelBuilder: (ScrollController sc) {
            return Container(
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
                controller: sc,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 16.0, right: 16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
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
                                  this._panelController.close();
                                },
                                icon: const Icon(Icons.close)),
                          ],
                        ),
                        newsProvider.currentNews.imageUrls != null
                            ? Container(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 16.0,
                                ),
                                constraints: BoxConstraints(
                                    minHeight: 100, maxHeight: 250),
                                child: Image.network(
                                    newsProvider.currentNews.imageUrls[0]))
                            : Container(),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(newsProvider.currentNews.content ?? "",
                                  style: Constants.defaultText)
                            ]),
                        Visibility(
                            visible: newsProvider.currentNews.link != "",
                            child: TextButton(
                                onPressed: () => {
                                      if (newsProvider.currentNews.link != null)
                                        {launch(newsProvider.currentNews.link)},
                                    },
                                style: Constants.polyGreenButton,
                                child: Text("Open Link",
                                    style: Constants.defaultTextWhite)))
                      ]),
                ),
              ),
            );
          }),
    );
  }
}
