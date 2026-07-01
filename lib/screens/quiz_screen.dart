import 'dart:math';

import 'package:flutter/material.dart';

import '../data/flower_data.dart';
import '../models/flower.dart';
import '../models/quiz_result.dart';
import '../screens/result_screen.dart';
import '../services/learning_progress_service.dart';
import '../widgets/answer_button.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    this.reviewOnly = false,
    this.difficulty = FlowerDifficulty.beginner,
    this.season,
  });

  static const String routeName = '/quiz';

  final bool reviewOnly;
  final FlowerDifficulty difficulty;
  final FlowerQuizSeason? season;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class QuizScreenArguments {
  const QuizScreenArguments({
    this.difficulty = FlowerDifficulty.beginner,
    this.season,
  });

  final FlowerDifficulty difficulty;
  final FlowerQuizSeason? season;
}

class _QuizScreenState extends State<QuizScreen> {
  static const int _normalQuestionCount = 10;

  final Random _random = Random();
  final LearningProgressService _progressService = LearningProgressService();

  bool _isLoading = true;
  List<Flower> _questions = [];
  List<String> _choices = [];
  List<QuizAnswerRecord> _records = [];
  int _currentIndex = 0;
  String? _selectedName;
  bool _hasAnswered = false;

  Flower get _currentFlower => _questions[_currentIndex];

  String get _screenTitle {
    if (widget.reviewOnly) {
      return '復習';
    }
    return widget.season?.quizTitle ?? 'クイズ';
  }

  @override
  void initState() {
    super.initState();
    _prepareQuiz();
  }

  Future<void> _prepareQuiz() async {
    final questions = widget.reviewOnly
        ? await _buildReviewQuestions()
        : await _buildNormalQuestions();

    setState(() {
      _questions = questions;
      _isLoading = false;
    });

    if (questions.isNotEmpty) {
      _prepareChoices();
    }
  }

  Future<List<Flower>> _buildNormalQuestions() async {
    final progressMap = await _progressService.getAllProgress();
    final prioritizedFlowers = prioritizeUnseenFlowers(
      flowers: _questionPool(),
      progressMap: progressMap,
      random: _random,
    );
    return prioritizedFlowers.take(_normalQuestionCount).toList();
  }

  Future<List<Flower>> _buildReviewQuestions() async {
    final progressMap = await _progressService.getAllProgress();
    final weakFlowers = flowers.where((flower) {
      final progress = progressMap[flower.id];
      return progress != null && progress.wrongCount > progress.correctCount;
    }).toList();

    weakFlowers.sort((a, b) {
      final aProgress = progressMap[a.id]!;
      final bProgress = progressMap[b.id]!;
      final aScore = aProgress.wrongCount - aProgress.correctCount;
      final bScore = bProgress.wrongCount - bProgress.correctCount;
      return bScore.compareTo(aScore);
    });

    return weakFlowers.take(_normalQuestionCount).toList();
  }

  void _prepareChoices() {
    final otherFlowers = _choicePool()
        .where(
          (flower) => flower.id != _currentFlower.id,
        )
        .toList()
      ..shuffle(_random);

    final nextChoices = <String>[
      _currentFlower.name,
      ...otherFlowers.take(3).map((flower) => flower.name),
    ]..shuffle(_random);

    setState(() {
      _choices = nextChoices;
      _selectedName = null;
      _hasAnswered = false;
    });
  }

  List<Flower> _questionPool() {
    final season = widget.season;
    if (season != null) {
      return flowersBySeason(season);
    }
    return flowersByDifficulty(widget.difficulty);
  }

  List<Flower> _choicePool() {
    final season = widget.season;
    if (season != null) {
      return flowersBySeason(season);
    }
    return flowersByDifficulty(_currentFlower.difficulty);
  }

