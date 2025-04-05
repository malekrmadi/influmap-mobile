import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';
import '../../domain/models/place_model.dart';

class PlaceMarker extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;
  final bool showLabel;
  final double scale;

  const PlaceMarker({
    Key? key,
    required this.place,
    required this.onTap,
    this.showLabel = true,
    this.scale = 1.0,
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
          // Affichage du nom du lieu (conditionnellement)
          if (showLabel)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8 * scale, 
                vertical: 4 * scale
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12 * scale),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4 * scale,
                    offset: Offset(0, 2 * scale),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Nom du lieu
                  Text(
                    place.name,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 10 * scale,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Tags (si le zoom est suffisant)
                  if (scale > 1.0 && place.tags.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 2 * scale),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 4 * scale,
                        children: place.tags.take(2).map((tag) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4 * scale,
                            vertical: 2 * scale,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4 * scale),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 8 * scale,
                              color: color,
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          // Marqueur avec icône
          Container(
            width: 36 * scale,
            height: 48 * scale,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18 * scale),
                topRight: Radius.circular(18 * scale),
                bottomLeft: Radius.circular(4 * scale),
                bottomRight: Radius.circular(18 * scale),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5 * scale,
                  offset: Offset(0, 3 * scale),
                ),
              ],
            ),
            padding: EdgeInsets.all(6 * scale),
            child: Icon(
              icon,
              size: 18 * scale,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
} 