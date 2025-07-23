import 'package:uuid/uuid.dart';

class ChallengeInstance {
  String id;

  String challengeId;

  String title; // Cached from challenge for performance

  String? description; // Cached from challenge for performance

  DateTime instanceDate; // The specific date this instance is for

  bool completed;

  DateTime? completedAt;

  int rewardXP; // Cached from challenge

  int penaltyXP; // Cached from challenge

  DateTime createdAt;

  DateTime updatedAt;

  ChallengeInstance({
    String? id,
    required this.challengeId,
    required this.title,
    this.description,
    required this.instanceDate,
    this.completed = false,
    this.completedAt,
    required this.rewardXP,
    required this.penaltyXP,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  ChallengeInstance copyWith({
    String? title,
    String? description,
    DateTime? instanceDate,
    bool? completed,
    DateTime? completedAt,
    int? rewardXP,
    int? penaltyXP,
    DateTime? updatedAt,
  }) {
    return ChallengeInstance(
      id: id,
      challengeId: challengeId,
      title: title ?? this.title,
      description: description ?? this.description,
      instanceDate: instanceDate ?? this.instanceDate,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      rewardXP: rewardXP ?? this.rewardXP,
      penaltyXP: penaltyXP ?? this.penaltyXP,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  bool get isOverdue {
    if (completed) return false;
    final today = DateTime.now();
    final instanceDateOnly = DateTime(
      instanceDate.year,
      instanceDate.month,
      instanceDate.day,
    );
    final todayOnly = DateTime(today.year, today.month, today.day);
    return instanceDateOnly.isBefore(todayOnly);
  }

  bool get isDueToday {
    final today = DateTime.now();
    final instanceDateOnly = DateTime(
      instanceDate.year,
      instanceDate.month,
      instanceDate.day,
    );
    final todayOnly = DateTime(today.year, today.month, today.day);
    return instanceDateOnly.isAtSameMomentAs(todayOnly);
  }

  bool get isDueTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final instanceDateOnly = DateTime(
      instanceDate.year,
      instanceDate.month,
      instanceDate.day,
    );
    final tomorrowOnly = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    return instanceDateOnly.isAtSameMomentAs(tomorrowOnly);
  }
}
