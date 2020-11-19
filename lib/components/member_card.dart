import 'package:flutter/material.dart';

import '../constants.dart';

class MemberCard extends StatelessWidget {
  final String userName;
  // final AssetImage userImage;
  final onPress;
  final bool isAllowedToDelete;

  MemberCard({this.onPress, this.userName, this.isAllowedToDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("images/placeholder_profile.png")),
          title: Text(
            userName,
            style: TextStyle(fontSize: 20),
          ),
          trailing: RawMaterialButton(
            onPressed: onPress,
            constraints: BoxConstraints(),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: isAllowedToDelete
                  ? Icon(
                      Icons.remove,
                      color: kTextColor,
                    )
                  : Icon(
                      Icons.remove,
                      color: Colors.grey,
                    ),
            ),
          ),
          autofocus: true,
        ),
        Divider(
          color: Colors.grey[500],
        ),
      ],
    );
  }
}
