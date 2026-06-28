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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          alignment: Alignment.centerLeft,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (_statusLabel != null) ...[
              const SizedBox(width: 8),
              _AnswerStatus(label: _statusLabel!, color: _statusColor(context)),
            ],
          ],
        ),
      ),
    );
  }

  String? get _statusLabel {
    if (!hasAnswered) {
      return null;
    }
    if (isCorrectAnswer) {
      return '正解！';
    }
    if (isSelected) {
      return '不正解';
    }
    return null;
  }

  Color _statusColor(BuildContext context) {
    if (isCorrectAnswer) {
      return const Color(0xFF25823B);
    }
    return Theme.of(context).colorScheme.error;
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

class _AnswerStatus extends StatelessWidget {
  const _AnswerStatus({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 13,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