  Future<void> _selectAnswer(String selectedName) async {
    if (_hasAnswered) {
      return;
    }

    final isCorrect = selectedName == _currentFlower.name;
    await _progressService.recordAnswer(
      flowerId: _currentFlower.id,
      isCorrect: isCorrect,
    );

    setState(() {
      _selectedName = selectedName;
      _hasAnswered = true;
      _records = [
        ..._records,
        QuizAnswerRecord(
          flower: _currentFlower,
          selectedName: selectedName,
          isCorrect: isCorrect,
        ),
      ];
    });
  }

  void _goNext() {
    if (_currentIndex + 1 >= _questions.length) {
      final correctCount = _records.where((record) => record.isCorrect).length;
      Navigator.pushReplacementNamed(
        context,
        ResultScreen.routeName,
        arguments: QuizResult(
          totalQuestions: _questions.length,
          correctCount: correctCount,
          answers: _records,
          isReviewMode: widget.reviewOnly,
          difficulty: widget.difficulty,
          season: widget.season,
        ),
      );
      return;
    }

    setState(() {
      _currentIndex++;
    });
    _prepareChoices();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(_screenTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('復習')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF43A85D),
                size: 72,
              ),
              const SizedBox(height: 20),
              const Text(
                'いま復習が必要な花はありません。',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              const Text(
                '通常クイズで間違えた花があると、ここに出題されます。',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF6E6064), height: 1.5),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ホームへ戻る'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitle),
        toolbarHeight: 48,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
          children: [
            Text(
              '${_currentIndex + 1} / ${_questions.length}',
              style: const TextStyle(
                color: Color(0xFF7A666B),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.asset(
                  _currentFlower.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _QuizImagePlaceholder(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'この花の名前は？',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            for (final choice in _choices) ...[
              AnswerButton(
                text: choice,
                onPressed: _hasAnswered ? null : () => _selectAnswer(choice),
                isSelected: _selectedName == choice,
                isCorrectAnswer: choice == _currentFlower.name,
                hasAnswered: _hasAnswered,
              ),
              const SizedBox(height: 8),
            ],
            if (_hasAnswered) ...[
              const SizedBox(height: 6),
              _FlowerMeaningFeedback(flower: _currentFlower),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _goNext,
                child: Text(
                  _currentIndex + 1 >= _questions.length ? '結果を見る' : '次の問題',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

List<Flower> prioritizeUnseenFlowers({
  required List<Flower> flowers,
  required Map<String, FlowerProgress> progressMap,
  required Random random,
}) {
  final unseenFlowers = <Flower>[];
  final seenFlowers = <Flower>[];

  for (final flower in flowers) {
    final progress = progressMap[flower.id];
    final answerCount =
        (progress?.correctCount ?? 0) + (progress?.wrongCount ?? 0);
    if (answerCount == 0) {
      unseenFlowers.add(flower);
    } else {
      seenFlowers.add(flower);
    }
  }

  unseenFlowers.shuffle(random);
  seenFlowers.shuffle(random);
  return [...unseenFlowers, ...seenFlowers];
}

class _FlowerMeaningFeedback extends StatelessWidget {
  const _FlowerMeaningFeedback({
    required this.flower,
  });

  final Flower flower;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6F8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1D7DF)),
      ),
      child: Text(
        flowerMeaningFeedbackText(flower),
        style: const TextStyle(
          color: Color(0xFF6E3F4B),
          fontSize: 14,
          fontWeight: FontWeight.w800,
          height: 1.35,
        ),
      ),
    );
  }
}

String flowerMeaningFeedbackText(Flower flower) {
  return '${flower.name}の花言葉：${flower.flowerMeanings.join('、')}';
}

class _QuizImagePlaceholder extends StatelessWidget {
  const _QuizImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFEEF2),
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_florist, color: Color(0xFFE97896), size: 64),
          SizedBox(height: 8),
          Text(
            '画像準備中',
            style: TextStyle(
              color: Color(0xFF7A666B),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
