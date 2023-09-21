import 'package:statemachine/contract/ui_side_effect.dart';

import 'async_side_effect_handler.dart';
import 'event.dart';

abstract class UISideEffectHandler<E extends Event, USF extends UISideEffect> {
  void handleSideEffect(USF sideEffect, DispatchEvent<E> dispatchEvent);
}
