import 'dart:io';

import 'package:climbing_gym_app/models/News.dart';
import 'package:climbing_gym_app/view_models/newsDetails.dart';
import 'package:climbing_gym_app/widgets/news/newsAddPanel.dart';
import 'package:climbing_gym_app/widgets/news/newsDetailPanel.dart';
import 'package:climbing_gym_app/widgets/news/newsCard.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:provider/provider.dart';

const polyDark = Color(0x121212);

class NewsScreen extends StatelessWidget {
  final SlidingUpPanelController _newsAddPanelController =
      SlidingUpPanelController();
  final SlidingUpPanelController _newsDetailPanelController =
      SlidingUpPanelController();

  void _toggleAddPanel() {
    if (_newsAddPanelController.status == SlidingUpPanelStatus.expanded) {
      _newsAddPanelController.collapse();
    } else {
      _newsAddPanelController.anchor();
    }
  }

  @override
  Widget build(BuildContext context) {
    var news = Provider.of<List<News>>(context);

    return ChangeNotifierProvider<NewsDetails>(
      create: (_) => NewsDetails(),
      child: Stack(children: <Widget>[
        Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _toggleAddPanel(),
              backgroundColor: Constants.polyGreen,
            ),
            body: Container(
                color: Constants.polyDark,
                child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: news.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          child: NewsCard(news: news[index]));
                    }))),
        NewsAddPanel(panelController: _newsAddPanelController),
        NewsDetailPanel()
      ]),
    );
  }
}
