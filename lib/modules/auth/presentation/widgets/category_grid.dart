import 'package:flutter/material.dart';
import 'place_card.dart';

/// A widget that displays a grid of place cards for a selected category
class CategoryGrid extends StatefulWidget {
  final Map<String, List<Map<String, String>>> categories;
  final String selectedCategory;

  const CategoryGrid({
    Key? key,
    required this.categories,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  int _hoveredCardIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: widget.categories[widget.selectedCategory]!.length,
        itemBuilder: (context, index) {
          final place = widget.categories[widget.selectedCategory]![index];
          return MouseRegion(
            onEnter: (_) => setState(() => _hoveredCardIndex = index),
            onExit: (_) => setState(() => _hoveredCardIndex = -1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuint,
              transform: Matrix4.identity()
                ..translate(0.0, _hoveredCardIndex == index ? -5.0 : 0.0),
              child: PlaceCard(
                place: place,
                category: widget.selectedCategory,
                isHovered: _hoveredCardIndex == index,
                rating: 3.5 + (index % 1.5),
              ),
            ),
          );
        },
      ),
    );
  }
} 