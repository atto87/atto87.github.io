import 'package:flutter/material.dart';

import 'models/flower.dart';
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE97896),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFCFD),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFFFFFCFD),
          foregroundColor: Color(0xFF4A3A3E),
          elevation: 0,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
            textStyle:
                const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
            textStyle:
                const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
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
          return QuizScreen(difficulty: difficulty);
        },
        ReviewScreen.routeName: (_) => const ReviewScreen(),
        ResultScreen.routeName: (_) => const ResultScreen(),
        EncyclopediaScreen.routeName: (_) => const EncyclopediaScreen(),
        FlowerDetailScreen.routeName: (_) => const FlowerDetailScreen(),
      },
    );
  }
}
