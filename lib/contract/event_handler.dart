import 'package:statemachine/contract/async_side_effect.dart';
import 'package:statemachine/contract/event.dart';
import 'package:statemachine/contract/next.dart';
import 'package:statemachine/contract/state.dart';
import 'package:statemachine/contract/ui_side_effect.dart';

abstract class EventHandler<E extends Event, S extends BaseState,
    ASF extends AsyncSideEffect, USF extends UISideEffect> {
  Next<S?, ASF?, USF?> handleEvent(E event, S state);
}
