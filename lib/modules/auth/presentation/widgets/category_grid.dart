import 'package:flutter/material.dart';
import '../../domain/models/place_model.dart';
import 'place_card.dart';

/// A widget that displays a grid of place cards for a selected category
class CategoryGrid extends StatefulWidget {
  final List<Place> places;
  final String selectedCategory;
  final Function(Place) onPlaceSelected;

  const CategoryGrid({
    Key? key,
    required this.places,
    required this.selectedCategory,
    required this.onPlaceSelected,
  }) : super(key: key);

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  int _hoveredCardIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Filter places by selected category
    final filteredPlaces = widget.places
        .where((place) => place.category == widget.selectedCategory)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: filteredPlaces.isEmpty
          ? _buildEmptyState()
          : GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredPlaces.length,
              itemBuilder: (context, index) {
                final place = filteredPlaces[index];
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
                      isHovered: _hoveredCardIndex == index,
                      onViewDetails: () => widget.onPlaceSelected(place),
                    ),
                  ),
                );
              },
            ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun établissement trouvé dans cette catégorie',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
} 