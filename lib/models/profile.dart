import 'enums.dart';

class Profile {
  String username;

  int currentXP;

  int level;

  UserRank rank;

  Profile({
    required this.username,
    this.currentXP = 0,
    this.level = 0,
    this.rank = UserRank.newcomer,
  });
}
