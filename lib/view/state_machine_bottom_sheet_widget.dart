import 'package:flutter/material.dart';
import 'package:statemachine/contract/async_side_effect.dart';
import '../contract/async_side_effect_handler.dart';
import '../contract/event.dart';
import '../contract/state.dart';
import '../contract/ui_side_effect.dart';
import '../core/state_machine.dart';

abstract class StateMachineBottomSheetWidget<
    E extends Event,
    S extends BaseState,
    ASF extends AsyncSideEffect,
    USF extends UISideEffect> extends StatefulWidget {
  const StateMachineBottomSheetWidget({super.key});

  @override
  State<StateMachineBottomSheetWidget<E, S, ASF, USF>> createState() =>
      _StateMachineWidgetState<E, S, ASF, USF>();

  StateMachine<E, S, ASF, USF> injectStateMachine();

  void handleUISideEffect(
      BuildContext context, USF sideEffect, DispatchEvent<E> dispatchEvent);

  void init(DispatchEvent<E> dispatchEvent) {}

  Widget buildLayout(S state, DispatchEvent<E> dispatchEvent);

}

class _StateMachineWidgetState<E extends Event, S extends BaseState,
        ASF extends AsyncSideEffect, USF extends UISideEffect>
    extends State<StateMachineBottomSheetWidget<E, S, ASF, USF>> {
  late StateMachine<E, S, ASF, USF> stateMachine;

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

    return getMaterialView();
  }

  Widget getMaterialView() {
    return Material(
      child: SafeArea(
        child: widget.buildLayout(state, (event) {
          stateMachine.dispatchEvent(event);
        }),
      ),
    );
  }

  @override
  void dispose() {
    stateMachine.dispose();
    super.dispose();
  }
}
