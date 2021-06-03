import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/News.dart';
import 'package:climbing_gym_app/screens/main/gyms.dart';
import 'package:climbing_gym_app/screens/navigationContainer.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/databaseService.dart';
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
    final auth = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder<AppUser>(
        stream: auth.streamAppUser(),
        initialData: new AppUser().empty(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState != ConnectionState.active) {
            return Container(width: 0.0, height: 0.0);
          } else {
            if (userSnapshot.data.selectedGym == null ||
                userSnapshot.data.selectedGym.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 50,
                      margin: EdgeInsets.all(16),
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(16.0),
                        color: Colors.green,
                      ),
                      child: Center(
                          child: Text("Please choose your gym",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)))),
                ],
              );
            } else {
              return StreamProvider<List<News>>.value(
                  initialData: [],
                  value: DatabaseService()
                      .streamNews(userSnapshot.data.selectedGym),
                  child: Consumer<List<News>>(builder: (context, news, _) {
                    return ChangeNotifierProvider<NewsDetails>(
                      create: (_) => NewsDetails(),
                      child: Stack(children: <Widget>[
                        Scaffold(
                            floatingActionButton:
                                _getIsPrivileged(userSnapshot.data)
                                    ? FloatingActionButton(
                                        child: const Icon(Icons.add),
                                        backgroundColor: Constants.polyGreen,
                                        onPressed: () => _toggleAddPanel(),
                                      )
                                    : null,
                            body: Container(
                                color: Constants.polyDark,
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(32),
                                    itemCount: news.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                          margin: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: NewsCard(news: news[index]));
                                    }))),
                        if (_getIsPrivileged(userSnapshot.data))
                          NewsAddPanel(
                              panelController: _newsAddPanelController,
                              gymid: userSnapshot.data.isOperator
                                  ? ""
                                  : userSnapshot.data.selectedGym),
                        NewsDetailPanel()
                      ]),
                    );
                  }));
            }
          }
        });
  }

  void _toggleAddPanel() {
    if (_newsAddPanelController.status == SlidingUpPanelStatus.expanded) {
      _newsAddPanelController.collapse();
    } else {
      _newsAddPanelController.anchor();
    }
  }

  bool _getIsPrivileged(AppUser appUser) {
    if (appUser == null) return false;
    if (appUser.selectedGym == null || appUser.selectedGym.isEmpty)
      return false;
    return appUser.isOperator ||
        (appUser.roles[appUser.selectedGym] != null &&
            appUser.roles[appUser.selectedGym].gymuser);
  }
}
