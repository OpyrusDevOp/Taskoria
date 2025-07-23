import 'package:uuid/uuid.dart';

import '../enums.dart';

class Challenge {
  String id;

  String title;

  String? description;

  QuestFrequency frequency;

  DateTime startDate;

  DateTime? endDate;

  bool isActive;

  DateTime createdAt;

  DateTime updatedAt;

  Challenge({
    String? id,
    required this.title,
    this.description,
    this.frequency = QuestFrequency.daily,
    DateTime? startDate,
    this.endDate,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       startDate = startDate ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Challenge copyWith({
    String? title,
    String? description,
    QuestFrequency? frequency,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return Challenge(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
