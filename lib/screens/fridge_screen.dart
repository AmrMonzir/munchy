import 'package:flutter/material.dart';
import 'package:munchy/components/recipe_card_for_fridge_screen.dart';
import 'package:munchy/constants.dart';

bool _userHasFridge = false;

class FridgeScreen extends StatefulWidget {
  static String id = "fridge_screen";

  @override
  _FridgeScreenState createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  TextEditingController _controller;

  String _recipeToSearchFor = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              child: Hero(
                child: Image.asset(
                  'images/logo.png',
                  height: 60,
                  width: 30,
                ),
                tag: "logo",
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text("My fridge"),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "What did you cook today?",
                style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // RecipeCard(
              //   recipeName: "Sample recipe name",
              //   imagePath: AssetImage("images/placeholder_food.png"),
              // ),
              // RecipeCard(
              //   recipeName: "Sample recipe name",
              //   imagePath: AssetImage("images/placeholder_food.png"),
              // ),
              // RecipeCard(
              //   recipeName: "Sample recipe name",
              //   imagePath: AssetImage("images/placeholder_food.png"),
              // ),
            ],
          ),
          Column(
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2 - 20,
                    maxHeight: 80),
                child: TextField(
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: "Search for recipe"),
                  controller: _controller,
                  onChanged: (value) {
                    _recipeToSearchFor = value;
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Material(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                elevation: 5,
                color: kPrimaryColor,
                child: MaterialButton(
                  child: Text(
                    "Search",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
