
import 'package:statemachine/contract/event.dart';
import 'package:statemachine/contract/state.dart';

abstract class AnalyticsEventHandler<E extends Event, S extends BaseState> {
  Map<String, dynamic>? getEventParams(E event, S state);
  void sendEvent(E event, S state);
}
