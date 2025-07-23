import '../enums.dart';

class Profile {
  String username;

  int currentXP;

  int level;

  UserRank rank;

  Profile({
    this.username = "user",
    this.currentXP = 0,
    this.level = 0,
    this.rank = UserRank.newcomer,
  });

  Profile copyWith({
    String username = "user",
    int currentXP = 0,
    int level = 0,
    UserRank rank = UserRank.newcomer,
  }) => Profile(
    username: username,
    currentXP: currentXP,
    level: level,
    rank: rank,
  );
}
