import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/onboarding_page.dart';

void main() {
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
