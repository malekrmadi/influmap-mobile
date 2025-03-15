import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/user_model.dart';

/// A widget that displays user profile statistics
class ProfileStats extends StatelessWidget {
  final User? currentUser;
  final String? username;
  final String followersCount;
  final String followingCount;
  final Widget? avatar;
  final VoidCallback? onProfileTap;

  const ProfileStats({
    Key? key,
    this.currentUser,
    this.username,
    this.followersCount = '0',
    this.followingCount = '0',
    this.avatar,
    this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final primaryColor = isLight ? AppTheme.primaryColor : AppTheme.darkPrimaryColor;
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isLight 
            ? LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.9),
                  AppTheme.primaryColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  AppTheme.darkPrimaryColor.withOpacity(0.9),
                  AppTheme.darkPrimaryColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatColumn(
              followersCount, 
              'Abonnés', 
              context,
              icon: Icons.people,
            ),
            GestureDetector(
              onTap: onProfileTap,
              child: Hero(
                tag: 'user_avatar',
                child: _buildAvatar(primaryColor),
              ),
            ),
            _buildStatColumn(
              followingCount, 
              'Abonnements', 
              context,
              icon: Icons.person_add,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, BuildContext context, {IconData? icon}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon ?? Icons.star,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
  
  Widget _buildAvatar(Color primaryColor) {
    final displayName = currentUser?.username ?? username ?? 'User';
    final initials = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
    
    return Container(
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: avatar ?? ClipOval(
        child: currentUser?.avatar != null
            ? Image.network(
                currentUser!.avatar!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildInitialsAvatar(initials),
              )
            : _buildInitialsAvatar(initials),
      ),
    );
  }
  
  Widget _buildInitialsAvatar(String initials) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.accentGradient,
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
} 