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
    if (event.eventType == IngEventType.update) {
      //TODO check here if the current ingredient amount is notification worthy or not.
    }
  }
}
