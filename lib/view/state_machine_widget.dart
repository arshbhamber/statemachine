import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../contract/async_side_effect_handler.dart';
import '../contract/event.dart';
import '../contract/screen.dart';
import '../contract/state.dart';
import '../contract/ui_side_effect.dart';
import '../core/state_machine.dart';

abstract class StateMachineWidget<E extends Event, S extends BaseState,
    USF extends UISideEffect> extends StatefulWidget {
  const StateMachineWidget({super.key});

  @override
  State<StateMachineWidget<E, S, USF>> createState() =>
      _StateMachineWidgetState<E, S, USF>();

  StateMachine<E, S, USF> injectStateMachine();

  void handleUISideEffect(
      BuildContext context, USF sideEffect, DispatchEvent<E> dispatchEvent);

  void init(DispatchEvent<E> dispatchEvent) {}

  Widget buildLayout(S state, DispatchEvent<E> dispatchEvent);

  void pushReplacement(BuildContext context, Screen screen) {
    context.pushReplacement(screen.path);
  }

  void push(BuildContext context, Screen screen, {Object? extra}) {
    context.push(screen.path, extra: extra);
  }

  void pushNamed(BuildContext context, Screen screen) {
    context.pushNamed(screen.path);
  }

  void pop(BuildContext context) {
    context.pop();
  }

  void go(BuildContext context, Screen screen) {
    context.go(screen.path);
  }

  Widget? getBottomNavigationBar(S state, DispatchEvent<E> dispatchEvent) {
    return null;
  }

  AppBar? getAppBar(S state, DispatchEvent<E> dispatchEvent) {
    return null;
  }

  Widget? getFloatingActionButton(S state, DispatchEvent<E> dispatchEvent) {
    return null;
  }

  bool enableScaffold() {
    return false;
  }
}

class _StateMachineWidgetState<E extends Event, S extends BaseState,
    USF extends UISideEffect> extends State<StateMachineWidget<E, S, USF>> {
  late StateMachine<E, S, USF> stateMachine;

  late S state;

  @override
  void initState() {
    stateMachine = widget.injectStateMachine();
    state = stateMachine.getState();
    widget.init((event) => stateMachine.dispatchEvent(event));
    stateMachine.getStateStream().stream.listen((event) {
      setState(() {
        state = event;
      });
    });

    stateMachine.getUISideEffect().stream.listen((USF usf) {
      widget.handleUISideEffect(
          context, usf, ((event) => stateMachine.dispatchEvent(event)));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    state.screenWidth = MediaQuery.of(context).size.width;
    state.screenHeight = MediaQuery.of(context).size.height;
    GoRouterState routerState = GoRouterState.of(context);
    state.location = routerState.uri.toString();
    state.extra = routerState.extra;

    if (widget.enableScaffold()) {
      return getScaffoldView();
    } else {
      return getMaterialView();
    }
  }

  Widget getScaffoldView() {
    return Scaffold(
      appBar: widget.getAppBar(state, (event) {
        stateMachine.dispatchEvent(event);
      }),
      body: widget.buildLayout(state, (event) {
        stateMachine.dispatchEvent(event);
      }),
      bottomNavigationBar: widget.getBottomNavigationBar(state, (event) {
        stateMachine.dispatchEvent(event);
      }),
      floatingActionButton: widget.getFloatingActionButton(state, (event) {
        stateMachine.dispatchEvent(event);
      }),
      backgroundColor: const Color.fromARGB(255, 36, 3, 26),
    );
  }

  Widget getMaterialView() {
    return Material(
      color: const Color.fromARGB(0, 36, 3, 26),
      child: widget.buildLayout(state, (event) {
        stateMachine.dispatchEvent(event);
      }),
    );
  }

  @override
  void dispose() {
    stateMachine.dispose();
    super.dispose();
  }
}
