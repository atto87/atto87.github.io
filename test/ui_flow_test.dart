import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hana_quiz_zukan/main.dart';
import 'package:hana_quiz_zukan/models/flower.dart';
import 'package:hana_quiz_zukan/widgets/answer_button.dart';
import 'package:hana_quiz_zukan/services/learning_progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final size in [
    const Size(320, 568),
    const Size(375, 812),
    const Size(812, 375)
  ]) {
    testWidgets('home controls remain reachable at $size', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const HanaQuizApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('復習する'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('復習する'));
      await tester.pumpAndSettle();
      expect(find.text('いま復習が必要な花はありません。'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('ten answers save once, show result, retry, and return home',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(375, 812));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const HanaQuizApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text(FlowerDifficulty.beginner.appLabel));
    await tester.pumpAndSettle();
    for (var question = 0; question < 10; question++) {
      final correct = find.byWidgetPredicate(
          (widget) => widget is AnswerButton && widget.isCorrectAnswer);
      await tester.ensureVisible(correct);
      await tester.pumpAndSettle();
      await tester.tap(correct);
      await tester.tap(correct);
      await tester.pumpAndSettle();
      expect(find.text('正解！ ひと花、覚えました。'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text(question == 9 ? '結果を見る' : '次の問題'));
      await tester.pumpAndSettle();
    }
    expect(find.text('10問中 10問正解'), findsOneWidget);
    expect(find.text('満開です、おめでとう！'), findsOneWidget);
    final summary = await LearningProgressService().getSummary();
    expect(summary.totalCorrect, 10);
    expect(summary.weakFlowerCount, 0);
    await tester.tap(find.text('もう一度挑戦'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 10'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('あなたの学習ノート'), findsOneWidget);
  });

  testWidgets('large text home remains usable', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.binding.setSurfaceSize(const Size(375, 812));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const HanaQuizApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('図鑑を見る'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('図鑑を見る'));
    await tester.pumpAndSettle();
    expect(find.text('図鑑'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
