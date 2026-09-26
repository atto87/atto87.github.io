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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              decoration: BoxDecoration(
                  color: const Color(0xFFEAF0E2),
                  borderRadius: BorderRadius.circular(28)),
              child: Column(children: [
                const Text('TODAY’S BLOOM',
                    style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 3,
                        color: Color(0xFF62754F),
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 22),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: result.accuracy),
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => SizedBox(
                      width: 142,
                      height: 142,
                      child: Stack(alignment: Alignment.center, children: [
                        SizedBox.expand(
                            child: CircularProgressIndicator(
                                value: value,
                                strokeWidth: 7,
                                backgroundColor: Colors.white,
                                strokeCap: StrokeCap.round,
                                semanticsLabel: '正解率 $percent%')),
                        Padding(
                            padding: const EdgeInsets.all(18),
                            child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.local_florist_outlined,
                                          color: Color(0xFF35634D), size: 30),
                                      Text('${(value * 100).round()}%',
                                          style: const TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF35634D))),
                                      const Text('正解率',
                                          style: TextStyle(fontSize: 11)),
                                    ]))),
                      ])),
                ),
                const SizedBox(height: 22),
                Text(
                    percent == 100
                        ? '満開です、おめでとう！'
                        : percent >= 70
                            ? '花の名前が、咲いてきた！'
                            : '今日の出会いが、明日の花に。',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 19, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                Text('${result.totalQuestions}問中 ${result.correctCount}問正解',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ]),
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
