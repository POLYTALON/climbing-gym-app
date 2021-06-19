import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/services/newsService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPanel extends StatefulWidget with GetItStatefulWidgetMixin {
  NewsDetailPanel({
    Key key,
  }) : super(key: key);

  @override
  _NewsDetailPanelState createState() => _NewsDetailPanelState();
}

class _NewsDetailPanelState extends State<NewsDetailPanel>
    with GetItStateMixin {
  _NewsDetailPanelState();
  final newsService = locator<NewsService>();

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
        topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0));
    final newsWatch = watchX((NewsService x) => x.currentNews);

    return Container(
      constraints: BoxConstraints.expand(),
      child: SlidingUpPanel(
        margin: EdgeInsets.only(left: 16, right: 16),
        minHeight: 0.0,
        borderRadius: radius,
        controller: newsService.panelControl,
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
                              newsService.currentNewsDetails.title ?? "",
                              style: Constants.headerText,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                this.newsService.panelControl.close();
                              },
                              icon: const Icon(Icons.close)),
                        ],
                      ),
                      newsWatch.imageUrls != null
                          ? Container(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 16.0,
                              ),
                              constraints: BoxConstraints(
                                  minHeight: 100, maxHeight: 250),
                              child: Image.network(newsWatch.imageUrls[0]))
                          : Container(),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: newsWatch.link != ""
                                  ? const EdgeInsets.only(bottom: 48)
                                  : null,
                              child: Text(newsWatch.content ?? "",
                                  style: Constants.defaultText),
                            )
                          ]),
                    ]),
              ),
            ),
          );
        },
        footer: Visibility(
            visible: newsWatch.link != "",
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => {
                        if (newsWatch.link != null) {launch(newsWatch.link)},
                      },
                      style: Constants.polyGreenButton,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 8, bottom: 8),
                        child: Text("Open Link",
                            style: Constants.defaultTextWhite),
                      ),
                    ),
                  ]),
            )),
      ),
    );
  }
}
