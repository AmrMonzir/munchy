import 'package:flutter/material.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/screens/fridge_screen.dart';
import 'package:munchy/screens/home_screen.dart';
import 'package:munchy/screens/profile_screen.dart';
import 'package:munchy/screens/recipes_screen.dart';
import 'package:munchy/screens/settings_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NavBarInitiator extends StatefulWidget {
  static String id = "navbar_initiator";
  final BuildContext menuScreenContext;
  const NavBarInitiator({Key key, this.menuScreenContext}) : super(key: key);

  @override
  _NavBarInitiatorState createState() => _NavBarInitiatorState();
}

class _NavBarInitiatorState extends State<NavBarInitiator> {
  PersistentTabController _controller;
  bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      FridgeScreen(),
      RecipesScreen(),
      ProfileScreen(),
      SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> fillBottomNavigationBarContents() {
    List<PersistentBottomNavBarItem> itemList = [];
    kBottomNavigationBarIconsAndStrings.forEach((key, value) {
      PersistentBottomNavBarItem item;
      if (key == "My fridge") {
        item = PersistentBottomNavBarItem(
          title: key,
          icon: Image(
              width: 30, height: 35, image: AssetImage("images/fridge.png")),
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
        );
      } else {
        item = PersistentBottomNavBarItem(
          title: key,
          icon: Icon(
            kBottomNavigationBarIconsAndStrings[key],
            color: accentColor,
          ),
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
        );
      }
      itemList.add(item);
    });
    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        controller: _controller,
        screens: _buildScreens(),
        items: fillBottomNavigationBarContents(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        hideNavigationBar: _hideNavBar,
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style7 // Choose the nav bar style with this property
        );
  }
}
