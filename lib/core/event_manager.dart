import 'dart:async';
import 'package:taskoria/data/event_types.dart';

class EventManager {
  static final EventManager _instance = EventManager._internal();

  factory EventManager() => _instance;

  EventManager._internal();

  StreamController<AppEvent> appEvents = StreamController<AppEvent>.broadcast();

  Stream<AppEvent> get events => appEvents.stream;

  Stream<AppEvent> get questEvents => events
      .where(
        (event) =>
            event.type == AppEventType.questCompleted ||
            event.type == AppEventType.questOverdue,
      )
      .cast();
}
