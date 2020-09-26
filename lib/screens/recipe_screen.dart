import 'dart:async';

import 'package:flutter/material.dart';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/master_bloc.dart';
import 'package:munchy/bloc/rec_event.dart';
import 'package:munchy/components/ingredient_card.dart';
import 'package:munchy/components/recipe_ingredients_card.dart';
import 'package:munchy/constants.dart';
import 'package:munchy/model/recipe.dart';
import 'package:munchy/model/recipe_instructions.dart';

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
  // StreamSubscription<RecipeEvent> streamSubscription;

  //default state for the icon is to be empty unless acted upon by an event
  IconData iconData = Icons.favorite_border;

  // void recipeNotificationReceived(RecipeEvent event) {
  //   if (event.eventType == RecEventType.add) {
  //     setState(() {
  //       iconData = Icons.favorite;
  //     });
  //   } else {
  //     // delete event
  //     setState(() {
  //       iconData = Icons.favorite_border;
  //     });
  //   }
  // }

  void favoriteIcon() {
    if (iconData == Icons.favorite_border) {
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
    // TODO: implement initState
    super.initState();
    masterBloc = BlocProvider.of<MasterBloc>(context);
    // streamSubscription =
    //     masterBloc.registerToRecStreamController(recipeNotificationReceived);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    masterBloc.disposeRecController();
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
              ? masterBloc.addRec(widget.recipe).then((value) => favoriteIcon())
              : masterBloc
                  .deleteRec(widget.recipe)
                  .then((value) => favoriteIcon());
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
                        tag: widget.indexForHero.toString(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Image.network(
                            widget.recipe.image,
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
                    name: widget.recipe.ingredientsList
                        .elementAt(itemBuilder)
                        .name,
                    image: kBaseIngredientURL +
                        widget.recipe.ingredientsList
                            .elementAt(itemBuilder)
                            .image,
                  );
                  return IngredientCard(
                      ingObject:
                          widget.recipe.ingredientsList.elementAt(itemBuilder));
                  // return Text(
                  //     recipe.ingredientsList.elementAt(itemBuilder).name);
                },
                itemCount: widget.recipe.ingredientsList.length,
              ),
              ListView.builder(
                itemBuilder: (context, itemBuilder) {
                  var recipeInstructions = RecipeInstructions.fromJson(
                      widget.recipe.analyzedInstructions[itemBuilder]);
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
