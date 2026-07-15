import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hana_quiz_zukan/data/flower_data.dart';
import 'package:hana_quiz_zukan/models/flower.dart';

void main() {
  test('contains 100 flowers split into three difficulty levels', () {
    expect(flowers, hasLength(100));
    expect(flowersByDifficulty(FlowerDifficulty.beginner), hasLength(35));
    expect(flowersByDifficulty(FlowerDifficulty.intermediate), hasLength(35));
    expect(flowersByDifficulty(FlowerDifficulty.advanced), hasLength(30));
  });

  test('all flower ids are unique', () {
    final ids = flowers.map((flower) => flower.id).toSet();

    expect(ids, hasLength(flowers.length));
  });

  test('all similar flower names resolve to flower data', () {
    for (final flower in flowers) {
      for (final similarName in flower.similarFlowers) {
        expect(
          flowerByName(similarName),
          isNotNull,
          reason: '${flower.name} -> $similarName',
        );
      }
    }
  });

  test('all flowers have one to three flower meanings', () {
    final meaningIds = flowerMeaningsById.keys.toSet();

    expect(meaningIds, containsAll(flowers.map((flower) => flower.id)));
    for (final flower in flowers) {
      expect(
        flower.flowerMeanings.length,
        inInclusiveRange(1, 3),
        reason: flower.id,
      );
      expect(flower.flowerMeanings, isNot(contains('準備中')));
    }
  });

  test('all flowers have detail text beyond temporary placeholders', () {
    for (final flower in flowers) {
      expect(flower.colors, isNot(contains('準備中')));
      expect(flower.description, isNot(contains('準備中')));
      expect(flower.howToIdentify, isNot(contains('準備中')));
    }
  });

  test('all flower image assets exist', () {
    for (final flower in flowers) {
      for (final imagePath in flower.imagePaths) {
        expect(File(imagePath).existsSync(), isTrue, reason: flower.id);
      }
    }
  });

  test('all flowers have close-up and context images', () {
    for (final flower in flowers) {
      expect(flower.imagePaths, hasLength(2), reason: flower.id);
    }
  });

  test('asset credits cover every flower image', () {
    final credits = jsonDecode(File('asset_credits.json').readAsStringSync())
        as List<dynamic>;
    final creditIds = credits
        .cast<Map<String, dynamic>>()
        .map((credit) => credit['id'] as String)
        .toSet();
    final creditedAssets = credits
        .cast<Map<String, dynamic>>()
        .map((credit) => credit['asset'] as String)
        .toSet();

    expect(credits, hasLength(200));
    expect(creditIds, containsAll(flowers.map((flower) => flower.id)));
    expect(
      creditedAssets,
      containsAll(flowers.expand((flower) => flower.imagePaths)),
    );
  });
}
