enum QuestPriority {
  secondary(0.5),
  standard(1.0),
  urgent(2.0);

  final double multiplier;
  const QuestPriority(this.multiplier);
}

enum ChallengeCircle {
  daily(0.20),
  every2days(0.25),
  every3days(0.25),
  every4days(0.30),
  every5days(0.30),
  every6days(0.35),
  weekly(0.40),
  monthly(0.45);

  final double multiplier;
  const ChallengeCircle(this.multiplier);
}

enum Rank {
  starter('Starter', 10),
  grinder('Grinder', 125),
  hustler('Hustler', 400),
  hardWorker('Hard Worker', 700),
  machine('Machine', 1000),
  taskMaster('Task Master', 1200),
  grandArchitect('Grand Architect', 1500),
  visionary('The Visionary', 1600);

  final String title;
  final int baseXpValue; // The "Base Value" from your specs
  const Rank(this.title, this.baseXpValue);
}
