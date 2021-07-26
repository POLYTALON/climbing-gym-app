import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      backgroundColor: Constants.polyDark,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(64.0),
          child: AppBar(
              brightness: Brightness.dark,
              backgroundColor: Constants.polyDark,
              //automaticallyImplyLeading: false, // removes back-arrow
              actions: [
                IconButton(
                    icon: Image.asset('assets/img/polytalon_logo_notext.png'),
                    onPressed: null)
              ],
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          AutoSizeText("ABOUT ",
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.w900)),
                          AutoSizeText("POLYTALON",
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    )
                  ]),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(2.0),
                child: Container(
                  color: Colors.white38,
                  height: 2.0,
                  margin: const EdgeInsets.only(left: 19.0, right: 19.0),
                ),
              ))),
      body: Container(
        margin: const EdgeInsets.only(
            left: 19.0, right: 19.0, top: 30.0, bottom: 50.0),
        constraints: BoxConstraints.expand(),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 18.0, right: 18.0, top: 18.0, bottom: 10.0),
                child: Text(
                    "INNOVATIONS THROUGHOUT\nTHE VALUE CHAIN FOR YOUR\nADVANTAGES",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: PreferredSize(
                  preferredSize: Size.fromHeight(2.0),
                  child: Container(
                    color: Colors.white38,
                    height: 2.0,
                    margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 18.0, right: 18.0, top: 15.0),
                child: Text(
                    "POLYTALON produces climbing holds in a ground-breaking way: Automated, fast and sustainable. Local production for reasonable prices – realised by outstanding engineering. \n\nOur long lasting silicon molds (patent pending)save material and provide a fully automated demoulding – Essential when it comes to production in the heart of europe. \n\nMade-to-measure PU resins ensure high durabilty and ultimate grip of our climbing holds. Preventing breakage of edges maximizing lifetime at the wall. \n\nLess waste and less production time. POLYTALON ensures highest production standards putting the customer first.",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
              ),
              Expanded(
                child: Center(
                  child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                              image: new AssetImage(
                                'assets/img/poly_hold_image.jpg',
                              ),
                              fit: BoxFit.cover))),
                ),
              )
            ]),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Constants.polyGray,
        ),
      ),
    );
  }
}
