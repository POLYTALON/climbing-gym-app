import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;

class DevelopersScreen extends StatelessWidget {
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
              actions: [
                IconButton(
                  icon: Image.asset('assets/img/polytalon_logo_notext.png'),
                  onPressed: () {},
                )
              ],
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text("EASTER-EGG",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ]),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(2.0),
                child: Container(
                  color: Colors.white38,
                  height: 2.0,
                  margin: const EdgeInsets.only(left: 19.0, right: 19.0),
                ),
              ))),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(
              left: 19.0, right: 19.0, top: 30.0, bottom: 50.0),
          constraints: BoxConstraints.expand(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, right: 18.0, top: 18.0, bottom: 10.0),
              child: Text("Congratulations you found the Easter Egg!",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  )),
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
              child: Center(
                child: Text(
                    "This app was developed by:\n\nAndreas Ly\n"
                    "Bernhard Gundel\nJulian Sabo\nNail Özmen\n"
                    "Sascha Villing\nSebastian Voigt\nTimmy Pfau",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.white,
                          offset: Offset(-5.0, 5.0),
                        ),
                      ],
                    )),
              ),
            ),
          ]),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Constants.polyGray,
          ),
        ),
      ),
    );
  }
}
