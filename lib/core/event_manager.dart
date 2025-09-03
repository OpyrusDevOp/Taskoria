import 'dart:async';
import 'package:Taskoria/types/event_type.dart';

class EventManager {
  static final EventManager _instance = EventManager._internal();
  factory EventManager() => _instance;
  EventManager._internal();

  final StreamController<AppEvent> _eventController =
      StreamController<AppEvent>.broadcast();

  Stream<AppEvent> get events => _eventController.stream;

  void emit(AppEvent event) {
    _eventController.add(event);
  }

  Stream<T> on<T extends AppEvent>() {
    return events.where((event) => event is T).cast<T>();
  }
}
