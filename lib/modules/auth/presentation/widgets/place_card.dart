import 'package:flutter/material.dart';
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
    return Card(
      elevation: isHovered ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section - using a placeholder based on category
          AspectRatio(
            aspectRatio: 1.5,
            child: _buildPlaceholderImage(place.category),
          ),
          
          // Content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${place.location.latitude}, ${place.location.longitude}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${place.rating}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${place.reviewsCount} reviews)',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  // Spacer to push button to bottom
                  const Spacer(),
                  
                  // View Details button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onViewDetails,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('View Details'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }
} 