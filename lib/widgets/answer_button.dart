import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSelected = false,
    this.isCorrectAnswer = false,
    this.hasAnswered = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isSelected;
  final bool isCorrectAnswer;
  final bool hasAnswered;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = _backgroundColor();
    final borderColor = _borderColor(colorScheme);

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF3F3336),
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          alignment: Alignment.centerLeft,
        ),
        child: Text(text),
      ),
    );
  }

  Color _backgroundColor() {
    if (!hasAnswered) {
      return Colors.white;
    }
    if (isCorrectAnswer) {
      return const Color(0xFFE3F6E8);
    }
    if (isSelected) {
      return const Color(0xFFFFE5E8);
    }
    return Colors.white;
  }

  Color _borderColor(ColorScheme colorScheme) {
    if (!hasAnswered) {
      return const Color(0xFFEADDE1);
    }
    if (isCorrectAnswer) {
      return const Color(0xFF43A85D);
    }
    if (isSelected) {
      return colorScheme.error;
    }
    return const Color(0xFFEADDE1);
  }
}
