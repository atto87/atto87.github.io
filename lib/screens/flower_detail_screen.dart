import 'package:flutter/material.dart';

import '../data/flower_data.dart';
import '../models/flower.dart';

class FlowerDetailScreen extends StatelessWidget {
  const FlowerDetailScreen({super.key});

  static const String routeName = '/flower-detail';

  @override
  Widget build(BuildContext context) {
    final flower = ModalRoute.of(context)!.settings.arguments! as Flower;

    return Scaffold(
      appBar: AppBar(title: Text(flower.name)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.asset(
                  flower.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _LargePlaceholder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              flower.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            _InfoRow(label: '段階', value: flower.difficulty.appLabel),
            _InfoRow(label: '季節', value: flower.season),
            _InfoRow(label: '色', value: flower.colors.join('、')),
            _InfoRow(label: '花言葉', value: flower.flowerMeanings.join('、')),
            const SizedBox(height: 16),
            _Section(title: '特徴', body: flower.description),
            _Section(title: '見分け方', body: flower.howToIdentify),
            if (flower.similarFlowers.isNotEmpty)
              _SimilarFlowersSection(
                similarFlowerNames: flower.similarFlowers,
              ),
          ],
        ),
      ),
    );
  }
}

class _SimilarFlowersSection extends StatelessWidget {
  const _SimilarFlowersSection({
    required this.similarFlowerNames,
  });

  final List<String> similarFlowerNames;

  @override
  Widget build(BuildContext context) {
    final similarFlowers =
        similarFlowerNames.map(flowerByName).whereType<Flower>().toList();

    if (similarFlowers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '似ている花',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final flower in similarFlowers)
                ActionChip(
                  avatar: const Icon(Icons.local_florist, size: 18),
                  label: Text(flower.name),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    FlowerDetailScreen.routeName,
                    arguments: flower,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LargePlaceholder extends StatelessWidget {
  const _LargePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFEEF2),
      alignment: Alignment.center,
      child: const Icon(
        Icons.local_florist,
        color: Color(0xFFE97896),
        size: 72,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF7A666B),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Color(0xFF514548),
            ),
          ),
        ],
      ),
    );
  }
}
