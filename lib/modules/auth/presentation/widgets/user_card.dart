import 'package:flutter/material.dart';
import '../../domain/models/user_model.dart';
import 'package:auth/core/theme/app_theme.dart';

class UserCard extends StatelessWidget {
  final User user;
  final bool isHovered;
  final VoidCallback onViewDetails;

  const UserCard({
    Key? key,
    required this.user,
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
            // Avatar section avec taille fixe
            SizedBox(
              height: 120,
              width: double.infinity,
              child: _buildUserAvatar(user),
            ),
            
            // Content section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Username
                    Text(
                      user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    
                    // Email
                    Row(
                      children: [
                        const Icon(Icons.email, size: 12, color: Colors.grey),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            user.email ?? "",
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
                    
                    // Level
                    Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          'Level ${user.level}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
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
  
  Widget _buildUserAvatar(User user) {
    if (user.avatar != null && user.avatar!.isNotEmpty) {
      return Image.network(
        user.avatar!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildAvatarPlaceholder(user);
        },
      );
    } else {
      return _buildAvatarPlaceholder(user);
    }
  }
  
  Widget _buildAvatarPlaceholder(User user) {
    final colors = [
      Colors.blue.shade200,
      Colors.green.shade200,
      Colors.purple.shade200,
      Colors.orange.shade200,
      Colors.teal.shade200,
    ];
    
    // Use the first character of the username to select a color
    final colorIndex = user.username.isNotEmpty 
        ? user.username.codeUnitAt(0) % colors.length 
        : 0;
    
    return Container(
      color: colors[colorIndex],
      child: Center(
        child: Text(
          user.username.isNotEmpty ? user.username[0].toUpperCase() : '?',
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
} 