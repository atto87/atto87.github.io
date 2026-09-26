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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E6DA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'あなたの学習ノート',
            style: TextStyle(
              fontSize: compact ? 12 : 16,
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
                  label: '図鑑の花',
                  value: '${summary.registeredFlowerCount}',
                  compact: compact,
                ),
              ),
              Expanded(
                child: _SummaryItem(
                  label: '復習する花',
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
                color: const Color(0xFF727C70),
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
            color: const Color(0xFF35634D),
          ),
        ),
        SizedBox(height: compact ? 0 : 2),
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF727C70),
            fontWeight: FontWeight.w700,
            fontSize: compact ? 12 : 14,
          ),
        ),
      ],
    );
  }
}
