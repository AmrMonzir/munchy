import 'package:flutter/material.dart';
import 'package:munchy/components/settings_card.dart';
import 'package:munchy/screens/global_ingredients_screen.dart';
import 'package:munchy/screens/local_ings_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class SettingsScreen extends StatefulWidget {
  static String id = "settings_screen";
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.settings),
            SizedBox(width: 8),
            Text("Settings"),
          ],
        ),
      ),
      body: ListView(
        children: [
          SettingCard(
            settingIcon: Icons.restaurant,
            settingName: "Global Ingredients List",
            onPress: () {
              pushNewScreen(context,
                  screen: GlobalIngredientsScreen(),
                  pageTransitionAnimation: PageTransitionAnimation.slideUp);
            },
          ),
          SettingCard(
            settingIcon: Icons.kitchen,
            settingName: "Local Ingredients List",
            onPress: () {
              pushNewScreen(context,
                  screen: LocalIngsScreen(),
                  pageTransitionAnimation: PageTransitionAnimation.slideUp);
            },
          ),
        ],
      ),
    );
  }
}
