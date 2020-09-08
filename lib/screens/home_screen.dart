import 'package:flutter/material.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/screens/fridge_screen.dart';
import 'package:munchy/screens/profile_screen.dart';
import 'package:munchy/screens/recipes_screen.dart';
import 'package:munchy/screens/settings_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeScreen extends StatefulWidget {
  static String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BottomNavigationBarItem> fillBottomNavigationBarContents() {
    List<BottomNavigationBarItem> itemList = [];
    kBottomNavigationBarIconsAndStrings.forEach((key, value) {
      BottomNavigationBarItem item;
      if (key == "My fridge") {
        item = BottomNavigationBarItem(
          title: Text(
            key,
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
          icon: Image(
              width: 30, height: 35, image: AssetImage("images/fridge.png")),
        );
      } else {
        item = BottomNavigationBarItem(
          title: Text(
            key,
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
          ),
          icon: Icon(
            kBottomNavigationBarIconsAndStrings[key],
            color: accentColor,
          ),
        );
      }
      itemList.add(item);
    });
    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RaisedButton(
            child: Text("Button"),
            onPressed: (){
              Navigator.pushNamed(context, routeName)
            },
          )
        ],
      ),
    );
  }
}

/*bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, FridgeScreen.id);
              break;
            case 2:
              Navigator.pushNamed(context, RecipesScreen.id);
              break;
            case 3:
              Navigator.pushNamed(context, ProfileScreen.id);
              break;
            case 4:
              Navigator.pushNamed(context, SettingsScreen.id);
              break;
          }
        },
        elevation: 15,
        type: BottomNavigationBarType.fixed,
        items: fillBottomNavigationBarContents(),
      ),*/
