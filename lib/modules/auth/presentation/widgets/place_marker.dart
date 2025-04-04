import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';
import '../../domain/models/place_model.dart';

class PlaceMarker extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;

  const PlaceMarker({
    Key? key,
    required this.place,
    required this.onTap,
  }) : super(key: key);

  Color _getCategoryColor() {
    switch (place.category.toLowerCase()) {
      case 'restaurant':
        return Colors.orange;
      case 'café':
        return Colors.brown;
      case 'bar':
        return Colors.purple;
      case 'événement':
        return Colors.red;
      case 'autre':
        return Colors.teal;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getCategoryIcon() {
    switch (place.category.toLowerCase()) {
      case 'restaurant':
        return Icons.restaurant;
      case 'café':
        return Icons.coffee;
      case 'bar':
        return Icons.local_bar;
      case 'événement':
        return Icons.event;
      case 'autre':
        return Icons.location_on;
      default:
        return Icons.place;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor();
    final icon = _getCategoryIcon();
    
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Affichage du nom du lieu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              place.name,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          // Marqueur avec icône
          Container(
            width: 36,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
} 