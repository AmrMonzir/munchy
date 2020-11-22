import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:munchy/components/settings_card.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/model/ing_dao.dart';
import 'package:munchy/screens/global_ingredients_screen.dart';
import 'package:munchy/screens/local_ings_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class SettingsScreen extends StatefulWidget {
  static String id = "settings_screen";
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  IngredientsDao ingredientsDao = IngredientsDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.settings),
            SizedBox(width: 8),
            Text(
              "Settings",
              style:
                  TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold),
            ),
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
          SettingCard(
            settingIcon: Icons.file_download,
            settingName: "Import ingredients list",
            onPress: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title:
                          Text("Are you sure you want to import ingredients?"),
                      actions: [
                        RaisedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: kAccentColor,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        RaisedButton(
                          child: Text("Yes"),
                          color: kPrimaryColor,
                          onPressed: () async {
                            ingredientsDao.insertIngsInDB();
                          },
                        )
                      ],
                    );
                  });
            },
          ),
          SettingCard(
            settingIcon: Icons.delete_outline,
            settingName: "Delete Ingredient lists",
            onPress: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                          "Are you sure you want to delete your ingredients lists?"),
                      actions: [
                        RaisedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: kAccentColor,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        RaisedButton(
                          child: Text("Yes"),
                          color: kPrimaryColor,
                          onPressed: () async {
                            ingredientsDao.deleteAllIngs();
                          },
                        )
                      ],
                    );
                  });
            },
          ),
          SettingCard(
            settingIcon: Icons.input,
            settingName: "Sign out",
            onPress: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Are you sure you want to log out?"),
                      actions: [
                        RaisedButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: kAccentColor,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        RaisedButton(
                          child: Text("Yes"),
                          color: kPrimaryColor,
                          onPressed: () {
                            _auth.signOut();
                            Phoenix.rebirth(context);
                          },
                        )
                      ],
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
