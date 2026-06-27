import 'package:flutter/material.dart';

import '../data/flower_data.dart';
import '../models/flower.dart';
import '../screens/flower_detail_screen.dart';
import '../widgets/flower_card.dart';

class EncyclopediaScreen extends StatelessWidget {
  const EncyclopediaScreen({super.key});

  static const String routeName = '/encyclopedia';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('図鑑'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '一覧'),
              Tab(text: '初級'),
              Tab(text: '中級'),
              Tab(text: '上級'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              _FlowerGrid(flowers: flowers),
              _FlowerGrid(
                flowers: flowersByDifficulty(FlowerDifficulty.beginner),
              ),
              _FlowerGrid(
                flowers: flowersByDifficulty(FlowerDifficulty.intermediate),
              ),
              _FlowerGrid(
                flowers: flowersByDifficulty(FlowerDifficulty.advanced),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlowerGrid extends StatelessWidget {
  const _FlowerGrid({
    required this.flowers,
  });

  final List<Flower> flowers;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: flowers.length,
      itemBuilder: (context, index) {
        final flower = flowers[index];
        return FlowerCard(
          flower: flower,
          onTap: () => _openDetail(context, flower),
        );
      },
    );
  }

  void _openDetail(BuildContext context, Flower flower) {
    Navigator.pushNamed(
      context,
      FlowerDetailScreen.routeName,
      arguments: flower,
    );
  }
}
