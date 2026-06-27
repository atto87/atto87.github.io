import 'package:flutter/material.dart';

import 'quiz_screen.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  static const String routeName = '/review';

  @override
  Widget build(BuildContext context) {
    return const QuizScreen(reviewOnly: true);
  }
}
