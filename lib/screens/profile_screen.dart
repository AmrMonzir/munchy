import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static String id = "profile_screen";
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("House Members"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            child: Row(
              children: [
                Image(
                  image: Image,
                ),
                Text("User name"),
                Icon(Icons.remove)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
