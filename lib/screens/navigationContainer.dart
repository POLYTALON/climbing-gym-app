import 'package:climbing_gym_app/screens/gyms.dart';
import 'package:climbing_gym_app/screens/news.dart';
import 'package:climbing_gym_app/screens/routes.dart';
import 'package:flutter/material.dart';

import 'package:climbing_gym_app/screens/home.dart';

class NavigationContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NavigationState();
  }
}

class _NavigationState extends State<NavigationContainer> {
  int _navBarIndex = 1;
  String _title;
  final List<Widget> _children = [
    GymsScreen(),
    HomeScreen(),
    NewsScreen(),
    RoutesScreen()
  ];

  @override
  initState() {
    super.initState();
    _title = 'HOME';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: _children[_navBarIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          currentIndex: _navBarIndex,
          items: [
            new BottomNavigationBarItem(
              icon: new Icon(Icons.location_on),
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
              icon: new Icon(Icons.alt_route),
              label: 'Routenbuch',
            ),
          ],
        ));
  }

  void onTabTapped(int index) {
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
