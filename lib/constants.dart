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

const kAccentColor = Color(0xFFFF9800);
const kPrimaryColor = Color(0xFFF44336);
const kPrimaryColorDark = Color(0xffd32f2f);
const kPrimaryColorLight = Color(0xFFFFcDD2);
const kDividerColor = Color(0xFFBDBDBD);
const kTextColor = Color(0xFF212121);
const kScaffoldBackgroundColor = Color(0xFFfff8ed);

const kTextStylePoppins = TextStyle(fontFamily: "Poppins", fontSize: 20);

const kBaseIngredientURL =
    " https://spoonacular.com/cdn/ingredients_100x100/"; //append jpg name

const List<String> kCategoriesList = [
  "main course",
  "side dish",
  "dessert",
  "appetizer",
  "salad",
  "bread",
  "breakfast",
  "soup",
  "beverage",
  "sauce",
  "snack",
  "drink"
];
