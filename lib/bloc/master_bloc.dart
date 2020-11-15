import 'dart:async';
import 'package:munchy/bloc/bloc_base.dart';
import 'package:munchy/bloc/ing_event.dart';
import 'package:munchy/bloc/rec_event.dart';
import 'package:munchy/model/ing_repo.dart';
import 'package:munchy/model/ingredient.dart';
import 'package:munchy/model/rec_repo.dart';
import 'package:munchy/model/recipe.dart';

enum IngEventType { add, delete, update }
enum RecEventType { add, delete }

class MasterBloc implements BlocBase {
  //Get instance of the Repository
  final _ingRepository = IngredientRepository();
  final _recRepository = RecipeRepository();

  final _ingredientController = StreamController<IngredientEvent>.broadcast();
  final _recipeController = StreamController<RecipeEvent>.broadcast();

  @override
  void dispose() {
    _ingredientController.close();
    _recipeController.close();
  }

  //================== INGREDIENT BLOC LOGIC =============================//

  StreamSubscription<IngredientEvent> registerToIngStreamController(event) {
    return _ingredientController.stream.listen(event);
  }

  Future<List<Ingredient>> getIngs({String query}) async {
    return await _ingRepository.getAllIngs(query: query);
  }

  Future<List<Ingredient>> getLocalIngs({String query}) async {
    return await _ingRepository.getLocalIngs(query: query);
  }

  Future<List<Ingredient>> getRandomEssentialIngs({int count}) async {
    return await _ingRepository.getRandomEssentialIngs(count: count);
  }

  Future<Ingredient> getIng(int id) async {
    return await _ingRepository.getIng(id);
  }

  Future<bool> addIngGlobal(Ingredient ingredient) async {
    List<Ingredient> result = await getIngs();
    bool isFound = false;
    for (var element in result) {
      isFound = (element.name == ingredient.name) ? true : false;
    }
    print("is found value = $isFound");
    if (!isFound) {
      await _ingRepository.insertIng(ingredient);
      _ingredientController.sink.add(
          IngredientEvent(ingredient: ingredient, eventType: IngEventType.add));
      return true;
    }
    return false;
  }

  void addIngLocal(Ingredient ingredient) async {
    List<Ingredient> result = await getIngs();
    bool isFound = false;
    for (var element in result) {
      isFound = (element.name == ingredient.name) &&
              element.isAvailable == ingredient.isAvailable
          ? true
          : false;
    }

    if (!isFound) {
      await _ingRepository.insertIng(ingredient);
      _ingredientController.sink.add(
          IngredientEvent(ingredient: ingredient, eventType: IngEventType.add));
    } else {
      await _ingRepository.updateIng(ingredient);
      _ingredientController.sink.add(IngredientEvent(
          ingredient: ingredient, eventType: IngEventType.update));
    }
  }

  updateIng(Ingredient ingredient) async {
    await _ingRepository.updateIng(ingredient);
    _ingredientController.sink.add(IngredientEvent(
        ingredient: ingredient, eventType: IngEventType.update));
  }

  deleteIng(Ingredient ingredient) async {
    await _ingRepository.deleteIngById(ingredient.id);
    _ingredientController.sink.add(IngredientEvent(
        ingredient: ingredient, eventType: IngEventType.delete));
  }

  Future deleteAllIngs() async {
    return await _ingRepository.deleteAllIngs();
  }

  //================== RECIPE BLOC LOGIC =============================//
  StreamSubscription<RecipeEvent> registerToRecStreamController(event) {
    return _recipeController.stream.listen(event);
  }

  Future<dynamic> addRec(Recipe recipe) async {
    var a = await _recRepository.insertRec(recipe);
    _recipeController
        .add(RecipeEvent(eventType: RecEventType.add, recipe: recipe));
    return a;
  }

  Future<List<Recipe>> getRecs({String query}) async {
    return await _recRepository.getAllRecs(query: query);
  }

  Future<Ingredient> getRec(int id) async {
    return await _recRepository.getRec(id);
  }

  Future<List<Recipe>> getFavoriteRecs({int count}) async {
    return await _recRepository.getFavoriteRecs(count: count);
  }

  Future<dynamic> deleteRec(Recipe recipe) async {
    recipe.isFavorite = false;
    var a = await _recRepository.deleteRecById(recipe.id);
    if (!_recipeController.isClosed) {
      _recipeController
          .add(RecipeEvent(eventType: RecEventType.delete, recipe: recipe));
    }
    return a;
  }

  Future deleteAllRecs() async {
    return await _recRepository.deleteAllRecs();
  }
}
