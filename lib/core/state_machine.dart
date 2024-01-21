import 'dart:async';

import 'package:statemachine/contract/async_side_effect.dart';

import '../contract/event.dart';
import '../contract/state.dart';
import '../contract/ui_side_effect.dart';

abstract class StateMachine<E extends Event, S extends BaseState, ASF extends AsyncSideEffect,
    USF extends UISideEffect> {
  void dispatchEvent(E event);
  StreamController<S> getStateStream();
  S getState();
  StreamController<USF> getUISideEffect();
  void dispose();
}
