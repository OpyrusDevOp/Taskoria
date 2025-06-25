import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:taskoria/core/theme/app_theme.dart';
import 'data/models/quest.dart';
import 'data/models/user_profile.dart';
import 'presentation/pages/onboarding_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for offline storage
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(QuestTypeAdapter());
  Hive.registerAdapter(QuestStatusAdapter());
  Hive.registerAdapter(QuestDifficultyAdapter());
  Hive.registerAdapter(PriorityAdapter());
  Hive.registerAdapter(RecurrenceTypeAdapter());
  Hive.registerAdapter(RecurrencePatternAdapter());
  Hive.registerAdapter(StreakDataAdapter());
  Hive.registerAdapter(QuestAdapter());
  Hive.registerAdapter(WeeklyProgressAdapter());
  Hive.registerAdapter(UserProfileAdapter());

  // Open Hive boxes (will be used later)
  await Hive.openBox<Quest>('quests');
  await Hive.openBox<UserProfile>('user_profile');
  runApp(const TaskoriaApp());
}

class TaskoriaApp extends StatelessWidget {
  const TaskoriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskoria',
      theme: AppTheme.lightTheme,
      home: const OnboardingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
