import 'package:flutter/material.dart';

import '../models/flower.dart';
import '../screens/encyclopedia_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/review_screen.dart';
import '../services/learning_progress_service.dart';
import '../widgets/progress_summary.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LearningProgressService _progressService = LearningProgressService();
  late Future<ProgressSummaryData> _summaryFuture;

  @override
  void initState() {
    super.initState();
    _summaryFuture = _progressService.getSummary();
  }

  void _refreshSummary() {
    setState(() {
      _summaryFuture = _progressService.getSummary();
    });
  }

  Future<void> _openRoute(String routeName) async {
    await Navigator.pushNamed(context, routeName);
    if (mounted) {
      _refreshSummary();
    }
  }

  Future<void> _openQuiz(FlowerDifficulty difficulty) async {
    await Navigator.pushNamed(
      context,
      QuizScreen.routeName,
      arguments: QuizScreenArguments(difficulty: difficulty),
    );
    if (mounted) {
      _refreshSummary();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('はなクイズ図鑑')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            const Text(
              '写真を見て、花の名前を楽しく覚えよう。',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF5F5054),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<ProgressSummaryData>(
              future: _summaryFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ProgressSummary(summary: snapshot.data!);
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _openQuiz(FlowerDifficulty.beginner),
              icon: const Icon(Icons.quiz),
              label: Text(FlowerDifficulty.beginner.appLabel),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _openQuiz(FlowerDifficulty.intermediate),
              icon: const Icon(Icons.local_florist),
              label: Text(FlowerDifficulty.intermediate.appLabel),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _openQuiz(FlowerDifficulty.advanced),
              icon: const Icon(Icons.emoji_nature),
              label: Text(FlowerDifficulty.advanced.appLabel),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _openRoute(EncyclopediaScreen.routeName),
              icon: const Icon(Icons.menu_book),
              label: const Text('図鑑を見る'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _openRoute(ReviewScreen.routeName),
              icon: const Icon(Icons.refresh),
              label: const Text('復習する'),
            ),
          ],
        ),
      ),
    );
  }
}
