import 'dart:async';
import 'package:munchy/bloc/ing_event.dart';
import 'package:munchy/model/ing_repo.dart';
import 'package:munchy/model/ingredient.dart';

enum IngEventType { add, delete, update }

class IngredientBloc {
  //Get instance of the Repository
  final _ingRepository = IngredientRepository();

  final _ingredientController = StreamController<IngredientEvent>.broadcast();

  StreamSubscription<IngredientEvent> registerToStreamController(event) {
    return _ingredientController.stream.listen(event);
  }

  Future<List<Ingredient>> getIngs({String query}) async {
    //sink is a way of adding data reactive-ly to the stream
    //by registering a new event
    return await _ingRepository.getAllIngs(query: query);
  }

  addIng(Ingredient ingredient) async {
    await _ingRepository.insertIng(ingredient);
    _ingredientController.sink.add(
        IngredientEvent(ingredient: ingredient, eventType: IngEventType.add));
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

  dispose() {
    _ingredientController.close();
  }
}
