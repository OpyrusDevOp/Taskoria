class LevelService {
  static const List<Map<String, dynamic>> levelTiers = [
    {
      'range': [0, 0],
      'rank': 'Newcomer',
      'xpPerLevel': 0,
    },
    {
      'range': [1, 10],
      'rank': 'Adventurer',
      'xpPerLevel': 100,
    },
    {
      'range': [11, 20],
      'rank': 'Explorer',
      'xpPerLevel': 150,
    },
    {
      'range': [21, 30],
      'rank': 'Quest Seeker',
      'xpPerLevel': 200,
    },
    {
      'range': [31, 40],
      'rank': 'Trailblazer',
      'xpPerLevel': 250,
    },
    {
      'range': [41, 50],
      'rank': 'Pathfinder',
      'xpPerLevel': 300,
    },
    {
      'range': [51, 60],
      'rank': 'Task Slayer',
      'xpPerLevel': 400,
    },
    {
      'range': [61, 70],
      'rank': 'Heroic Achiever',
      'xpPerLevel': 500,
    },
    {
      'range': [71, 80],
      'rank': 'Legendary Hunter',
      'xpPerLevel': 600,
    },
    {
      'range': [81, 90],
      'rank': 'Task Mastermind',
      'xpPerLevel': 800,
    },
    {
      'range': [91, 99],
      'rank': 'Ultimate Tasker',
      'xpPerLevel': 1000,
    },
    {
      'range': [100, 100],
      'rank': 'TaskMaster',
      'xpPerLevel': 2000,
    },
  ];

  static int calculateLevel(int totalXP) {
    int cumulativeXP = 0;
    for (var tier in levelTiers) {
      int startLevel = tier['range'][0];
      int endLevel = tier['range'][1];
      int xpPerLevel = tier['xpPerLevel'];

      for (int level = startLevel; level <= endLevel; level++) {
        if (level == 0) continue;
        cumulativeXP += xpPerLevel;
        if (totalXP < cumulativeXP) {
          return level - 1;
        }
      }
    }
    return 100;
  }

  static String getRank(int level) {
    for (var tier in levelTiers) {
      int startLevel = tier['range'][0];
      int endLevel = tier['range'][1];
      if (level >= startLevel && level <= endLevel) {
        return tier['rank'];
      }
    }
    return 'Newcomer';
  }

  static int getXPForNextLevel(int currentLevel) {
    for (var tier in levelTiers) {
      int startLevel = tier['range'][0];
      int endLevel = tier['range'][1];
      if (currentLevel >= startLevel && currentLevel < endLevel) {
        return tier['xpPerLevel'];
      }
    }
    return 0; // No more levels after 100
  }

  static int getCurrentLevelXP(int totalXP, int currentLevel) {
    int cumulativeXP = 0;
    for (var tier in levelTiers) {
      int startLevel = tier['range'][0];
      int endLevel = tier['range'][1];
      int xpPerLevel = tier['xpPerLevel'];

      for (int level = startLevel; level <= endLevel; level++) {
        if (level == 0) continue;
        if (level == currentLevel + 1) {
          return totalXP - cumulativeXP;
        }
        cumulativeXP += xpPerLevel;
      }
    }
    return totalXP - cumulativeXP;
  }
}
