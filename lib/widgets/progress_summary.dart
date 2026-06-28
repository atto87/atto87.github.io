import 'package:flutter/material.dart';

import '../services/learning_progress_service.dart';

class ProgressSummary extends StatelessWidget {
  const ProgressSummary({
    super.key,
    required this.summary,
    this.compact = false,
  });

  final ProgressSummaryData summary;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 12 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1E4E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '学習状況',
            style: TextStyle(
              fontSize: compact ? 16 : 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: compact ? 8 : 14),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  label: '正解数',
                  value: '${summary.totalCorrect}',
                  compact: compact,
                ),
              ),
              Expanded(
                child: _SummaryItem(
                  label: '花の数',
                  value: '${summary.registeredFlowerCount}',
                  compact: compact,
                ),
              ),
              Expanded(
                child: _SummaryItem(
                  label: '苦手',
                  value: '${summary.weakFlowerCount}',
                  compact: compact,
                ),
              ),
            ],
          ),
          if (summary.lastStudiedAt != null) ...[
            SizedBox(height: compact ? 8 : 12),
            Text(
              '最後の学習 ${_formatDate(summary.lastStudiedAt!)}',
              style: TextStyle(
                color: const Color(0xFF7A666B),
                fontSize: compact ? 12 : 14,
              ),
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
    required this.compact,
  });

  final String label;
  final String value;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: compact ? 20 : 24,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFE35D82),
          ),
        ),
        SizedBox(height: compact ? 0 : 2),
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF7A666B),
            fontWeight: FontWeight.w700,
            fontSize: compact ? 12 : 14,
          ),
        ),
      ],
    );
  }
}
