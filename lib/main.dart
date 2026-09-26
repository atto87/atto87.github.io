import 'package:flutter/material.dart';

import 'models/flower.dart';
import 'theme/garden_theme.dart';
import 'screens/encyclopedia_screen.dart';
import 'screens/flower_detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';
import 'screens/review_screen.dart';

void main() {
  runApp(const HanaQuizApp());
}

class HanaQuizApp extends StatelessWidget {
  const HanaQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'はなクイズ図鑑',
      debugShowCheckedModeBanner: false,
      theme: GardenTheme.light,
      builder: (context, child) => ColoredBox(
        color: const Color(0xFFECEFE7),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ClipRect(child: child!),
          ),
        ),
      ),
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        QuizScreen.routeName: (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments;
          final difficulty = arguments is QuizScreenArguments
              ? arguments.difficulty
              : FlowerDifficulty.beginner;
          final season =
              arguments is QuizScreenArguments ? arguments.season : null;
          return QuizScreen(difficulty: difficulty, season: season);
        },
        ReviewScreen.routeName: (_) => const ReviewScreen(),
        ResultScreen.routeName: (_) => const ResultScreen(),
        EncyclopediaScreen.routeName: (_) => const EncyclopediaScreen(),
        FlowerDetailScreen.routeName: (_) => const FlowerDetailScreen(),
      },
    );
  }
}
