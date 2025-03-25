import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';
import 'package:auth/setup_locator.dart';
import 'package:shimmer/shimmer.dart';
import '../../domain/models/post_model.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/place_model.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/place_repository.dart';
import '../widgets/post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late final PostRepository _postRepository;
  late final UserRepository _userRepository;
  late final PlaceRepository _placeRepository;
  
  List<Post> _posts = [];
  Map<String, User> _usersCache = {};
  Map<String, Place> _placesCache = {};
  
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _postRepository = sl<PostRepository>();
    _userRepository = sl<UserRepository>();
    _placeRepository = sl<PlaceRepository>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final posts = await _postRepository.getAllPosts();
      
      // Préchargement des données utilisateurs et lieux pour les posts
      for (final post in posts) {
        if (!_usersCache.containsKey(post.userId)) {
          try {
            final user = await _userRepository.getUserById(post.userId);
            _usersCache[post.userId] = user;
          } catch (e) {
            print('Erreur chargement utilisateur ${post.userId}: $e');
          }
        }
        
        if (!_placesCache.containsKey(post.placeId)) {
          try {
            final place = await _placeRepository.getPlaceById(post.placeId);
            _placesCache[post.placeId] = place;
          } catch (e) {
            print('Erreur chargement lieu ${post.placeId}: $e');
          }
        }
      }
      
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

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              // Header shimmer
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Avatar shimmer
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Text shimmer
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            height: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 80,
                            height: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Image shimmer
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.white,
              ),
              // Content shimmer
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedList() {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppTheme.primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          final user = _usersCache[post.userId];
          final place = _placesCache[post.placeId];
          
          return PostCard(
            post: post,
            postUser: user,
            postPlace: place,
            onLike: () {
              // Implémenter la fonctionnalité like
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Aimé le post de ${user?.username ?? "utilisateur"}!')),
              );
            },
            onComment: () {
              // Implémenter la fonctionnalité commenter
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Commenter le post sur ${place?.name ?? "lieu"}')),
              );
            },
          );
        },
      ),
    );
  }
}
