import 'package:statemachine/contract/async_side_effect.dart';
import 'package:statemachine/contract/event.dart';

abstract class AsyncSideEffectHandler<E extends Event,
    ASF extends AsyncSideEffect> {
  void handleSideEffect(ASF sideEffect, DispatchEvent<E> dispatchEvent);
  void dispose();
}

typedef DispatchEvent<E extends Event> = void Function(E event);
