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
