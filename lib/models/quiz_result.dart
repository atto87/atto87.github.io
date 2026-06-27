import 'flower.dart';

class QuizAnswerRecord {
  const QuizAnswerRecord({
    required this.flower,
    required this.selectedName,
    required this.isCorrect,
  });

  final Flower flower;
  final String selectedName;
  final bool isCorrect;
}

class QuizResult {
  const QuizResult({
    required this.totalQuestions,
    required this.correctCount,
    required this.answers,
    this.isReviewMode = false,
    this.difficulty = FlowerDifficulty.beginner,
  });

  final int totalQuestions;
  final int correctCount;
  final List<QuizAnswerRecord> answers;
  final bool isReviewMode;
  final FlowerDifficulty difficulty;

  int get incorrectCount => totalQuestions - correctCount;

  double get accuracy {
    if (totalQuestions == 0) {
      return 0;
    }
    return correctCount / totalQuestions;
  }

  List<Flower> get missedFlowers {
    final seenIds = <String>{};
    return answers
        .where((answer) => !answer.isCorrect)
        .map((answer) => answer.flower)
        .where((flower) => seenIds.add(flower.id))
        .toList();
  }
}
