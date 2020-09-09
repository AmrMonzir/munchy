import 'package:flutter/material.dart';

import '../constants.dart';

class MemberCard extends StatelessWidget {
  final String userName;
  final AssetImage userImage;
  final onPress;
  MemberCard({this.onPress, this.userImage, this.userName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(radius: 25, backgroundImage: userImage),
          title: Text(
            userName,
            style: TextStyle(fontSize: 20),
          ),
          trailing: RawMaterialButton(
            onPressed: () {
              //if current user.name == the user name of the curr index say
              //wtf you can't remove yourself
            },
            constraints: BoxConstraints(),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Icon(
                Icons.remove,
                color: kTextColor,
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
