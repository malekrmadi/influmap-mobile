import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// A widget that displays a single profile item in the carousel
class ProfileItem extends StatelessWidget {
  final String name;
  final String tag;
  final IconData icon;
  final bool isHovered;

  const ProfileItem({
    Key? key,
    required this.name,
    required this.tag,
    required this.icon,
    this.isHovered = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryColor = isLight ? AppTheme.primaryColor : AppTheme.darkPrimaryColor;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuint,
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: isHovered ? primaryColor : (isLight ? Colors.white : Colors.grey[800]),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(isHovered ? 0.4 : 0.1),
                blurRadius: isHovered ? 12 : 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 35,
            color: isHovered ? Colors.white : primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          tag,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
          ),
        ),
      ],
    );
  }
} 