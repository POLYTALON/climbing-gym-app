import 'package:auto_size_text/auto_size_text.dart';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/Gym.dart';
import 'package:climbing_gym_app/models/UserRole.dart';
import 'package:climbing_gym_app/screens/start.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/gymService.dart';
import 'package:climbing_gym_app/widgets/gyms/gymCard.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:climbing_gym_app/widgets/gyms/gymsAddPanel.dart';
import 'package:climbing_gym_app/widgets/gyms/gymsEditBuilderPanel.dart';
import 'package:climbing_gym_app/widgets/gyms/gymsEditPanel.dart';
import 'package:climbing_gym_app/widgets/gyms/gymsSetOwnerPanel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class GymsScreen extends StatefulWidget {
  @override
  _GymsScreenState createState() => _GymsScreenState();
}

class _GymsScreenState extends State<GymsScreen>
    with AutomaticKeepAliveClientMixin<GymsScreen> {
  final PanelController _gymsAddPanelController = PanelController();
  final ScrollController sc = ScrollController();
  final controllerGymName = TextEditingController(text: "");
  List<Gym> gymsList = [];
  bool isSearched = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final auth = locator<AuthService>();
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return StreamBuilder<AppUser>(
        stream: auth.streamAppUser(),
        initialData: new AppUser().empty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active ||
              !snapshot.hasData) {
            if (auth.currentUser == null) {
              auth.logout();
              return locator<AuthService>().showLogoutDialog(context);
            }
            return Center(
              child: CircularProgressIndicator(color: Constants.polyGreen),
            );
          } else {
            return Stack(children: <Widget>[
              Scaffold(
                // Add gym button
                floatingActionButton:
                    _getFloatingActionButton(snapshot.data.isOperator),
                backgroundColor: Constants.polyDark,

                // Page content
                body: StreamBuilder(
                    stream: locator<GymService>().streamGyms(),
                    builder: (context, gymsSnapshot) {
                      if (gymsSnapshot.connectionState !=
                              ConnectionState.active ||
                          !gymsSnapshot.hasData) {
                        return Center(
                            child: CircularProgressIndicator(
                                color: Constants.polyGreen));
                      } else {
                        // gymsList = gymsSnapshot.data;
                        return Container(
                          child: Column(children: [
                            // Text
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text("Choose Your Gym",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24)),
                            ),
                            // Search Bar
                            Padding(
                                padding:
                                    EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                                child: TextField(
                                    textInputAction: TextInputAction.search,
                                    onSubmitted: (_) => updateSearchList(
                                        gymsSnapshot.data as List<Gym>),
                                    controller: controllerGymName,
                                    autocorrect: false,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800),
                                    keyboardType: TextInputType.text,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        hintText: 'Search',
                                        contentPadding:
                                            const EdgeInsets.only(left: 16.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                            borderSide: BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                        fillColor: Colors.white,
                                        filled: true))),
                            // GridView (with GymCards)
                            Expanded(
                                child: SingleChildScrollView(
                                    child: Column(children: <Widget>[
                              GridView.count(
                                  padding: const EdgeInsets.all(0),
                                  controller: sc,
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  childAspectRatio: (itemWidth / itemHeight),
                                  children: List.generate(
                                      isSearched
                                          ? gymsList.length
                                          : gymsSnapshot.data.length, (index) {
                                    return Container(
                                        child: GymCard(
                                            gym: isSearched
                                                ? gymsList[index]
                                                : gymsSnapshot.data[index],
                                            appUser: snapshot.data));
                                  })),
                              Divider(),
                              FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Container(
                                      padding: EdgeInsets.all(16.0),
                                      child: Row(children: [
                                        AutoSizeText(
                                            "Can't find your gym? Please write a mail to",
                                            style: Constants.defaultTextWhite,
                                            maxLines: 1),
                                        TextButton(
                                            onPressed: () => launch(
                                                emailLaunchUri().toString()),
                                            child: AutoSizeText(
                                                "info@polytalon.com",
                                                style: TextStyle(
                                                    color: Colors.greenAccent,
                                                    fontSize: 16,
                                                    decoration: TextDecoration
                                                        .underline),
                                                maxLines: 1))
                                      ]))),
                              Divider()
                            ])))
                          ]),
                        );
                      }
                    }),
              ),
              if (_getIsAnyGymUser(snapshot.data.roles)) GymsEditBuilderPanel(),
              if (snapshot.data.isOperator)
                GymsAddPanel(panelController: _gymsAddPanelController),
              if (snapshot.data.isOperator) GymsSetOwnerPanel(),
              if (snapshot.data.isOperator ||
                  _getIsAnyGymUser(snapshot.data.roles))
                GymsEditPanel(),
            ]);
          }
        });
  }

  Widget _getFloatingActionButton(bool value) {
    if (value) {
      return FloatingActionButton(
        heroTag: "gyms",
        child: const Icon(Icons.add),
        backgroundColor: Constants.polyGreen,
        onPressed: () => _gymsAddPanelController.open(),
      );
    }
    return Container(width: 0.0, height: 0.0);
  }

  bool _getIsAnyGymUser(Map<String, UserRole> roles) {
    bool isAnyGymUser = false;
    roles.forEach((key, value) {
      if (value.gymuser) isAnyGymUser = true;
    });
    return isAnyGymUser;
  }

  void updateSearchList(List<Gym> gyms) {
    if (controllerGymName.text.trim().isEmpty)
      setState(() {
        this.gymsList = gyms;
        this.isSearched = true;
      });
    else {
      this.gymsList = [];
      controllerGymName.text
          .toLowerCase()
          .trim()
          .split(" ")
          .forEach((searchTerm) {
        this.gymsList.addAll(gyms
            .where((gym) => (gym.name + '' + gym.city)
                .toLowerCase()
                .trim()
                .contains(searchTerm))
            .toList());
      });
      setState(() {
        this.gymsList = this.gymsList.toSet().toList();
        this.isSearched = true;
      });
    }
  }

  Uri emailLaunchUri() {
    return Uri(
      scheme: 'mailto',
      path: 'info@polytalon.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Request: Please add our gym to GripGuide'
      }),
    );
  }

  String encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
