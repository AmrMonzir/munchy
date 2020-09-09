import 'package:flutter/cupertino.dart';
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
  String welcomeText = "Have you had breakfast yet?";
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                welcomeText,
                style: TextStyle(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
