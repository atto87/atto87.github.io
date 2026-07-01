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

            if (!compact) {
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
  const _HomeContent({
    required this.compact,
    required this.summaryFuture,
    required this.onOpenQuiz,
    required this.onOpenSeasonQuiz,
    required this.onOpenRoute,
  });

  final bool compact;
  final Future<ProgressSummaryData> summaryFuture;
  final Future<void> Function(FlowerDifficulty difficulty) onOpenQuiz;
  final Future<void> Function(FlowerQuizSeason season) onOpenSeasonQuiz;
  final Future<void> Function(String routeName) onOpenRoute;

  @override
  Widget build(BuildContext context) {
    final gap = compact ? 8.0 : 12.0;
    final largeGap = compact ? 14.0 : 24.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '写真を見て、花の名前を楽しく覚えよう。',
          style: TextStyle(
            fontSize: compact ? 15 : 18,
            color: const Color(0xFF5F5054),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: compact ? 12 : 20),
        FutureBuilder<ProgressSummaryData>(
          future: summaryFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ProgressSummary(
              summary: snapshot.data!,
              compact: compact,
            );
          },
        ),
        SizedBox(height: largeGap),
        _HomeButton(
          compact: compact,
          icon: Icons.quiz,
          label: FlowerDifficulty.beginner.appLabel,
          onPressed: () => onOpenQuiz(FlowerDifficulty.beginner),
        ),
        SizedBox(height: gap),
        _HomeButton(
          compact: compact,
          icon: Icons.local_florist,
          label: FlowerDifficulty.intermediate.appLabel,
          onPressed: () => onOpenQuiz(FlowerDifficulty.intermediate),
        ),
        SizedBox(height: gap),
        _HomeButton(
          compact: compact,
          icon: Icons.emoji_nature,
          label: FlowerDifficulty.advanced.appLabel,
          onPressed: () => onOpenQuiz(FlowerDifficulty.advanced),
        ),
        SizedBox(height: gap),
        _SeasonQuizGrid(
          compact: compact,
          onOpenSeasonQuiz: onOpenSeasonQuiz,
        ),
        SizedBox(height: gap),
        _HomeButton(
          compact: compact,
          outlined: true,
          icon: Icons.menu_book,
          label: '図鑑を見る',
          onPressed: () => onOpenRoute(EncyclopediaScreen.routeName),
        ),
        SizedBox(height: gap),
        _HomeButton(
          compact: compact,
          outlined: true,
          icon: Icons.refresh,
          label: '復習する',
          onPressed: () => onOpenRoute(ReviewScreen.routeName),
        ),
      ],
    );
  }
}

class _SeasonQuizGrid extends StatelessWidget {
  const _SeasonQuizGrid({
    required this.compact,
    required this.onOpenSeasonQuiz,
  });

  final bool compact;
  final Future<void> Function(FlowerQuizSeason season) onOpenSeasonQuiz;

  @override
  Widget build(BuildContext context) {
    final gap = compact ? 8.0 : 10.0;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SeasonButton(
                compact: compact,
                season: FlowerQuizSeason.spring,
                icon: Icons.eco,
                onPressed: () => onOpenSeasonQuiz(FlowerQuizSeason.spring),
              ),
            ),
            SizedBox(width: gap),
            Expanded(
              child: _SeasonButton(
                compact: compact,
                season: FlowerQuizSeason.summer,
                icon: Icons.wb_sunny,
                onPressed: () => onOpenSeasonQuiz(FlowerQuizSeason.summer),
              ),
            ),
          ],
        ),
        SizedBox(height: gap),
        Row(
          children: [
            Expanded(
              child: _SeasonButton(
                compact: compact,
                season: FlowerQuizSeason.autumn,
                icon: Icons.spa,
                onPressed: () => onOpenSeasonQuiz(FlowerQuizSeason.autumn),
              ),
            ),
            SizedBox(width: gap),
            Expanded(
              child: _SeasonButton(
                compact: compact,
                season: FlowerQuizSeason.winter,
                icon: Icons.ac_unit,
                onPressed: () => onOpenSeasonQuiz(FlowerQuizSeason.winter),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SeasonButton extends StatelessWidget {
  const _SeasonButton({
    required this.compact,
    required this.season,
    required this.icon,
    required this.onPressed,
  });

  final bool compact;
  final FlowerQuizSeason season;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: Icon(icon, size: compact ? 17 : 20),
      label: Text(
        '${season.label}の花',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      style: FilledButton.styleFrom(
        minimumSize: Size.fromHeight(compact ? 38 : 44),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: TextStyle(
          fontSize: compact ? 13 : 15,
          fontWeight: FontWeight.w800,
        ),
        padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  const _HomeButton({
    required this.compact,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.outlined = false,
  });

  final bool compact;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final minimumSize = Size.fromHeight(compact ? 44 : 54);
    final textStyle = TextStyle(
      fontSize: compact ? 14 : 17,
      fontWeight: FontWeight.w700,
    );

    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: compact ? 19 : 22),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        style: OutlinedButton.styleFrom(
          minimumSize: minimumSize,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          textStyle: textStyle,
          padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 18),
        ),
      );
    }

    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: compact ? 19 : 22),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      style: FilledButton.styleFrom(
        minimumSize: minimumSize,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: textStyle,
        padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 18),
      ),
    );
  }
}
