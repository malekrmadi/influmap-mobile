import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';

/// A widget that displays a horizontal list of selectable categories
class CategorySelection extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final String title;

  const CategorySelection({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.title = "Catégories",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: categories.map((category) {
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: _buildCategoryButton(context, category, isSelected),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoryButton(BuildContext context, String category, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onCategorySelected(category);
          HapticFeedback.lightImpact();
        },
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuint,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected 
                ? (isDark ? AppTheme.darkPrimaryGradient : AppTheme.primaryGradient)
                : null,
            color: isSelected 
                ? null
                : AppTheme.getColor(context, Colors.grey[200]!, Colors.grey[800]!),
            borderRadius: BorderRadius.circular(24),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.getColor(
                        context, 
                        AppTheme.primaryColor.withOpacity(0.3), 
                        AppTheme.darkPrimaryColor.withOpacity(0.3)
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _getCategoryIcon(category, isSelected),
              const SizedBox(width: 8),
              Text(
                category,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _getCategoryIcon(String category, bool isSelected) {
    IconData iconData;
    
    switch (category) {
      case 'Restaurant':
        iconData = Icons.restaurant;
        break;
      case 'Café':
        iconData = Icons.coffee;
        break;
      case 'Bar':
        iconData = Icons.local_bar;
        break;
      default:
        iconData = Icons.place;
    }
    
    return Icon(
      iconData,
      size: 18,
      color: isSelected ? Colors.white : Colors.grey,
    );
  }
} 