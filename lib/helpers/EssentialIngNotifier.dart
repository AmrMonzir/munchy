import 'dart:async';
import 'package:munchy/bloc/ing_event.dart';
import 'package:munchy/bloc/master_bloc.dart';

class EssentialIngNotifier {
  StreamSubscription streamSubscription;
  MasterBloc masterBloc;
  EssentialIngNotifier() {
    streamSubscription =
        masterBloc.registerToIngStreamController(checkEssentialThreshold);
  }

  checkEssentialThreshold(IngredientEvent event) {
    bool hasCrossedThreshold = false;
    if (event.eventType == IngEventType.update) {
      //TODO check here if the current ingredient amount is notification worthy or not.
      switch (event.ingredient.essentialUnit) {
        case "Number":
          hasCrossedThreshold =
              event.ingredient.nQuantity < event.ingredient.essentialThreshold;
          break;
        case "mg":
          hasCrossedThreshold =
              event.ingredient.kgQuantity < event.ingredient.essentialThreshold;
          break;
        case "ml":
          hasCrossedThreshold =
              event.ingredient.lrQuantity < event.ingredient.essentialThreshold;
          break;
      }
    }
  }
}
