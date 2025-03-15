import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// A widget that displays user profile statistics
class ProfileStats extends StatelessWidget {
  final String followersCount;
  final String followingCount;
  final Widget? avatar;

  const ProfileStats({
    Key? key,
    required this.followersCount,
    required this.followingCount,
    this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryColor = isLight ? AppTheme.primaryColor : AppTheme.darkPrimaryColor;
    final statsCardColor = isLight ? Colors.white : Colors.grey[850]!;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statsCardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatColumn(followersCount, 'Abonnés', context),
            Hero(
              tag: 'user_avatar',
              child: avatar ?? Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, AppTheme.accentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            _buildStatColumn(followingCount, 'Abonnements', context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
          ),
        ),
      ],
    );
  }
} 