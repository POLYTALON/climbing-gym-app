import 'package:auto_size_text/auto_size_text.dart';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/Gym.dart';
import 'package:climbing_gym_app/screens/start.dart';
import 'package:climbing_gym_app/services/gymService.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:climbing_gym_app/widgets/gyms/gymPreviewCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class GymsPreviewScreen extends StatefulWidget {
  @override
  _GymsPreviewScreenState createState() => _GymsPreviewScreenState();
}

class _GymsPreviewScreenState extends State<GymsPreviewScreen> {
  final ScrollController sc = ScrollController();
  final controllerGymName = TextEditingController(text: "");
  List<Gym> gymsList = [];
  bool isSearched = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return StreamProvider<List<Gym>>.value(
        initialData: [],
        value: GymService().streamGyms(),
        child: Consumer<List<Gym>>(builder: (context, gyms, _) {
          return Stack(children: <Widget>[
            Scaffold(
                backgroundColor: Constants.polyDark,
                // Page content
                body: Container(
                    child: Column(children: [
                  Row(children: [
                    // Back Button
                    Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 48.0, 0.0, 16.0),
                        child: RawMaterialButton(
                            onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (countext) => StartScreen()))
                                },
                            elevation: 2.0,
                            fillColor: Colors.grey,
                            child: Icon(Icons.arrow_back_rounded, size: 32.0),
                            padding: EdgeInsets.all(8.0),
                            shape: CircleBorder())),
                    // Text
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
                      child: Text("Available Gyms",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 24)),
                    ),
                  ]),
                  // Search Bar
                  Padding(
                      padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                      child: TextField(
                          textInputAction: TextInputAction.search,
                          onChanged: (_) => updateSearchList(gyms),
                          controller: controllerGymName,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(fontWeight: FontWeight.w800),
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(
                              hintText: 'Search',
                              contentPadding: const EdgeInsets.only(left: 16.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none)),
                              fillColor: Colors.white,
                              filled: true))),

                  // GridView (with GymPreviewCards)
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(children: <Widget>[
                    GridView.count(
                        controller: sc,
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: (itemWidth / itemHeight),
                        children: List.generate(
                            isSearched ? gymsList.length : gyms.length,
                            (index) {
                          return Container(
                              child: GymPreviewCard(
                                  gym: isSearched
                                      ? gymsList[index]
                                      : gyms[index]));
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
                                  onPressed: () =>
                                      launch(emailLaunchUri().toString()),
                                  child: AutoSizeText("info@polytalon.com",
                                      style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: 16,
                                          decoration: TextDecoration.underline),
                                      maxLines: 1))
                            ]))),
                    Divider()
                  ]))),
                ]))),
          ]);
        }));
  }

  void updateSearchList(List<Gym> gyms) {
    print("seacrhgin");
    this.isSearched = true;
    if (controllerGymName.text.trim().isEmpty)
      this.gymsList = gyms;
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
      this.gymsList = this.gymsList.toSet().toList();
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
