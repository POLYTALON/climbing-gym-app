import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/News.dart';
import 'package:climbing_gym_app/screens/start.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/newsService.dart';
import 'package:climbing_gym_app/widgets/news/newsAddPanel.dart';
import 'package:climbing_gym_app/widgets/news/newsDetailPanel.dart';
import 'package:climbing_gym_app/widgets/news/newsCard.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

const polyDark = Color(0x121212);

class NewsScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen>
    with GetItStateMixin, AutomaticKeepAliveClientMixin<NewsScreen> {
  final PanelController _newsAddPanelController = PanelController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final auth = locator<AuthService>();

    return StreamBuilder<AppUser>(
        stream: auth.streamAppUser(),
        initialData: new AppUser().empty(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState != ConnectionState.active) {
            if (auth.currentUser == null) {
              auth.logout();
              return AlertDialog(
                title: Text(
                  'Logged out',
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                        'The User does not exist, you logged out!',
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => StartScreen()),
                            (Route<dynamic> route) => false);
                      },
                      child: Text("OK")),
                ],
              );
            }
            return Container(width: 0.0, height: 0.0);
          } else {
            if (userSnapshot.data.selectedGym == null ||
                userSnapshot.data.selectedGym.isEmpty) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text('Please choose a gym first.',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700))),
                    Icon(Icons.place, color: Colors.white, size: 32.0)
                  ]);
            } else {
              return StreamProvider<List<News>>.value(
                  initialData: [],
                  value:
                      NewsService().streamNews(userSnapshot.data.selectedGym),
                  child: Consumer<List<News>>(builder: (context, news, _) {
                    return Stack(children: <Widget>[
                      Scaffold(
                        floatingActionButton:
                            _getIsPrivileged(userSnapshot.data)
                                ? FloatingActionButton(
                                    heroTag: "news",
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
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: NewsCard(
                                          news: news[index],
                                          isDeletable: userSnapshot
                                                  .data.isOperator
                                              ? true
                                              : userSnapshot.data.selectedGym ==
                                                      news[index].gymid &&
                                                  _getIsPrivileged(
                                                      userSnapshot.data)));
                                })),
                      ),
                      if (_getIsPrivileged(userSnapshot.data))
                        NewsAddPanel(
                            panelController: _newsAddPanelController,
                            gymid: userSnapshot.data.isOperator
                                ? ""
                                : userSnapshot.data.selectedGym),
                      NewsDetailPanel()
                    ]);
                  }));
            }
          }
        });
  }

  void _toggleAddPanel() {
    if (_newsAddPanelController.isPanelOpen) {
      _newsAddPanelController.close();
    } else {
      _newsAddPanelController.open();
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
