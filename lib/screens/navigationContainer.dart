import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/screens/main/gyms.dart';
import 'package:climbing_gym_app/screens/main/home.dart';
import 'package:climbing_gym_app/screens/main/news.dart';
import 'package:climbing_gym_app/screens/main/routes.dart';
import 'package:climbing_gym_app/screens/main/developers.dart';
import 'package:climbing_gym_app/services/pageviewService.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:get_it_mixin/get_it_mixin.dart';

class NavigationContainer extends StatefulWidget with GetItStatefulWidgetMixin {
  @override
  State<StatefulWidget> createState() {
    return _NavigationState();
  }
}

class _NavigationState extends State<NavigationContainer> with GetItStateMixin {
  PageController _pageController = new PageController(
    initialPage: 0,
  );
  int _navBarIndex = 0;
  String _title;
  List<Widget> _children;
  int _newsCounter = 0;
  int _homeCounter = 0;
  int _gymsCounter = 0;
  final routesService = locator<PageViewService>();

  @override
  initState() {
    _children = [GymsScreen(), HomeScreen(), NewsScreen(), RoutesScreen()];
    super.initState();
    _title = 'GYM';
  }

  @override
  Widget build(BuildContext context) {
    bool isPageSwiping = watchX((PageViewService s) => s.isSwipingAllowed);
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
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
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
          physics: isPageSwiping
              ? ScrollPhysics()
              : new NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            changeTitle(index);
          },
          children: <Widget>[
            _children[0],
            _children[1],
            _children[2],
            _children[3],
          ]),

      // BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[800],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          onTabTapped(index);
          secret(index);
        },
        currentIndex: _navBarIndex,
        items: [
          new BottomNavigationBarItem(
            icon:
                ImageIcon(AssetImage('assets/img/holdsFilled.ico'), size: 24.0),
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
    );
  }

  void secret(int input) {
    switch (input) {
      case 0:
        {
          if (_gymsCounter != 4 &&
              _gymsCounter < 4 &&
              _homeCounter == 0 &&
              _newsCounter == 0) {
            _gymsCounter++;
          } else {
            secret(4);
          }
        }
        break;
      case 1:
        {
          if (_gymsCounter == 4 &&
              _homeCounter != 6 &&
              _homeCounter < 6 &&
              _newsCounter == 0) {
            _homeCounter++;
          } else {
            secret(4);
          }
        }
        break;
      case 2:
        {
          if (_gymsCounter == 4 &&
              _homeCounter == 6 &&
              _newsCounter != 7 &&
              _newsCounter < 7) {
            _newsCounter++;
          } else {
            secret(4);
          }
        }
        break;
      default:
        {
          _newsCounter = 0;
          _homeCounter = 0;
          _gymsCounter = 0;
        }
        break;
    }

    if (_gymsCounter == 4 && _homeCounter == 6 && _newsCounter == 7) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DevelopersScreen()),
      );
      _newsCounter = 0;
      _homeCounter = 0;
      _gymsCounter = 0;
    }
  }

  void onTabTapped(int index) async {
    await _pageController.animateToPage(index,
        duration: Duration(milliseconds: 100), curve: Curves.easeOut);
    changeTitle(index);
  }

  void changeTitle(int index) {
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
