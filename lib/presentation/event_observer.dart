import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Taskoria/core/event_manager.dart';

import '../types/event_type.dart';

mixin EventObserver<T extends StatefulWidget> on State<T> {
  final List<StreamSubscription> _subscriptions = [];

  void listenTo<E extends AppEvent>(void Function(E) onEvent) {
    final subscription = EventManager().on<E>().listen(onEvent);
    _subscriptions.add(subscription);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
