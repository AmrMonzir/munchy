import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/components/ingredient_card.dart';
import 'package:munchy/components/recipe_card_for_fridge_screen.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/model/ingredient.dart';
import 'package:munchy/model/recipe.dart';

bool _userHasFridge = false;

class FridgeScreen extends StatefulWidget {
  static String id = "fridge_screen";

  @override
  _FridgeScreenState createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  TextEditingController _controller;
  MasterBloc masterBloc;

  String _recipeToSearchFor = "";

  List<Recipe> listOfRecipes = [];

  void getTop3FavoriteRecipes() async {
    List<Recipe> nn = [];
    nn = await masterBloc.getFavoriteRecs(count: 3);
    setState(() {
      listOfRecipes.addAll(nn);
    });
  }

  @override
  void initState() {
    super.initState();
    masterBloc = BlocProvider.of<MasterBloc>(context);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getTop3FavoriteRecipes());
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    masterBloc.disposeRecController();
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
            children: [
              HorizontalRecipeCard(
                  recipe: listOfRecipes[0],
                  onPress: () {
                    _alertDialog(0);
                  }),
              HorizontalRecipeCard(
                  recipe: listOfRecipes[1],
                  onPress: () {
                    _alertDialog(1);
                  }),
              HorizontalRecipeCard(
                  recipe: listOfRecipes[2],
                  onPress: () {
                    _alertDialog(2);
                  }),
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

  Widget _alertDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
                Text("Do you want to subtract ingredients from your fridge?"),
            content: Container(
              height: 600,
              width: 400,
              child: ListView.builder(
                itemCount: listOfRecipes[index].ingredientsList.length,
                itemBuilder: (context, ingIndex) {
                  return CheckboxListTile(
                    value:
                        true, // TODO change to reflect whether or not it should be deleted from db
                    onChanged: (value) {
                      //same as above TODO
                    },
                    title: Text(
                        listOfRecipes[index].ingredientsList[ingIndex].name),
                    activeColor: kPrimaryColor,
                  );
                },
              ),
            ),
            actions: [
              RaisedButton(
                child: Text("Yes"),
                onPressed: () {
                  //TODO subtract ingredients from the user's fridge in here.
                  Navigator.of(context).pop();
                },
                color: kPrimaryColor,
              ),
              RaisedButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: kPrimaryColor,
              )
            ],
          );
        });
  }
}
