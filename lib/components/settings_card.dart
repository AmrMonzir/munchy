import 'package:flutter/material.dart';

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
