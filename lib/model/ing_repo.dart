import 'ing_dao.dart';
import 'ingredient.dart';

class IngredientRepository {
  final ingredientDao = IngredientsDao();

  Future getAllIngs({String query}) => ingredientDao.getIngs(query: query);

  Future insertIng(Ingredient ing) => ingredientDao.createIng(ing);

  Future updateIng(Ingredient ing) => ingredientDao.updateIng(ing);

  Future deleteIngById(int id) => ingredientDao.deleteIng(id);

  Future deleteAllIngs() => ingredientDao.deleteAllIngs();

  Future deleteLocalIngs() => ingredientDao.deleteLocalIngs();

  Future getIng(int id) => ingredientDao.getIng(id);

  Future getLocalIngs({List<String> columns, String query}) =>
      ingredientDao.getLocalIngs(columns: columns, query: query);

  Future getRandomEssentialIngs({int count}) =>
      ingredientDao.getRandomEssentialIngs(count: count);
}
