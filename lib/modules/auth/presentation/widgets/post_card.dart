import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';
import '../../domain/models/post_model.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/place_model.dart';

class Comment {
  final String id;
  final String userId;
  final String username;
  final String? avatar;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    this.avatar,
    required this.text,
    required this.createdAt,
  });
}

class PostCard extends StatefulWidget {
  final Post post;
  final User? postUser;
  final Place? postPlace;
  final VoidCallback? onLike;

  const PostCard({
    Key? key,
    required this.post,
    this.postUser,
    this.postPlace,
    this.onLike,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _showComments = false;
  final TextEditingController _commentController = TextEditingController();
  
  // Liste statique de commentaires pour démonstration
  final List<Comment> _comments = [
    Comment(
      id: '1',
      userId: 'user1',
      username: 'Sophie Martin',
      avatar: null,
      text: 'Cet endroit a l\'air incroyable ! J\'aimerais bien y aller ce weekend.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Comment(
      id: '2',
      userId: 'user2',
      username: 'Thomas Dubois',
      avatar: null,
      text: 'J\'étais là-bas la semaine dernière, c\'est vraiment un super lieu. Je recommande les plats végétariens !',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Comment(
      id: '3',
      userId: 'user3',
      username: 'Julie Lefebvre',
      avatar: null,
      text: 'Est-ce qu\'il y a un parking à proximité ?',
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
    ),
  ];
  
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleComments() {
    setState(() {
      _showComments = !_showComments;
    });
  }

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
          
          // Comments section (conditionally visible)
          if (_showComments) _buildCommentsSection(context, isDarkMode),
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
            backgroundImage: widget.postUser?.avatar != null && widget.postUser!.avatar!.isNotEmpty
                ? NetworkImage(widget.postUser!.avatar!)
                : null,
            child: widget.postUser?.avatar == null || widget.postUser!.avatar!.isEmpty
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
                  widget.postUser?.username ?? 'Utilisateur',
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
                  widget.postPlace?.name ?? 'Lieu inconnu',
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
            _formatTime(widget.post.expiresAt),
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
        widget.post.text,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Comments count
          Text(
            '${_comments.length} commentaires',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.getColor(
                context, 
                AppTheme.textSecondary, 
                AppTheme.darkTextSecondary
              ),
            ),
          ),
          // Action buttons
          Row(
            children: [
              // Like button
              InkWell(
                onTap: widget.onLike,
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
                onTap: _toggleComments,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _showComments 
                        ? AppTheme.primaryColor.withOpacity(0.2)
                        : AppTheme.getColor(context, Colors.grey.shade200, Colors.grey.shade800),
                  ),
                  child: Icon(
                    _showComments ? Icons.chat_bubble : Icons.chat_bubble_outline,
                    color: AppTheme.primaryColor,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildCommentsSection(BuildContext context, bool isDarkMode) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Divider
          const Divider(height: 1),
          
          // Comments list
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _comments.length,
            itemBuilder: (context, index) {
              final comment = _comments[index];
              return _buildCommentItem(context, comment, isDarkMode);
            },
          ),
          
          // Add comment input
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(Icons.person, color: Colors.grey.shade600, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Ajouter un commentaire...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: AppTheme.getColor(
                          context, 
                          AppTheme.textSecondary, 
                          AppTheme.darkTextSecondary
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppTheme.getColor(
                        context, 
                        Colors.grey.shade100, 
                        Colors.grey.shade800
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.send_rounded,
                    color: AppTheme.primaryColor,
                  ),
                  onPressed: () {
                    // Logique pour ajouter un commentaire
                    if (_commentController.text.trim().isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Commentaire envoyé: ${_commentController.text}')),
                      );
                      _commentController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCommentItem(BuildContext context, Comment comment, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: comment.avatar != null && comment.avatar!.isNotEmpty
                ? NetworkImage(comment.avatar!)
                : null,
            child: comment.avatar == null || comment.avatar!.isEmpty
                ? Icon(Icons.person, color: Colors.grey.shade600, size: 16)
                : null,
          ),
          const SizedBox(width: 12),
          
          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username and time
                Row(
                  children: [
                    Text(
                      comment.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppTheme.getColor(
                          context, 
                          AppTheme.textPrimary, 
                          AppTheme.darkTextPrimary
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(comment.createdAt),
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
                const SizedBox(height: 4),
                
                // Comment text
                Text(
                  comment.text,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.getColor(
                      context, 
                      AppTheme.textPrimary, 
                      AppTheme.darkTextPrimary
                    ),
                  ),
                ),
              ],
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