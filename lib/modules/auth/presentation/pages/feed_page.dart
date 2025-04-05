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

class _FeedPageState extends State<FeedPage> with SingleTickerProviderStateMixin {
  late final PostRepository _postRepository;
  late final UserRepository _userRepository;
  late final PlaceRepository _placeRepository;
  late final TabController _tabController;
  
  List<Post> _posts = [];
  Map<String, User> _usersCache = {};
  Map<String, Place> _placesCache = {};
  
  bool _isLoading = true;
  String _errorMessage = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _postRepository = sl<PostRepository>();
    _userRepository = sl<UserRepository>();
    _placeRepository = sl<PlaceRepository>();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
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
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: true,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              centerTitle: false,
              title: Text(
                'InfluMap',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withBlue(255),
                      ],
                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, size: 28),
                  color: AppTheme.primaryColor,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.add_box_outlined, size: 28),
                  color: AppTheme.primaryColor,
                  onPressed: () {},
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: AppTheme.primaryColor,
                indicatorWeight: 3,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: AppTheme.getColor(
                  context,
                  AppTheme.textSecondary,
                  AppTheme.darkTextSecondary,
                ),
                tabs: const [
                  Tab(text: 'Pour vous'),
                  Tab(text: 'Suivis'),
                  Tab(text: 'Tendances'),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: _buildStoryBar(),
            ),
          ];
        },
        body: _isLoading
            ? _buildLoadingState()
            : _errorMessage.isNotEmpty
                ? _buildErrorState()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildFeedList(),
                      _buildFeedList(), // Placeholder pour l'onglet "Suivis"
                      _buildFeedList(), // Placeholder pour l'onglet "Tendances"
                    ],
                  ),
      ),
    );
  }

  Widget _buildStoryBar() {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          bool isFirst = index == 0;
          
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isFirst 
                          ? [Colors.grey.shade300, Colors.grey.shade400]
                          : [
                              AppTheme.primaryColor.withOpacity(0.7),
                              Colors.purple.shade700,
                              Colors.orangeAccent,
                            ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isFirst
                            ? Colors.grey.withOpacity(0.3)
                            : AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: isFirst
                          ? const Icon(Icons.add, color: Colors.grey)
                          : Text(
                              String.fromCharCode(65 + index - 1),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isFirst ? 'Ajouter' : 'User ${String.fromCharCode(65 + index - 1)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isFirst ? FontWeight.normal : FontWeight.bold,
                    color: AppTheme.getColor(
                      context,
                      AppTheme.textPrimary,
                      AppTheme.darkTextPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              // Header shimmer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                height: 300,
                color: Colors.white,
              ),
              // Actions shimmer
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              // Content shimmer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 50,
              color: AppTheme.errorColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Oups ! Quelque chose s\'est mal passé',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
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
      displacement: 80,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          final user = _usersCache[post.userId];
          final place = _placesCache[post.placeId];
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: PostCard(
              post: post,
              postUser: user,
              postPlace: place,
              onLike: () {
                // Implémenter la fonctionnalité like
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    width: 200,
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    content: Text(
                      'Aimé le post de ${user?.username ?? "utilisateur"}!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
