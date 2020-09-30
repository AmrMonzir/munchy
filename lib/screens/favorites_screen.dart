import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/components/recipe_card_for_fridge_screen.dart';
import 'package:munchy/model/recipe.dart';
import 'package:munchy/screens/recipe_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  var masterBloc = MasterBloc();

  List<Recipe> favRecipes = [];

  Future<void> getFavoriteRecipes() async {
    List<Recipe> l = [];
    l = await masterBloc.getFavoriteRecs();
    setState(() {
      favRecipes = l;
    });
  }

  @override
  void initState() {
    super.initState();
    masterBloc = BlocProvider.of<MasterBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => getFavoriteRecipes());
  }

  @override
  void dispose() {
    super.dispose();
    masterBloc.disposeRecController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Recipes"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return HorizontalRecipeCard(
                recipe: favRecipes[index],
                onPress: () {
                  pushNewScreen(context,
                      screen: RecipeScreen(recipe: favRecipes[index]));
                },
              );
            },
            itemCount: favRecipes.length,
          ),
        ),
      ),
    );
  }
}
