import 'package:hive/hive.dart';

part 'challenge_occurrence.g.dart';

@HiveType(typeId: 7)
class ChallengeOccurrence extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String challengeId;

  @HiveField(2)
  int reward;

  @HiveField(3)
  DateTime dateInstance;

  @HiveField(4)
  DateTime? completedAt;

  ChallengeOccurrence({
    required this.id,
    required this.challengeId,
    required this.reward,
    required this.dateInstance,
    this.completedAt,
  });
}
