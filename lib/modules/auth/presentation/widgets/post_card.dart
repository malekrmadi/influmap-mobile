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

class _PostCardState extends State<PostCard> with SingleTickerProviderStateMixin {
  bool _showComments = false;
  bool _isLiked = false;
  bool _isSaved = false;
  final TextEditingController _commentController = TextEditingController();
  late AnimationController _likeAnimController;
  late Animation<double> _likeAnimation;
  
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
  void initState() {
    super.initState();
    _likeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _likeAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _likeAnimController,
        curve: Curves.elasticOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _commentController.dispose();
    _likeAnimController.dispose();
    super.dispose();
  }

  void _toggleComments() {
    setState(() {
      _showComments = !_showComments;
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likeAnimController.forward().then((_) => _likeAnimController.reverse());
      }
    });
    if (widget.onLike != null) {
      widget.onLike!();
    }
  }

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.getColor(context, Colors.white, Colors.black),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user and place info
          _buildHeader(context, isDarkMode),
          
          // Post image
          Stack(
            alignment: Alignment.center,
            children: [
              _buildPostImage(context),
              // Double tap like animation
              ScaleTransition(
                scale: _likeAnimation,
                child: Opacity(
                  opacity: _likeAnimController.value,
                  child: Icon(
                    Icons.favorite,
                    size: 100,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
          
          // Action buttons
          _buildActionButtons(context, isDarkMode),
          
          // Likes count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              '128 J\'aime',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
              ),
            ),
          ),
          
          // Post content
          _buildPostContent(context, isDarkMode),
          
          // Comments count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: GestureDetector(
              onTap: _toggleComments,
              child: Text(
                'Voir les ${_comments.length} commentaires',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                ),
              ),
            ),
          ),
          
          // Post timestamp
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 4),
            child: Text(
              _formatTime(widget.post.expiresAt),
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
              ),
            ),
          ),
          
          // Comments section (conditionally visible)
          if (_showComments) _buildCommentsSection(context, isDarkMode),
        ],
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // User avatar with gradient border
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor,
                  Colors.purple,
                  Colors.orange,
                ],
              ),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: widget.postUser?.avatar != null && widget.postUser!.avatar!.isNotEmpty
                  ? NetworkImage(widget.postUser!.avatar!)
                  : null,
              child: widget.postUser?.avatar == null || widget.postUser!.avatar!.isEmpty
                  ? Icon(Icons.person, color: Colors.grey.shade600, size: 20)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          // User and place info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.postUser?.username ?? 'Utilisateur',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppTheme.getColor(
                          context, 
                          AppTheme.textPrimary, 
                          AppTheme.darkTextPrimary
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.verified,
                        size: 14,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.postPlace?.name ?? 'Lieu inconnu',
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
          ),
          // Menu
          IconButton(
            icon: const Icon(Icons.more_horiz),
            iconSize: 20,
            splashRadius: 20,
            color: AppTheme.getColor(
              context, 
              AppTheme.textSecondary, 
              AppTheme.darkTextSecondary
            ),
            onPressed: () {
              // Options menu
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildPostImage(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        if (!_isLiked) {
          _toggleLike();
        } else {
          _likeAnimController.forward().then((_) => _likeAnimController.reverse());
        }
      },
      child: Container(
        width: double.infinity,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
        ),
        child: Image.asset(
          'assets/images/posts/post1.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Image non disponible',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildPostContent(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: AppTheme.getColor(
              context, 
              AppTheme.textPrimary, 
              AppTheme.darkTextPrimary
            ),
          ),
          children: [
            TextSpan(
              text: '${widget.postUser?.username ?? 'Utilisateur'} ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: widget.post.text,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildActionButtons(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Row(
        children: [
          // Like button
          IconButton(
            onPressed: _toggleLike,
            icon: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? Colors.red : null,
              size: 28,
            ),
            splashRadius: 20,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
          // Comment button
          IconButton(
            onPressed: _toggleComments,
            icon: Icon(
              _showComments ? Icons.chat_bubble : Icons.chat_bubble_outline,
              size: 24,
            ),
            splashRadius: 20,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
          // Share button
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.send_outlined,
              size: 24,
            ),
            splashRadius: 20,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
          const Spacer(),
          // Save button
          IconButton(
            onPressed: _toggleSave,
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              size: 28,
            ),
            splashRadius: 20,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
  
  Widget _buildCommentsSection(BuildContext context, bool isDarkMode) {
    return AnimatedSize(
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.shade200,
                  child: Icon(Icons.person, color: Colors.grey.shade600, size: 16),
                ),
                const SizedBox(width: 12),
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
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppTheme.getColor(
                        context, 
                        Colors.grey.shade100, 
                        Colors.grey.shade800
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send_rounded,
                          color: AppTheme.primaryColor,
                          size: 20,
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
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.getColor(
                        context, 
                        AppTheme.textPrimary, 
                        AppTheme.darkTextPrimary
                      ),
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
  
  Widget _buildCommentItem(BuildContext context, Comment comment, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.getColor(
                        context, 
                        AppTheme.textPrimary, 
                        AppTheme.darkTextPrimary
                      ),
                    ),
                    children: [
                      TextSpan(
                        text: comment.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: comment.text,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                
                // Comment actions
                Row(
                  children: [
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
                    const SizedBox(width: 16),
                    Text(
                      'Répondre',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.getColor(
                          context, 
                          AppTheme.textSecondary, 
                          AppTheme.darkTextSecondary
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Like comment button
          IconButton(
            icon: const Icon(Icons.favorite_border, size: 14),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            color: AppTheme.getColor(
              context, 
              AppTheme.textSecondary, 
              AppTheme.darkTextSecondary
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
  
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 6) {
      return '${difference.inDays ~/ 7}sem';
    } else if (difference.inDays > 0) {
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