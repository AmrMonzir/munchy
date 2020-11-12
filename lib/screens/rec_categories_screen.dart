import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/components/meal_card.dart';
import 'package:munchy/components/recipe_card_for_fridge_screen.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/model/recipe.dart';
import 'package:munchy/screens/favorites_screen.dart';
import 'package:munchy/screens/recipe_screen.dart';
import 'package:munchy/screens/recipes_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'add_new_rec_screen.dart';

class RecipesCategoriesScreen extends StatefulWidget {
  static String id = "recipes_screen";
  @override
  _RecipesCategoriesScreenState createState() =>
      _RecipesCategoriesScreenState();
}

class _RecipesCategoriesScreenState extends State<RecipesCategoriesScreen> {
  TextEditingController _controller;
  MasterBloc masterBloc;
  List<Widget> searchColumn = [];

  @override
  void initState() {
    _controller = TextEditingController();
    masterBloc = BlocProvider.of<MasterBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => getFavs());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null, //to solve error that shows up for multiple hero tags
            child: Icon(
              Icons.add,
              color: kScaffoldBackgroundColor,
            ),
            onPressed: () {
              pushNewScreen(context, screen: AddNewRecipeScreen());
            },
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            child: Icon(
              Icons.star,
              color: kScaffoldBackgroundColor,
            ),
            onPressed: () {
              pushNewScreen(context,
                  screen: FavoritesScreen(),
                  pageTransitionAnimation: PageTransitionAnimation.slideUp);
            },
          )
        ],
      ),
      backgroundColor: kScaffoldBackgroundColor,
      // This is handled by the search bar itself.
      resizeToAvoidBottomInset: false,
      body: buildFloatingSearchBar(),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final width = MediaQuery.of(context).size.width;
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
                    pushNewScreen(context,
                        screen: RecipesScreen(category: "Breakfast"));
                  },
                ),
                MealCard(
                  image: AssetImage("images/lunch.jpg"),
                  text: "Lunch",
                  onPress: () {
                    pushNewScreen(context,
                        screen: RecipesScreen(category: "Lunch"));
                  },
                ),
                MealCard(
                  image: AssetImage("images/dinner.jpg"),
                  text: "Dinner",
                  onPress: () {
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
      maxWidth: isPortrait ? 600 : width,
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
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            children: searchColumn,
          ),
        );
      },
    );
  }

  Future<List<Widget>> getFavs() async {
    List<Recipe> list = await masterBloc.getFavoriteRecs();
    for (var rec in list) {
      searchColumn.add(
        HorizontalRecipeCard(
          recipe: rec,
          onPress: () {
            pushNewScreen(context, screen: RecipeScreen(recipe: rec));
          },
        ),
      );
    }
    return searchColumn;
  }
}
