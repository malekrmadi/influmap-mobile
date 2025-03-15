import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// A widget that displays a place card with image, rating, and details
class PlaceCard extends StatelessWidget {
  final Map<String, String> place;
  final String category;
  final bool isHovered;
  final double rating;

  const PlaceCard({
    Key? key,
    required this.place,
    required this.category,
    this.isHovered = false,
    this.rating = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getColor(context, Colors.white, Colors.grey[850]!),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isHovered
                ? AppTheme.getColor(
                    context, 
                    AppTheme.primaryColor.withOpacity(0.3), 
                    AppTheme.darkPrimaryColor.withOpacity(0.3)
                  )
                : AppTheme.getColor(
                    context, 
                    Colors.black.withOpacity(0.1), 
                    Colors.black.withOpacity(0.2)
                  ),
            blurRadius: isHovered ? 12 : 6,
            offset: Offset(0, isHovered ? 4 : 2),
            spreadRadius: isHovered ? 2 : 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: place["image"] != null
                        ? Image.asset(
                            place["image"]!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: isLight ? Colors.grey[300] : Colors.grey[700],
                            child: const Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isLight ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: isLight ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place["address"] ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      place["description"] ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isLight ? Colors.grey[200] : Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutQuint,
                          decoration: BoxDecoration(
                            color: isHovered
                                ? AppTheme.getColor(context, AppTheme.primaryColor, AppTheme.darkPrimaryColor)
                                : AppTheme.getColor(context, Colors.grey[200]!, Colors.grey[800]!),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: isHovered
                                ? Colors.white
                                : AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
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
} 