import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';
import '../../domain/models/post_model.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/place_model.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final User? postUser;
  final Place? postPlace;
  final VoidCallback? onLike;
  final VoidCallback? onComment;

  const PostCard({
    Key? key,
    required this.post,
    this.postUser,
    this.postPlace,
    this.onLike,
    this.onComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user and place info
          _buildHeader(context, isDarkMode),
          
          // Post image
          _buildPostImage(context),
          
          // Post content
          _buildPostContent(context, isDarkMode),
          
          // Actions (like, comment)
          _buildActionButtons(context, isDarkMode),
        ],
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          // User avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: postUser?.avatar != null && postUser!.avatar!.isNotEmpty
                ? NetworkImage(postUser!.avatar!)
                : null,
            child: postUser?.avatar == null || postUser!.avatar!.isEmpty
                ? Icon(Icons.person, color: Colors.grey.shade600)
                : null,
          ),
          const SizedBox(width: 12),
          // User and place info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  postUser?.username ?? 'Utilisateur',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppTheme.getColor(
                      context, 
                      AppTheme.textPrimary, 
                      AppTheme.darkTextPrimary
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  postPlace?.name ?? 'Lieu inconnu',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.getColor(
                      context, 
                      AppTheme.textSecondary, 
                      AppTheme.darkTextSecondary
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Time
          Text(
            _formatTime(post.expiresAt),
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.getColor(
                context, 
                AppTheme.textSecondary, 
                AppTheme.darkTextSecondary
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPostImage(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
      ),
      child: Image.asset(
        'assets/images/posts/post1.jpg',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(
              Icons.image_not_supported,
              size: 50,
              color: Colors.grey.shade400,
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildPostContent(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        post.text,
        style: TextStyle(
          fontSize: 15,
          height: 1.4,
          color: AppTheme.getColor(
            context, 
            AppTheme.textPrimary, 
            AppTheme.darkTextPrimary
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionButtons(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Like button
          InkWell(
            onTap: onLike,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.getColor(
                  context, 
                  Colors.grey.shade200, 
                  Colors.grey.shade800
                ),
              ),
              child: Icon(
                Icons.favorite_border,
                color: AppTheme.primaryColor,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Comment button
          InkWell(
            onTap: onComment,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.getColor(
                  context, 
                  Colors.grey.shade200, 
                  Colors.grey.shade800
                ),
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                color: AppTheme.primaryColor,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}j';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min';
    } else {
      return 'maintenant';
    }
  }
} 