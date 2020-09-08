import 'package:flutter/material.dart';

class FridgeScreen extends StatefulWidget {
  static String id = "fridge_screen";
  @override
  _FridgeScreenState createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // bottomNavigationBar: ,
      child: Text("Fridge Screen"),
    );
  }
}
