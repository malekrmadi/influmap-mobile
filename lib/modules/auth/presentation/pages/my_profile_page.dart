import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';
import 'package:auth/setup_locator.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../widgets/profile_stats.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late final UserRepository _userRepository;
  User? _currentUser;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _userRepository = sl<UserRepository>();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Pour l'instant, on récupère le premier utilisateur comme utilisateur courant
      final users = await _userRepository.getAllUsers();
      setState(() {
        _currentUser = users.isNotEmpty ? users.first : null;
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
            onPressed: _loadCurrentUser,
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec photo de profil
          _buildProfileHeader(),
          
          // Statistiques (followers, following)
          ProfileStats(
            currentUser: _currentUser!,
            followersCount: _currentUser!.followersCount.toString(),
            followingCount: _currentUser!.followingCount.toString(),
          ),
          
          // Section badges
          _buildBadgesSection(),
          
          // Section Activité Récente
          _buildRecentActivitySection(),
          
          // Actions
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: _currentUser?.avatar != null && _currentUser!.avatar!.isNotEmpty
                ? NetworkImage(_currentUser!.avatar!)
                : null,
            child: _currentUser?.avatar == null || _currentUser!.avatar!.isEmpty
                ? Icon(Icons.person, size: 50, color: Colors.grey.shade600)
                : null,
          ),
          const SizedBox(height: 16),
          
          // Nom d'utilisateur
          Text(
            _currentUser?.username ?? 'Utilisateur',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
          const SizedBox(height: 8),
          
          // Email
          Text(
            _currentUser?.email ?? 'email@example.com',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
            ),
          ),
          const SizedBox(height: 8),
          
          // Niveau
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Niveau ${_currentUser?.level ?? 1}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection() {
    final badges = _currentUser?.badges ?? ['Explorer', 'Reviewer', 'Top Contributor'];
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Badges',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: badges.map((badge) {
              return Chip(
                avatar: const Icon(Icons.star, size: 16),
                label: Text(badge),
                backgroundColor: AppTheme.getColor(
                  context,
                  Colors.grey.shade200,
                  Colors.grey.shade800,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activité Récente',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
          const SizedBox(height: 16),
          _buildActivityItem(
            icon: Icons.place,
            title: "Vous avez visité Le Petit Café",
            time: "Il y a 2 jours",
          ),
          _buildActivityItem(
            icon: Icons.star,
            title: "Vous avez obtenu le badge 'Explorer'",
            time: "Il y a 5 jours",
          ),
          _buildActivityItem(
            icon: Icons.comment,
            title: "Vous avez commenté chez Restaurant Du Coin",
            time: "Il y a 1 semaine",
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.getColor(
          context,
          Colors.grey.shade100,
          Colors.grey.shade800,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
} 