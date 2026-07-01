import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hana_quiz_zukan/data/flower_data.dart';
import 'package:hana_quiz_zukan/models/flower.dart';
import 'package:hana_quiz_zukan/screens/encyclopedia_screen.dart';
import 'package:hana_quiz_zukan/screens/quiz_screen.dart';
import 'package:hana_quiz_zukan/services/learning_progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hana_quiz_zukan/main.dart';

void main() {
  testWidgets('shows the home screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const HanaQuizApp());
    await tester.pumpAndSettle();

    expect(find.text(FlowerDifficulty.beginner.appLabel), findsOneWidget);
    expect(find.text(FlowerDifficulty.intermediate.appLabel), findsOneWidget);
    expect(find.text(FlowerDifficulty.advanced.appLabel), findsOneWidget);
    expect(find.text('春の花'), findsOneWidget);
    expect(find.text('夏の花'), findsOneWidget);
    expect(find.text('秋の花'), findsOneWidget);
    expect(find.text('冬の花'), findsOneWidget);
    expect(find.byIcon(Icons.menu_book), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  testWidgets('home screen fits iPhone XS without internal scrolling',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(375, 812));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const HanaQuizApp());
    await tester.pumpAndSettle();

    expect(find.byType(FittedBox), findsOneWidget);
    expect(find.byType(Scrollable), findsNothing);
  });

  testWidgets('quiz omits difficulty description label',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const HanaQuizApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FilledButton).first);
    await tester.pumpAndSettle();

    expect(find.text('クイズ'), findsOneWidget);
    expect(find.text('この花の名前は？'), findsOneWidget);
    expect(find.text(FlowerDifficulty.beginner.appLabel), findsNothing);
  });

  testWidgets('season quiz opens with season title',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const HanaQuizApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('春の花'));
    await tester.pumpAndSettle();

    expect(find.text('春の花クイズ'), findsOneWidget);
    expect(find.text('この花の名前は？'), findsOneWidget);
  });

  test('season quiz filters flowers by flower season', () {
    expect(flowersBySeason(FlowerQuizSeason.spring), isNotEmpty);
    expect(flowersBySeason(FlowerQuizSeason.summer), isNotEmpty);
    expect(flowersBySeason(FlowerQuizSeason.autumn), isNotEmpty);
    expect(flowersBySeason(FlowerQuizSeason.winter), isNotEmpty);

    expect(
      flowersBySeason(FlowerQuizSeason.autumn)
          .every((flower) => flower.season.contains('秋')),
      isTrue,
    );
  });

  test('quiz flower meaning feedback text includes flower name and meanings',
      () {
    final flower = flowersByDifficulty(FlowerDifficulty.beginner).first;

    expect(
      flowerMeaningFeedbackText(flower),
      '${flower.name}の花言葉：${flower.flowerMeanings.join('、')}',
    );
  });

  test('quiz prioritizes unseen flowers', () {
    final progressMap = <String, FlowerProgress>{};
    for (final flower in flowersByDifficulty(FlowerDifficulty.beginner)) {
      if (flower.id != 'sakura') {
        progressMap[flower.id] = const FlowerProgress(
          correctCount: 1,
          wrongCount: 0,
        );
      }
    }

    final prioritizedFlowers = prioritizeUnseenFlowers(
      flowers: flowersByDifficulty(FlowerDifficulty.beginner),
      progressMap: progressMap,
      random: Random(0),
    );

    expect(prioritizedFlowers.first.id, 'sakura');
  });

  testWidgets('shows encyclopedia filter tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: EncyclopediaScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('一覧'), findsOneWidget);
    expect(find.text('初級'), findsOneWidget);
    expect(find.text('中級'), findsOneWidget);
    expect(find.text('上級'), findsOneWidget);
  });
}
