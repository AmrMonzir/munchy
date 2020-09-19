import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:munchy/bloc/ing_bloc.dart';
import 'package:munchy/components/ings_widget.dart';
import 'package:munchy/components/meal_card.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/model/ingredient.dart';
import 'package:munchy/screens/recipes_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class RecipesCategoriesScreen extends StatefulWidget {
  static String id = "recipes_screen";
  @override
  _RecipesCategoriesScreenState createState() =>
      _RecipesCategoriesScreenState();
}

class _RecipesCategoriesScreenState extends State<RecipesCategoriesScreen> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      // This is handled by the search bar itself.
      resizeToAvoidBottomInset: false,
      body: buildFloatingSearchBar(),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      body: SafeArea(
        child: IndexedStack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MealCard(
                  image: AssetImage("images/breakfast.jpg"),
                  text: "Breakfast",
                  onPress: () {
                    //TODO API call to get breakfast recipes or get from local if exists
                    pushNewScreen(context,
                        screen: RecipesScreen(category: "Breakfast"));
                  },
                ),
                MealCard(
                  image: AssetImage("images/lunch.jpg"),
                  text: "Lunch",
                  onPress: () {
                    //TODO API call to get breakfast recipes or get from local if exists
                    pushNewScreen(context,
                        screen: RecipesScreen(category: "Lunch"));
                  },
                ),
                MealCard(
                  image: AssetImage("images/dinner.jpg"),
                  text: "Dinner",
                  onPress: () {
                    //TODO API call to get breakfast recipes or get from local if exists
                    pushNewScreen(context,
                        screen: RecipesScreen(category: "Dinner"));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      hint: 'Search for recipes...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      maxWidth: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
        //TODO add code to search for recipes here
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        // FloatingSearchBarAction(
        //   showIfOpened: false,
        //   child: CircularButton(
        //     icon: const Icon(Icons.place),
        //     onPressed: () {},
        //   ),
        // ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

/*Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        title: TextField(
          decoration: kSearchTextFieldDecoration.copyWith(
              hintText: "Search for recipe..."),
        ),
      ),
      body: SafeArea(
        child: new LayoutBuilder(builder: (context, constraints) {
          return ListView(
            children: [
              MealCard(
                image: AssetImage("images/breakfast.jpg"),
                text: "Breakfast",
                safeAreaHeight: constraints.maxHeight,
              ),
              MealCard(
                image: AssetImage("images/lunch.jpg"),
                text: "Lunch",
                safeAreaHeight: constraints.maxHeight,
              ),
              MealCard(
                image: AssetImage("images/dinner.jpg"),
                text: "Dinner",
                safeAreaHeight: constraints.maxHeight,
              ),
            ],
          );
        }),
      ),
    );*/