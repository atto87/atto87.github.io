import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hana_quiz_zukan/models/flower.dart';
import 'package:hana_quiz_zukan/screens/encyclopedia_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hana_quiz_zukan/main.dart';

void main() {
  testWidgets('shows the home screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const HanaQuizApp());
    await tester.pumpAndSettle();

    expect(find.byType(FilledButton), findsNWidgets(3));
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
