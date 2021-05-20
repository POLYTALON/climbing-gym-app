import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/News.dart';
import 'package:climbing_gym_app/services/authservice.dart';
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

  @override
  Widget build(BuildContext context) {
    final news = Provider.of<List<News>>(context);
    final auth = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder<AppUser>(
        stream: auth.streamAppUser(),
        initialData: new AppUser().empty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return Container(width: 0.0, height: 0.0);
          } else {
            return ChangeNotifierProvider<NewsDetails>(
              create: (_) => NewsDetails(),
              child: Stack(children: <Widget>[
                Scaffold(
                    floatingActionButton:
                        _getFloatingActionButton(snapshot.data.isOperator),
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
                if (snapshot.data.isOperator)
                  NewsAddPanel(panelController: _newsAddPanelController),
                NewsDetailPanel()
              ]),
            );
          }
        });
  }

  Widget _getFloatingActionButton(bool value) {
    if (value) {
      return FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Constants.polyGreen,
        onPressed: () => _toggleAddPanel(),
      );
    }
    return Container(width: 0.0, height: 0.0);
  }

  void _toggleAddPanel() {
    if (_newsAddPanelController.status == SlidingUpPanelStatus.expanded) {
      _newsAddPanelController.collapse();
    } else {
      _newsAddPanelController.anchor();
    }
  }
}
