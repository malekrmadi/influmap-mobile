import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';
import 'package:auth/setup_locator.dart';
import 'package:shimmer/shimmer.dart'; // Ajout d'un effet de chargement animé
import '../../domain/models/post_model.dart';
import '../../domain/repositories/post_repository.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late final PostRepository _postRepository;
  List<Post> _posts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _postRepository = sl<PostRepository>();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final posts = await _postRepository.getAllPosts();
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement des posts: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage.isNotEmpty
              ? _buildErrorState()
              : _buildFeedList(),
    );
  }

  /// Effet Shimmer lors du chargement
  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            height: 120,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadPosts,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Réessayer', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedList() {
  return RefreshIndicator(
    onRefresh: _loadPosts,
    child: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        String? imageUrl = post.media.isNotEmpty ? post.media.first : null; // Get first image if available

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post type and location info
              ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Icon(
                  post.type == 'Story' ? Icons.auto_stories : Icons.post_add,
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
                title: Text(
                  'Lieu ID: ${post.placeId}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  'Type: ${post.type}',
                  style: TextStyle(
                    color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                  ),
                ),
              ),

              // Image with error handling
              if (imageUrl != null && imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey.shade300,
                        child: const Center(child: Icon(Icons.image_not_supported, size: 50)),
                      );
                    },
                  ),
                )
              else
                // Default placeholder if no media is available
                Container(
                  height: 200,
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(Icons.image, size: 50, color: Colors.white),
                  ),
                ),

              // Post text
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  post.text,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
                  ),
                ),
              ),

              // Additional details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Expire le: ${_formatDate(post.expiresAt)}',
                      style: TextStyle(
                        color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                        fontSize: 12,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Action bouton
                      },
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Partager'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    ),
  );
}



  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
