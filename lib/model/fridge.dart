import 'package:munchy/database.dart';
import 'package:munchy/model/ingredient.dart';

class Fridge {
  int id;
  String member1name;
  String member2name;
  List<Ingredient> ingredients = [];

  Fridge({this.id, this.member1name, this.member2name, this.ingredients});

  Map<String, dynamic> toMap() {
    String ingListToString;
    for (var ing in ingredients) {
      ingListToString += "," + ing.name;
    }
    var map = <String, dynamic>{
      DBProvider.COLUMN_FIRST_MEMBER: member1name,
      DBProvider.COLUMN_SECOND_MEMBER: member2name,
      DBProvider.COLUMN_INGREDIENTS: ingListToString,
    };
    if (id != null) {
      map[DBProvider.COLUMN_FRG_ID] = id;
    }
    return map;
  }

  Fridge.fromMap(Map<String, dynamic> map) {
    String ingListFromString;
    id = map[DBProvider.COLUMN_FRG_ID];
    member1name = map[DBProvider.COLUMN_FIRST_MEMBER];
    member2name = map[DBProvider.COLUMN_SECOND_MEMBER];
    ingListFromString = map[DBProvider.COLUMN_INGREDIENTS];

    List<String> list = ingListFromString.split(",");
    for (var item in list) {
      ingredients.add(Ingredient(name: item));
    }
  }
}
