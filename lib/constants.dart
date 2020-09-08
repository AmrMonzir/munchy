import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.grey),
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF44336), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFF44336), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kBottomNavigationBarIconsAndStrings = {
  "Home": Icons.home,
  "My fridge": AssetImage('fridge.png'),
  "Recipes": Icons.room_service,
  "Me": Icons.account_circle,
  "Settings": Icons.settings,
};

const accentColor = Color(0xFFFF9800);
const primaryColor = Color(0xFFF44336);
const primaryColorDark = Color(0xffd32f2f);
const primaryColorLight = Color(0xFFFFcDD2);
const dividerColor = Color(0xFFBDBDBD);

// const kBottomNavigationBar = BottomNavigationBar(items: [],onTap: ,);
//
// BottomNavigationBar(
//   onTap: (index) {
//     switch (index) {
//       case 1:
//         Navigator.pushNamed(context, FridgeScreen.id);
//         break;
//       case 2:
//         Navigator.pushNamed(context, RecipesScreen.id);
//         break;
//       case 3:
//         Navigator.pushNamed(context, ProfileScreen.id);
//         break;
//       case 4:
//         Navigator.pushNamed(context, SettingsScreen.id);
//         break;
//     }
//   },
//   elevation: 15,
//   type: BottomNavigationBarType.fixed,
//   items: fillBottomNavigationBarContents(),
// );
