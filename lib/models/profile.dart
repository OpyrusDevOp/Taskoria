import 'package:hive_flutter/adapters.dart';

import 'enums.dart';
part 'profile.g.dart';

@HiveType(typeId: 0)
class Profile extends HiveObject {
  @HiveField(0)
  String username;
  @HiveField(1)
  int currentXP;
  @HiveField(2)
  int level;
  @HiveField(3)
  UserRank rank;

  Profile({
    required this.username,
    this.currentXP = 0,
    this.level = 0,
    this.rank = UserRank.newcomer,
  });
}
