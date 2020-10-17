import 'dart:io';

import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/components/recipe_ingredients_card.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/model/recipe.dart';

class RecipeScreen extends StatefulWidget {
  static String id = "recipe_screen";
  final int indexForHero;
  final Recipe recipe;
  RecipeScreen({this.indexForHero, this.recipe});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

// all the bloc logic here is just to create favorite recipes for now

class _RecipeScreenState extends State<RecipeScreen> {
  MasterBloc masterBloc;
  IconData iconData = Icons.favorite_border;

  void favoriteIcon() {
    if (widget.recipe.isFavorite) {
      setState(() {
        iconData = Icons.favorite;
      });
    } else {
      setState(() {
        iconData = Icons.favorite_border;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    masterBloc = BlocProvider.of<MasterBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => favoriteIcon());
    // streamSubscription =
    //     masterBloc.registerToRecStreamController(recipeNotificationReceived);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getImageURL() {
    if (!widget.recipe.image.contains("image_picker"))
      return Image.network(widget.recipe.image,
          fit: BoxFit.fitWidth, width: 80, height: 80);
    try {
      return Image.file(File(widget.recipe.image),
          fit: BoxFit.fitWidth, width: 80, height: 80);
    } catch (e) {
      return Image.asset("images/placeholder_food.png",
          fit: BoxFit.fitWidth, width: 80, height: 80);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: iconData == Icons.favorite
            ? Icon(
                iconData,
                color: kPrimaryColor,
              )
            : Icon(iconData),
        onPressed: () async {
          iconData == Icons.favorite_border
              ? masterBloc.addRec(widget.recipe).then((value) {
                  setState(() {
                    favoriteIcon();
                  });
                })
              : masterBloc.deleteRec(widget.recipe).then((value) {
                  setState(() {
                    favoriteIcon();
                    iconData = Icons.favorite_border;
                  });
                });
        },
      ),
      backgroundColor: kScaffoldBackgroundColor,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: kScaffoldBackgroundColor,
                expandedHeight: height * 1.82 / 5,
                collapsedHeight: height / 4,
                floating: false,
                pinned: true,
                snap: false,
                actionsIconTheme: IconThemeData(opacity: 0.0),
                flexibleSpace: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Hero(
                        tag: widget.indexForHero.toString(),
                        child: getImageURL(),
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
                itemBuilder: (context, index) {
                  return RecipeIngredientsCard(
                    name: widget.recipe.ingredientsList.elementAt(index).name,
                    image: widget.recipe.image.contains("image_picker")
                        ? widget.recipe.ingredientsList.elementAt(index).image
                        : kBaseIngredientURL +
                            widget.recipe.ingredientsList
                                .elementAt(index)
                                .image,
                  );
                },
                itemCount: widget.recipe.ingredientsList.length,
              ),
              ListView.builder(
                itemBuilder: (context, index) {
                  var recipeInstructions =
                      widget.recipe.analyzedInstructions[index];
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
                itemCount: widget.recipe.analyzedInstructions.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
