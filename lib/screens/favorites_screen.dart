import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/components/recipe_card_for_fridge_screen.dart';
import 'package:munchy/model/recipe.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  var masterBloc = MasterBloc();

  List<Recipe> favRecipes = [];

  Future<List<Recipe>> getFavoriteRecipes() async {
    return favRecipes = await masterBloc.getFavoriteRecs();
  }

  @override
  void initState() {
    super.initState();
    masterBloc = BlocProvider.of<MasterBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => getFavoriteRecipes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          masterBloc.getRecs().then((value) => print(value));
        },
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return RecipeCard(
            recipe: favRecipes[index],
          );
        },
        itemCount: favRecipes.length,
      ),
    );
  }
}
