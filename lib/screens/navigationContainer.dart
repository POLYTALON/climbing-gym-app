import 'package:climbing_gym_app/screens/main/gyms.dart';
import 'package:climbing_gym_app/screens/main/news.dart';
import 'package:climbing_gym_app/screens/main/routes.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/screens/home.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;

class NavigationContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavigationState();
  }
}

class _NavigationState extends State<NavigationContainer> {
  PageController _pageController = new PageController(
    initialPage: 0,
  );
  int _navBarIndex = 0;
  String _title;
  List<Widget> _children;

  @override
  initState() {
    _children = [GymsScreen(), HomeScreen(), NewsScreen(), RoutesScreen()];
    super.initState();
    _title = 'GYM';
  }

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
                automaticallyImplyLeading: false, // removes back-arrow
                actions: [
                  IconButton(
                    icon: Image.asset('assets/img/polytalon_logo_notext.png'),
                    onPressed: () {},
                  )
                ],
                title: Text(_title,
                    style:
                        TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(2.0),
                  child: Container(
                    color: Colors.white38,
                    height: 2.0,
                    margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                  ),
                ))),
        body: PageView(
            //Swipe through screens
            controller: _pageController,
            onPageChanged: (index) {
              onTabTapped(index);
            },
            children: <Widget>[
              _children[0],
              _children[1],
              _children[2],
              _children[3],
            ]),

        // body: _children[_navBarIndex],

        // BottomNavigationBar
        bottomNavigationBar: SizedBox(
          height: 75,
          child: BottomNavigationBar(
            backgroundColor: Colors.grey[800],
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey[500],
            type: BottomNavigationBarType.fixed,
            onTap: onTabTapped,
            currentIndex: _navBarIndex,
            items: [
              new BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/img/holdsFilled.ico'),
                    size: 24.0),
                label: 'Gyms',
              ),
              new BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                label: 'Home',
              ),
              new BottomNavigationBarItem(
                icon: new Icon(Icons.mail),
                label: 'News',
              ),
              new BottomNavigationBarItem(
                icon: new Icon(Icons.book_rounded),
                label: 'Routenbuch',
              ),
            ],
          ),
        ));
  }

  void onTabTapped(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _navBarIndex = index;
      switch (index) {
        case 0:
          {
            _title = 'GYMS';
          }
          break;
        case 1:
          {
            _title = 'HOME';
          }
          break;
        case 2:
          {
            _title = 'NEWS';
          }
          break;
        case 3:
          {
            _title = 'ROUTENBUCH';
          }
          break;
      }
    });
  }
}
