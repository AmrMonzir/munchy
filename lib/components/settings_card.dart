import 'package:flutter/material.dart';
import 'package:munchy/screens/global_ingredients_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../constants.dart';

class SettingCard extends StatelessWidget {
  final String settingName;
  final IconData settingIcon;
  final onPress;
  SettingCard({this.onPress, this.settingIcon, this.settingName});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPress,
      child: Column(
        children: [
          ListTile(
            leading: Icon(settingIcon),
            title: Text(
              settingName,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Divider(
            color: Colors.grey[500],
          ),
        ],
      ),
    );
  }
}
