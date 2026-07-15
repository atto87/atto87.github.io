import 'package:flutter/material.dart';

import '../data/flower_data.dart';
import '../models/flower.dart';

class FlowerDetailArguments {
  const FlowerDetailArguments({
    required this.flowers,
    required this.initialIndex,
  });

  final List<Flower> flowers;
  final int initialIndex;
}

class FlowerDetailScreen extends StatefulWidget {
  const FlowerDetailScreen({super.key});

  static const String routeName = '/flower-detail';

  @override
  State<FlowerDetailScreen> createState() => _FlowerDetailScreenState();
}

class _FlowerDetailScreenState extends State<FlowerDetailScreen> {
  late List<Flower> _flowers;
  late PageController _pageController;
  int _currentIndex = 0;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is FlowerDetailArguments && arguments.flowers.isNotEmpty) {
      _flowers = List<Flower>.of(arguments.flowers);
      _currentIndex = arguments.initialIndex.clamp(0, _flowers.length - 1);
    } else if (arguments is Flower) {
      _flowers = List<Flower>.of(flowers);
      final index = _flowers.indexWhere((flower) => flower.id == arguments.id);
      _currentIndex = index < 0 ? 0 : index;
    } else {
      _flowers = List<Flower>.of(flowers);
    }

    _pageController = PageController(initialPage: _currentIndex);
    _initialized = true;
  }

  @override
  void dispose() {
    if (_initialized) _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flower = _flowers[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(flower.name),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${_currentIndex + 1}/${_flowers.length}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                key: const Key('flower-detail-pages'),
                controller: _pageController,
                itemCount: _flowers.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) =>
                    _FlowerDetailPage(flower: _flowers[index]),
              ),
            ),
            _PageNavigation(
              previousName:
                  _currentIndex > 0 ? _flowers[_currentIndex - 1].name : null,
              nextName: _currentIndex < _flowers.length - 1
                  ? _flowers[_currentIndex + 1].name
                  : null,
              onPrevious:
                  _currentIndex > 0 ? () => _goToPage(_currentIndex - 1) : null,
              onNext: _currentIndex < _flowers.length - 1
                  ? () => _goToPage(_currentIndex + 1)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}

class _FlowerDetailPage extends StatelessWidget {
  const _FlowerDetailPage({required this.flower});

  final Flower flower;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: PageStorageKey<String>('flower-detail-${flower.id}'),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        _FlowerImageGallery(flower: flower),
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
          _SimilarFlowersSection(similarFlowerNames: flower.similarFlowers),
      ],
    );
  }
}

class _FlowerImageGallery extends StatefulWidget {
  const _FlowerImageGallery({required this.flower});

  final Flower flower;

  @override
  State<_FlowerImageGallery> createState() => _FlowerImageGalleryState();
}

class _FlowerImageGalleryState extends State<_FlowerImageGallery> {
  late final PageController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagePaths = widget.flower.imagePaths;
    final hasMultipleImages = imagePaths.length > 1;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: GestureDetector(
              onTap: hasMultipleImages ? _showNextImage : null,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    key: Key('flower-image-gallery-${widget.flower.id}'),
                    controller: _controller,
                    physics: hasMultipleImages
                        ? const PageScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    itemCount: imagePaths.length,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemBuilder: (context, index) => Image.asset(
                      imagePaths[index],
                      key: Key('flower-image-${widget.flower.id}-$index'),
                      fit: BoxFit.cover,
                      semanticLabel: index == 0
                          ? '${widget.flower.name}の花のアップ'
                          : '${widget.flower.name}の葉や株、群生の様子',
                      errorBuilder: (_, __, ___) => const _LargePlaceholder(),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.62),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Text(
                          '${_currentIndex + 1}/${imagePaths.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.62),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: Text(
                          _currentIndex == 0 ? '花のアップ' : '葉・株・群生の様子',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (hasMultipleImages) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var index = 0; index < imagePaths.length; index++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: index == _currentIndex ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: index == _currentIndex
                        ? const Color(0xFFE35D82)
                        : const Color(0xFFE2D3D7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            '画像をタップまたは左右にスワイプ',
            style: TextStyle(
              color: Color(0xFF7A666B),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  void _showNextImage() {
    final nextIndex = (_currentIndex + 1) % widget.flower.imagePaths.length;
    _controller.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}

class _PageNavigation extends StatelessWidget {
  const _PageNavigation({
    required this.previousName,
    required this.nextName,
    required this.onPrevious,
    required this.onNext,
  });

  final String? previousName;
  final String? nextName;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1E4E8))),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: onPrevious,
                icon: const Icon(Icons.chevron_left),
                label: Text(
                  previousName ?? '前の花',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '左右にスワイプ',
                style: TextStyle(
                  color: Color(0xFF7A666B),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: onNext,
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.chevron_right),
                label: Text(
                  nextName ?? '次の花',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimilarFlowersSection extends StatelessWidget {
  const _SimilarFlowersSection({required this.similarFlowerNames});

  final List<String> similarFlowerNames;

  @override
  Widget build(BuildContext context) {
    final similarFlowers =
        similarFlowerNames.map(flowerByName).whereType<Flower>().toList();

    if (similarFlowers.isEmpty) return const SizedBox.shrink();

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
  const _InfoRow({required this.label, required this.value});

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
  const _Section({required this.title, required this.body});

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
