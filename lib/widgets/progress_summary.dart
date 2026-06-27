import 'package:flutter/material.dart';

import '../services/learning_progress_service.dart';

class ProgressSummary extends StatelessWidget {
  const ProgressSummary({
    super.key,
    required this.summary,
  });

  final ProgressSummaryData summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1E4E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '学習状況',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  label: '正解数',
                  value: '${summary.totalCorrect}',
                ),
              ),
              Expanded(
                child: _SummaryItem(
                  label: '花の数',
                  value: '${summary.registeredFlowerCount}',
                ),
              ),
              Expanded(
                child: _SummaryItem(
                  label: '苦手',
                  value: '${summary.weakFlowerCount}',
                ),
              ),
            ],
          ),
          if (summary.lastStudiedAt != null) ...[
            const SizedBox(height: 12),
            Text(
              '最後の学習: ${_formatDate(summary.lastStudiedAt!)}',
              style: const TextStyle(color: Color(0xFF7A666B)),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month}/${dateTime.day}';
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFFE35D82),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF7A666B),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
