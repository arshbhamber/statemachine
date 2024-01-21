import 'dart:async';

import 'package:statemachine/core/state_machine.dart';

import '../contract/analytics_event_handler.dart';
import '../contract/async_side_effect.dart';
import '../contract/async_side_effect_handler.dart';
import '../contract/event.dart';
import '../contract/event_handler.dart';
import '../contract/next.dart';
import '../contract/state.dart';
import '../contract/ui_side_effect.dart';

class StateMachineImpl<
    E extends Event,
    S extends BaseState,
    ASF extends AsyncSideEffect,
    USF extends UISideEffect> extends StateMachine<E, S, ASF, USF> {
  StreamController<S> stateController = StreamController();
  StreamController<USF> uiSideEffect = StreamController();
  StreamController eventBus = StreamController();

  S state;
  EventHandler<E, S, ASF, USF> eventHandler;
  AsyncSideEffectHandler<E, ASF> asyncSideEffectHandler;
  AnalyticsEventHandler<E, S> analyticsEventHandler;

  StateMachineImpl(this.state, this.eventHandler, this.asyncSideEffectHandler,
      this.analyticsEventHandler) {
    stateController.add(state);
    registerEventListener();
  }

  @override
  void dispatchEvent(E event) {
    eventBus.add(event);
  }

  @override
  StreamController<S> getStateStream() {
    return stateController;
  }

  @override
  S getState() {
    return state;
  }

  @override
  StreamController<USF> getUISideEffect() {
    return uiSideEffect;
  }

  void registerEventListener() {
    eventBus.stream.listen((event) {
      Next next = eventHandler.handleEvent(event, state);
      handleNext(event, next);
    });
  }

  void handleNext(E event, Next next) {
    if (next.state != null) {
      dispatchState(next.state);
    }
    if (next.uiSideEffect != null) {
      dispatchUISideEffect(next.uiSideEffect);
    }
    if (next.asyncSideEffect != null) {
      dispatchAsyncSideEffect(next.asyncSideEffect);
    }
    dispatchAnalyticsEvent(event, state);
  }

  void dispatchAnalyticsEvent(E event, S state) {
    analyticsEventHandler.sendEvent(event, state);
  }

  void dispatchState(S newState) {
    state = newState;
    stateController.add(newState);
  }

  void dispatchUISideEffect(USF sideEffect) {
    uiSideEffect.add(sideEffect);
  }

  void dispatchAsyncSideEffect(ASF sideEffect) {
    asyncSideEffectHandler.handleSideEffect(sideEffect, (event) {
      if (!eventBus.isClosed) {
        eventBus.add(event);
      }
    });
  }

  @override
  void dispose() {
    state.dispose();
    eventBus.close();
    stateController.close();
    uiSideEffect.close();
  }
}
