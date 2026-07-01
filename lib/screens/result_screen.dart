import 'package:flutter/material.dart';

import '../models/flower.dart';
import '../models/quiz_result.dart';
import '../screens/home_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/review_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  static const String routeName = '/result';

  @override
  Widget build(BuildContext context) {
    final result = ModalRoute.of(context)!.settings.arguments! as QuizResult;
    final percent = (result.accuracy * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('結果')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
          children: [
            const Icon(
              Icons.local_florist,
              size: 76,
              color: Color(0xFFE97896),
            ),
            const SizedBox(height: 18),
            Text(
              '${result.totalQuestions}問中 ${result.correctCount}問正解',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              '正解率 $percent%',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFF7A666B),
                fontWeight: FontWeight.w800,
              ),
            ),
            if (!result.isReviewMode) ...[
              const SizedBox(height: 8),
              Text(
                result.season?.quizTitle ?? result.difficulty.appLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF7A666B),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
            if (result.missedFlowers.isNotEmpty) ...[
              const SizedBox(height: 26),
              const Text(
                '間違えた花',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final flower in result.missedFlowers)
                    Chip(
                      label: Text(flower.name),
                      backgroundColor: const Color(0xFFFFEEF2),
                      side: BorderSide.none,
                    ),
                ],
              ),
            ],
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                result.isReviewMode
                    ? ReviewScreen.routeName
                    : QuizScreen.routeName,
                arguments: result.isReviewMode
                    ? null
                    : QuizScreenArguments(
                        difficulty: result.difficulty,
                        season: result.season,
                      ),
              ),
              icon: const Icon(Icons.replay),
              label: const Text('もう一度挑戦'),
            ),
            const SizedBox(height: 12),
            if (result.missedFlowers.isNotEmpty)
              OutlinedButton.icon(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  ReviewScreen.routeName,
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('復習する'),
              ),
            if (result.missedFlowers.isNotEmpty) const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                HomeScreen.routeName,
                (route) => false,
              ),
              icon: const Icon(Icons.home),
              label: const Text('ホームへ戻る'),
            ),
          ],
        ),
      ),
    );
  }
}
