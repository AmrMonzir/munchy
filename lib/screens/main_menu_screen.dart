import 'package:flutter/material.dart';
import 'package:munchy/screens/home_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MainMenu extends StatefulWidget {
  static String id = "main_menu";

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              child: Hero(
                child: Image.asset(
                  'images/logo.png',
                  height: 60,
                  width: 30,
                ),
                tag: "logo",
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text("Munchy"),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text("asd"),
          ),
          SizedBox(height: 20.0),
          Center(
            child: Text("asd"),
          ),
        ],
      ),
    );
  }
}
