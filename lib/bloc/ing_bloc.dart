import 'dart:async';
import 'package:munchy/model/ing_repo.dart';
import 'package:munchy/model/ingredient.dart';
import '../database.dart';

enum IngEventType { add, delete }

class IngredientBloc {
  //Get instance of the Repository
  final _ingRepository = IngredientRepository();

  final _ingredientController = StreamController<List<Ingredient>>.broadcast();
  // StreamSink<Ingredient> get _ingSink => _stateStreamController.sink;
  // Stream<Ingredient> get ingStream => _stateStreamController.stream;

  // final _eventStreamController = StreamController<IngEventType>();
  // StreamSink<IngEventType> get eventSink => _eventStreamController.sink;
  // Stream<IngEventType> get _eventStream => _eventStreamController.stream;

  get ings => _ingredientController.stream;

  IngredientBloc() {
    getIngs();
  }

  getIngs({String query}) async {
    //sink is a way of adding data reactive-ly to the stream
    //by registering a new event
    // _ingredientController.sink
    //     .add(await _ingRepository.getAllIngs(query: query));
    _ingredientController.sink
        .add(await _ingRepository.getAllIngs(query: query));
  }

  addIng(Ingredient ingredient) async {
    await _ingRepository.insertIng(ingredient);
    getIngs();
  }

  updateTodo(Ingredient ingredient) async {
    await _ingRepository.updateIng(ingredient);
    getIngs();
  }

  deleteIngById(int id) async {
    _ingRepository.deleteIngById(id);
    getIngs();
  }

  dispose() {
    _ingredientController.close();
  }
}
