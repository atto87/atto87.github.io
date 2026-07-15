class Flower {
  const Flower({
    required this.id,
    required this.name,
    required this.imagePaths,
    required this.difficulty,
    required this.season,
    required this.colors,
    required this.description,
    required this.howToIdentify,
    required this.similarFlowers,
    required this.flowerMeanings,
  });

  final String id;
  final String name;
  final List<String> imagePaths;
  String get imagePath => imagePaths.first;
  final FlowerDifficulty difficulty;
  final String season;
  final List<String> colors;
  final String description;
  final String howToIdentify;
  final List<String> similarFlowers;
  final List<String> flowerMeanings;
}

enum FlowerDifficulty {
  beginner,
  intermediate,
  advanced,
}

enum FlowerQuizSeason {
  spring,
  summer,
  autumn,
  winter,
}

extension FlowerDifficultyLabel on FlowerDifficulty {
  String get title {
    switch (this) {
      case FlowerDifficulty.beginner:
        return '初級';
      case FlowerDifficulty.intermediate:
        return '中級';
      case FlowerDifficulty.advanced:
        return '上級';
    }
  }

  String get appLabel {
    switch (this) {
      case FlowerDifficulty.beginner:
        return '初級：まず覚えたい定番の花';
      case FlowerDifficulty.intermediate:
        return '中級：花屋・花壇でよく見る花';
      case FlowerDifficulty.advanced:
        return '上級：植物園・花好き向けの花';
    }
  }
}

extension FlowerQuizSeasonLabel on FlowerQuizSeason {
  String get label {
    switch (this) {
      case FlowerQuizSeason.spring:
        return '春';
      case FlowerQuizSeason.summer:
        return '夏';
      case FlowerQuizSeason.autumn:
        return '秋';
      case FlowerQuizSeason.winter:
        return '冬';
    }
  }

  String get quizTitle => '$labelの花クイズ';
}
