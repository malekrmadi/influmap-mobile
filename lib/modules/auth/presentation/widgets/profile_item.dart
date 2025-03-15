import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/user_model.dart';

/// A widget that displays a single profile item in the carousel
class ProfileItem extends StatelessWidget {
  final User user;
  final bool isHovered;
  final VoidCallback? onTap;

  const ProfileItem({
    Key? key,
    required this.user,
    this.isHovered = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryColor = isLight ? AppTheme.primaryColor : AppTheme.darkPrimaryColor;
    
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuint,
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              gradient: isHovered 
                  ? AppTheme.primaryGradient
                  : null,
              color: isHovered ? null : (isLight ? Colors.white : Colors.grey[800]),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(isHovered ? 0.4 : 0.1),
                  blurRadius: isHovered ? 12 : 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildAvatar(isHovered, primaryColor),
          ),
          
          const SizedBox(height: 8),
          
          // Username
          Text(
            user.username,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
          
          const SizedBox(height: 2),
          
          // Email
          Text(
            user.email,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAvatar(bool isHovered, Color primaryColor) {
    return ClipOval(
      child: user.avatar != null
          ? Image.network(
              user.avatar!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(isHovered, primaryColor),
            )
          : _buildDefaultAvatar(isHovered, primaryColor),
    );
  }
  
  Widget _buildDefaultAvatar(bool isHovered, Color primaryColor) {
    return Center(
      child: Icon(
        Icons.person,
        size: 35,
        color: isHovered ? Colors.white : primaryColor,
      ),
    );
  }
} 