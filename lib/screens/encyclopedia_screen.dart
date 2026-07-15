import 'package:flutter/material.dart';

import '../data/flower_data.dart';
import '../models/flower.dart';
import '../screens/flower_detail_screen.dart';
import '../widgets/flower_card.dart';

class EncyclopediaScreen extends StatefulWidget {
  const EncyclopediaScreen({super.key});

  static const String routeName = '/encyclopedia';

  @override
  State<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends State<EncyclopediaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allFlowers = filterFlowers(flowers, _query);
    final beginnerFlowers = filterFlowers(
      flowersByDifficulty(FlowerDifficulty.beginner),
      _query,
    );
    final intermediateFlowers = filterFlowers(
      flowersByDifficulty(FlowerDifficulty.intermediate),
      _query,
    );
    final advancedFlowers = filterFlowers(
      flowersByDifficulty(FlowerDifficulty.advanced),
      _query,
    );

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: TextField(
                  key: const Key('flower-search-field'),
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: '花の名前などで検索',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: '検索をクリア',
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            icon: const Icon(Icons.clear),
                          ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFF1E4E8)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFF1E4E8)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _FlowerGrid(flowers: allFlowers),
                    _FlowerGrid(flowers: beginnerFlowers),
                    _FlowerGrid(flowers: intermediateFlowers),
                    _FlowerGrid(flowers: advancedFlowers),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Flower> filterFlowers(List<Flower> source, String query) {
  final normalizedQuery = query.trim().toLowerCase();
  if (normalizedQuery.isEmpty) {
    return List<Flower>.of(source);
  }

  return source.where((flower) {
    final searchableText = [
      flower.name,
      flower.season,
      ...flower.colors,
      ...flower.flowerMeanings,
      flower.description,
      flower.howToIdentify,
    ].join(' ').toLowerCase();
    return searchableText.contains(normalizedQuery);
  }).toList();
}

class _FlowerGrid extends StatelessWidget {
  const _FlowerGrid({required this.flowers});

  final List<Flower> flowers;

  @override
  Widget build(BuildContext context) {
    if (flowers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 52, color: Color(0xFFB89CA4)),
            SizedBox(height: 12),
            Text(
              '該当する花が見つかりません',
              style: TextStyle(
                color: Color(0xFF7A666B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

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
          onTap: () => _openDetail(context, index),
        );
      },
    );
  }

  void _openDetail(BuildContext context, int index) {
    Navigator.pushNamed(
      context,
      FlowerDetailScreen.routeName,
      arguments: FlowerDetailArguments(flowers: flowers, initialIndex: index),
    );
  }
}
