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

  Future<void> _openSeasonQuiz(FlowerQuizSeason season) async {
    await Navigator.pushNamed(
      context,
      QuizScreen.routeName,
      arguments: QuizScreenArguments(season: season),
    );
    if (mounted) {
      _refreshSummary();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('はなクイズ図鑑'),
        toolbarHeight: 48,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact =
                constraints.maxWidth <= 430 || constraints.maxHeight <= 760;
            final horizontalPadding = compact ? 14.0 : 20.0;
            final verticalPadding = compact ? 8.0 : 12.0;
            final bottomPadding = compact ? 10.0 : 28.0;

            final content = Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                verticalPadding,
                horizontalPadding,
                bottomPadding,
              ),
              child: _HomeContent(
                compact: compact,
                summaryFuture: _summaryFuture,
                onOpenQuiz: _openQuiz,
                onOpenSeasonQuiz: _openSeasonQuiz,
                onOpenRoute: _openRoute,
              ),
            );

            if (!compact ||
                constraints.maxHeight < 580 ||
                MediaQuery.textScalerOf(context).scale(14) > 18) {
              return ListView(children: [content]);
            }

            return SizedBox.expand(
              child: Align(
                alignment: Alignment.topCenter,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: content,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent(
      {required this.compact,
      required this.summaryFuture,
      required this.onOpenQuiz,
      required this.onOpenSeasonQuiz,
      required this.onOpenRoute});
  final bool compact;
  final Future<ProgressSummaryData> summaryFuture;
  final Future<void> Function(FlowerDifficulty) onOpenQuiz;
  final Future<void> Function(FlowerQuizSeason) onOpenSeasonQuiz;
  final Future<void> Function(String) onOpenRoute;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const _GardenWelcome(),
      const SizedBox(height: 14),
      FutureBuilder<ProgressSummaryData>(
          future: summaryFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                  height: 95,
                  child: Center(child: CircularProgressIndicator()));
            }
            return ProgressSummary(summary: snapshot.data!, compact: true);
          }),
      const SizedBox(height: 18),
      const _SectionLabel(title: '花の名前に、出会おう', caption: '難易度を選んで10問'),
      const SizedBox(height: 10),
      for (final difficulty in FlowerDifficulty.values) ...[
        _DifficultyButton(
            difficulty: difficulty, onPressed: () => onOpenQuiz(difficulty)),
        const SizedBox(height: 8),
      ],
      const SizedBox(height: 8),
      const _SectionLabel(title: '季節をめぐる', caption: '四季の花クイズ'),
      const SizedBox(height: 10),
      Row(children: [
        for (final season in FlowerQuizSeason.values) ...[
          if (season.index > 0) const SizedBox(width: 8),
          Expanded(
              child: _SeasonButton(
                  season: season, onPressed: () => onOpenSeasonQuiz(season))),
        ],
      ]),
      const SizedBox(height: 18),
      Row(children: [
        Expanded(
            child: OutlinedButton.icon(
          onPressed: () => onOpenRoute(EncyclopediaScreen.routeName),
          icon: const Icon(Icons.menu_book, size: 20),
          label: const Text('図鑑を見る'),
          style: OutlinedButton.styleFrom(
              textStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        )),
        const SizedBox(width: 10),
        Expanded(
            child: OutlinedButton.icon(
          onPressed: () => onOpenRoute(ReviewScreen.routeName),
          icon: const Icon(Icons.refresh, size: 20),
          label: const Text('復習する'),
          style: OutlinedButton.styleFrom(
              textStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        )),
      ]),
    ]);
  }
}

class _GardenWelcome extends StatelessWidget {
  const _GardenWelcome();
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(children: [
          Positioned.fill(
              child: Image.asset('assets/images/cosmos.jpg',
                  fit: BoxFit.cover,
                  excludeFromSemantics: true,
                  alignment: const Alignment(0.4, 0))),
          const Positioned.fill(
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
            colors: [Color(0xEF233D32), Color(0xAA233D32), Color(0x10233D32)],
            stops: [0, 0.55, 1],
          )))),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('HANA  /  BOTANICAL QUIZ',
                      style: TextStyle(
                          color: Color(0xFFDFE9CA),
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 9),
                  Text('名前を知ると、\n世界がちょっと咲く。',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          height: 1.35,
                          fontWeight: FontWeight.w800)),
                  SizedBox(height: 9),
                  Text('ひと花ずつ、好きになる。',
                      style: TextStyle(color: Color(0xFFF0F3E9), fontSize: 12)),
                ],
              )),
        ]),
      );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.caption});
  final String title;
  final String caption;
  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800))),
        Text(caption,
            style: const TextStyle(fontSize: 10, color: Color(0xFF687466))),
      ]);
}

class _DifficultyButton extends StatelessWidget {
  const _DifficultyButton({required this.difficulty, required this.onPressed});
  final FlowerDifficulty difficulty;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final first = difficulty == FlowerDifficulty.beginner;
    final colors = [
      const Color(0xFF35634D),
      const Color(0xFFEAF0E2),
      const Color(0xFFF3E9E4)
    ];
    final ink = first ? Colors.white : const Color(0xFF364D3E);
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
          backgroundColor: colors[difficulty.index],
          foregroundColor: ink,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          minimumSize: const Size.fromHeight(58)),
      child: Row(children: [
        Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: first
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(11)),
            child: Icon(
                [
                  Icons.spa_outlined,
                  Icons.local_florist_outlined,
                  Icons.auto_awesome_outlined
                ][difficulty.index],
                size: 21)),
        const SizedBox(width: 12),
        Expanded(
            child: Text(difficulty.appLabel,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700))),
        const SizedBox(width: 4),
        const Icon(Icons.arrow_forward_rounded, size: 18),
      ]),
    );
  }
}

class _SeasonButton extends StatelessWidget {
  const _SeasonButton({required this.season, required this.onPressed});
  final FlowerQuizSeason season;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFF5E4E8),
      const Color(0xFFEEF0D5),
      const Color(0xFFF6E8D8),
      const Color(0xFFE4EDF1)
    ];
    final inks = [
      const Color(0xFF985168),
      const Color(0xFF697631),
      const Color(0xFF9A633A),
      const Color(0xFF507584)
    ];
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
          backgroundColor: colors[season.index],
          foregroundColor: inks[season.index],
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 13),
          minimumSize: const Size(0, 72)),
      child: Column(children: [
        Icon(
            [
              Icons.filter_vintage_outlined,
              Icons.wb_sunny_outlined,
              Icons.eco_outlined,
              Icons.ac_unit
            ][season.index],
            size: 23),
        const SizedBox(height: 6),
        Text('${season.label}の花',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
      ]),
    );
  }
}
