import 'dart:async';

import '../contract/event.dart';
import '../contract/state.dart';
import '../contract/ui_side_effect.dart';

abstract class StateMachine<E extends Event, S extends BaseState,
    USF extends UISideEffect> {
  void dispatchEvent(E event);
  StreamController<S> getStateStream();
  S getState();
  StreamController<USF> getUISideEffect();
  void dispose();
}
