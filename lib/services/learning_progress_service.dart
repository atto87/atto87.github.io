import 'package:shared_preferences/shared_preferences.dart';

import '../data/flower_data.dart';

class FlowerProgress {
  const FlowerProgress({
    required this.correctCount,
    required this.wrongCount,
  });

  final int correctCount;
  final int wrongCount;

  bool get needsReview => wrongCount > correctCount;
}

class ProgressSummaryData {
  const ProgressSummaryData({
    required this.totalCorrect,
    required this.registeredFlowerCount,
    required this.weakFlowerCount,
    required this.lastStudiedAt,
  });

  final int totalCorrect;
  final int registeredFlowerCount;
  final int weakFlowerCount;
  final DateTime? lastStudiedAt;
}

class LearningProgressService {
  static const String _lastStudiedKey = 'last_studied_at';

  Future<FlowerProgress> getProgress(String flowerId) async {
    final prefs = await SharedPreferences.getInstance();
    return FlowerProgress(
      correctCount: prefs.getInt(_correctKey(flowerId)) ?? 0,
      wrongCount: prefs.getInt(_wrongKey(flowerId)) ?? 0,
    );
  }

  Future<Map<String, FlowerProgress>> getAllProgress() async {
    final result = <String, FlowerProgress>{};
    for (final flower in flowers) {
      result[flower.id] = await getProgress(flower.id);
    }
    return result;
  }

  Future<ProgressSummaryData> getSummary() async {
    final prefs = await SharedPreferences.getInstance();
    var totalCorrect = 0;
    var weakFlowerCount = 0;

    for (final flower in flowers) {
      final correct = prefs.getInt(_correctKey(flower.id)) ?? 0;
      final wrong = prefs.getInt(_wrongKey(flower.id)) ?? 0;
      totalCorrect += correct;
      if (wrong > correct) {
        weakFlowerCount++;
      }
    }

    final lastStudiedText = prefs.getString(_lastStudiedKey);
    return ProgressSummaryData(
      totalCorrect: totalCorrect,
      registeredFlowerCount: flowers.length,
      weakFlowerCount: weakFlowerCount,
      lastStudiedAt:
          lastStudiedText == null ? null : DateTime.tryParse(lastStudiedText),
    );
  }

  Future<void> recordAnswer({
    required String flowerId,
    required bool isCorrect,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = isCorrect ? _correctKey(flowerId) : _wrongKey(flowerId);
    final currentCount = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, currentCount + 1);
    await prefs.setString(_lastStudiedKey, DateTime.now().toIso8601String());
  }

  static String _correctKey(String flowerId) => 'flower_${flowerId}_correct';

  static String _wrongKey(String flowerId) => 'flower_${flowerId}_wrong';
}
