import 'package:flutter/material.dart';
import 'package:munchy/components/ingredient_card.dart';
import 'package:munchy/components/recipe_ingredients_card.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/model/recipe.dart';
import 'package:munchy/model/recipe_instructions.dart';

class RecipeScreen extends StatelessWidget {
  static String id = "recipe_screen";
  final int indexForHero;
  final Recipe recipe;
  RecipeScreen({this.indexForHero, this.recipe});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: kScaffoldBackgroundColor,
                expandedHeight: height * 2 / 3,
                collapsedHeight: height / 4,
                floating: false,
                pinned: true,
                snap: false,
                actionsIconTheme: IconThemeData(opacity: 0.0),
                flexibleSpace: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Hero(
                        tag: indexForHero.toString(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Image.network(
                            recipe.image,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: new EdgeInsets.all(16.0),
                sliver: new SliverList(
                  delegate: new SliverChildListDelegate([
                    TabBar(
                      onTap: (index) {
                        if (index == 0) {
                          //TODO fetch recipe ingredients (from init state actually)
                          //display recipe ingredients in the bottom container
                        } else if (index == 1) {
                          //display recipe steps in the bottom container
                        }
                      },
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(icon: Icon(Icons.menu), text: "Ingredients"),
                        Tab(
                            icon: Icon(Icons.restaurant_menu),
                            text: "Preparation Steps"),
                      ],
                    ),
                  ]),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              ListView.builder(
                itemBuilder: (context, itemBuilder) {
                  return RecipeIngredientsCard(
                    name: recipe.ingredientsList.elementAt(itemBuilder).name,
                    image: kBaseIngredientURL +
                        recipe.ingredientsList.elementAt(itemBuilder).image,
                  );
                  return IngredientCard(
                      ingObject: recipe.ingredientsList.elementAt(itemBuilder));
                  // return Text(
                  //     recipe.ingredientsList.elementAt(itemBuilder).name);
                },
                itemCount: recipe.ingredientsList.length,
              ),
              ListView.builder(
                itemBuilder: (context, itemBuilder) {
                  var recipeInstructions = RecipeInstructions.fromJson(
                      recipe.analyzedInstructions[itemBuilder]);
                  String allSteps = "";
                  for (var step in recipeInstructions.steps) {
                    if (step.step != null)
                      allSteps += "${step.number}_ ${step.step}  \n\n";
                  }
                  return Text(
                    allSteps,
                    style: TextStyle(fontSize: 18),
                  );
                },
                itemCount: recipe.analyzedInstructions.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
