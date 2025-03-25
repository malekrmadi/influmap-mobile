import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';
import '../../domain/models/place_model.dart';

/// A widget that displays a place card with image, rating, and details
class PlaceCard extends StatelessWidget {
  final Place place;
  final bool isHovered;
  final VoidCallback onViewDetails;

  const PlaceCard({
    Key? key,
    required this.place,
    required this.isHovered,
    required this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onViewDetails,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: isHovered ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section - taille fixe
            SizedBox(
              height: 120,
              width: double.infinity,
              child: _buildPlaceholderImage(place.category),
            ),
            
            // Content section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title with category badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(place.category).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            place.category,
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: _getCategoryColor(place.category),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Location
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: Colors.grey),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            '${place.location.latitude.toStringAsFixed(2)}, ${place.location.longitude.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          '${place.rating}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            '(${place.reviewsCount} reviews)',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPlaceholderImage(String category) {
    // Create a placeholder image based on category
    IconData iconData;
    Color backgroundColor;
    
    switch (category) {
      case 'Restaurant':
        iconData = Icons.restaurant;
        backgroundColor = Colors.orange.shade200;
        break;
      case 'Café':
        iconData = Icons.coffee;
        backgroundColor = Colors.brown.shade200;
        break;
      case 'Bar':
        iconData = Icons.local_bar;
        backgroundColor = Colors.purple.shade200;
        break;
      default:
        iconData = Icons.place;
        backgroundColor = Colors.blue.shade200;
    }
    
    return Container(
      color: backgroundColor,
      child: Center(
        child: Icon(
          iconData,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
  
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Restaurant':
        return Colors.orange;
      case 'Café':
        return Colors.brown;
      case 'Bar':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
} 