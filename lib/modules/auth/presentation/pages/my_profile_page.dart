import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';
import 'package:auth/setup_locator.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/place_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/place_repository.dart';
import '../widgets/profile_stats.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> with SingleTickerProviderStateMixin {
  late final UserRepository _userRepository;
  late final PlaceRepository _placeRepository;
  late TabController _tabController;
  
  User? _currentUser;
  List<Place> _visitedPlaces = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _userRepository = sl<UserRepository>();
    _placeRepository = sl<PlaceRepository>();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Pour l'instant, on récupère le premier utilisateur comme utilisateur courant
      final users = await _userRepository.getAllUsers();
      final places = await _placeRepository.getAllPlaces();
      
      // Simuler les lieux visités en prenant quelques lieux au hasard
      final visitedPlaces = List<Place>.from(places);
      visitedPlaces.shuffle();
      
      setState(() {
        _currentUser = users.isNotEmpty ? users.first : null;
        _visitedPlaces = visitedPlaces.take(5).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement du profil: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage.isNotEmpty
              ? _buildErrorState()
              : _buildProfileContent(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
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

  Widget _buildProfileContent() {
    if (_currentUser == null) {
      return const Center(
        child: Text('Aucun profil disponible'),
      );
    }

    return CustomScrollView(
      slivers: [
        // App Bar avec photo de profil et nom
        _buildProfileAppBar(),
        
        // Contenu
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats cards
              _buildStatsCards(),
              
              // Section badges
              _buildBadgesSection(),
              
              // Tabs
              _buildTabs(),
              
              // TabBarView
              _buildTabContent(),
              
              // Actions
              _buildActionButtons(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        title: Text(
          _currentUser?.username ?? 'Utilisateur',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Fond avec dégradé
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.7),
                    AppTheme.primaryColor,
                  ],
                ),
              ),
            ),
            // Avatar et infos en overlay
            Positioned(
              top: 40,
              left: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _currentUser?.avatar != null && _currentUser!.avatar!.isNotEmpty
                          ? NetworkImage(_currentUser!.avatar!)
                          : null,
                      child: _currentUser?.avatar == null || _currentUser!.avatar!.isEmpty
                          ? Icon(Icons.person, size: 38, color: Colors.grey.shade600)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Infos supplémentaires
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentUser?.email ?? 'email@example.com',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amberAccent, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              'Niveau ${_currentUser?.level ?? 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mes Statistiques',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                icon: Icons.people,
                title: 'Followers',
                value: _currentUser?.followersCount.toString() ?? '0',
                iconColor: Colors.blue,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                icon: Icons.person_add,
                title: 'Following',
                value: _currentUser?.followingCount.toString() ?? '0',
                iconColor: Colors.purple,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                icon: Icons.place,
                title: 'Lieux visités',
                value: _visitedPlaces.length.toString(),
                iconColor: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.getColor(
            context,
            Colors.grey.shade100,
            Colors.grey.shade800,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesSection() {
    final badges = _getBadges();
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mes Badges',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: badges.map((badge) => _buildBadgeItem(badge)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(Map<String, dynamic> badge) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: badge['color'],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: badge['color'].withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(badge['icon'], color: Colors.white, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            badge['name'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
          Text(
            badge['description'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: AppTheme.primaryColor,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.getColor(
              context,
              AppTheme.textSecondary,
              AppTheme.darkTextSecondary,
            ),
            tabs: const [
              Tab(text: 'Lieux Visités'),
              Tab(text: 'Mes Préférences'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 300, // Hauteur fixe pour le contenu des onglets
      child: TabBarView(
        controller: _tabController,
        children: [
          // Onglet Lieux Visités
          _buildVisitedPlacesTab(),
          
          // Onglet Préférences
          _buildPreferencesTab(),
        ],
      ),
    );
  }

  Widget _buildVisitedPlacesTab() {
    if (_visitedPlaces.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Vous n\'avez pas encore visité de lieux',
              style: TextStyle(
                color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _visitedPlaces.length,
      itemBuilder: (context, index) {
        final place = _visitedPlaces[index];
        return _buildVisitedPlaceItem(place);
      },
    );
  }

  Widget _buildVisitedPlaceItem(Place place) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.getColor(
          context,
          Colors.white,
          Colors.grey.shade800,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(place.category),
          child: Icon(_getCategoryIcon(place.category), color: Colors.white, size: 20),
        ),
        title: Text(
          place.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              place.category,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${place.rating}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.reviews, size: 14, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  '${place.reviewsCount} avis',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: () {
            // Navigation vers la page de détails du lieu
          },
        ),
      ),
    );
  }

  Widget _buildPreferencesTab() {
    final preferences = [
      {
        'name': 'Cuisine préférée',
        'value': 'Française, Italienne',
        'icon': Icons.restaurant,
      },
      {
        'name': 'Type de lieu',
        'value': 'Restaurants, Cafés',
        'icon': Icons.place,
      },
      {
        'name': 'Budget moyen',
        'value': '15€ - 35€',
        'icon': Icons.euro,
      },
      {
        'name': 'Ambiance',
        'value': 'Calme, Romantique',
        'icon': Icons.mood,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: preferences.length,
      itemBuilder: (context, index) {
        final pref = preferences[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.getColor(
              context,
              Colors.white,
              Colors.grey.shade800,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
              child: Icon(pref['icon'] as IconData, color: AppTheme.primaryColor, size: 20),
            ),
            title: Text(
              pref['name'] as String,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
              ),
            ),
            subtitle: Text(
              pref['value'] as String,
              style: TextStyle(
                color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
              ),
            ),
            trailing: const Icon(Icons.edit, size: 16),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // Action de modification du profil
              },
              icon: const Icon(Icons.edit),
              label: const Text('Modifier Profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // Action de partage du profil
              },
              icon: const Icon(Icons.share),
              label: const Text('Partager Profil'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: AppTheme.primaryColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fonction d'aide pour générer des badges
  List<Map<String, dynamic>> _getBadges() {
    final badges = [
      {
        'name': 'Street Food',
        'description': 'Niveau 5',
        'icon': Icons.food_bank,
        'color': Colors.orange,
      },
      {
        'name': 'Gourmet',
        'description': 'Niveau 3',
        'icon': Icons.restaurant,
        'color': Colors.red,
      },
      {
        'name': 'Voyageur',
        'description': '10 lieux',
        'icon': Icons.travel_explore,
        'color': Colors.blue,
      },
      {
        'name': 'Barista',
        'description': 'Niveau 4',
        'icon': Icons.coffee,
        'color': Colors.brown,
      },
      {
        'name': 'Explorateur',
        'description': '15 quartiers',
        'icon': Icons.explore,
        'color': Colors.purple,
      },
    ];
    
    return badges;
  }

  // Fonctions pour obtenir les icônes et couleurs des catégories
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'restaurant':
        return Icons.restaurant;
      case 'café':
        return Icons.coffee;
      case 'bar':
        return Icons.local_bar;
      case 'événement':
        return Icons.event;
      case 'autre':
        return Icons.place;
      default:
        return Icons.place;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'restaurant':
        return Colors.orange;
      case 'café':
        return Colors.brown;
      case 'bar':
        return Colors.purple;
      case 'événement':
        return Colors.red;
      case 'autre':
        return Colors.teal;
      default:
        return Colors.blueGrey;
    }
  }
} 