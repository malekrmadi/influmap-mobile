import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import 'package:auth/setup_locator.dart';

class UserDetailsPage extends StatefulWidget {
  final String userId;
  final User? user; // Optional user object if already loaded

  const UserDetailsPage({
    Key? key,
    required this.userId,
    this.user,
  }) : super(key: key);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late Future<User> _userFuture;
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _userRepository = sl<UserRepository>();
    _userFuture = widget.user != null 
        ? Future.value(widget.user)
        : _userRepository.getUserById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (snapshot.hasData) {
            return _buildUserDetails(snapshot.data!);
          } else {
            return _buildErrorState('Aucune information disponible');
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Chargement des détails...',
            style: TextStyle(
              color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
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
            'Erreur lors du chargement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Retour'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetails(User user) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return CustomScrollView(
      slivers: [
        // App Bar with user avatar
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              user.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                _buildUserAvatar(user),
                // Gradient overlay for better text visibility
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.7, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // Share functionality
              },
              tooltip: 'Partager',
            ),
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {
                // Message functionality
              },
              tooltip: 'Message',
            ),
          ],
        ),
        
        // Content
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User stats
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(
                      icon: Icons.people,
                      label: 'Followers',
                      value: user.followersCount.toString(),
                    ),
                    _buildStatItem(
                      icon: Icons.person_add,
                      label: 'Following',
                      value: user.followingCount.toString(),
                    ),
                    _buildStatItem(
                      icon: Icons.star,
                      label: 'Level',
                      value: user.level.toString(),
                    ),
                  ],
                ),
              ),
              
              const Divider(),
              
              // Email
              _buildInfoSection(
                title: 'Email',
                content: user.email,
                icon: Icons.email,
              ),
              
              // Bio
              if (user.bio != null && user.bio!.isNotEmpty)
                _buildInfoSection(
                  title: 'Bio',
                  content: user.bio!,
                  icon: Icons.info,
                ),
              
              // Badges
              if (user.badges.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Badges',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: user.badges.map((badge) => _buildBadgeChip(badge)).toList(),
                      ),
                    ],
                  ),
                ),
              
              // Action buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Follow user
                        },
                        icon: const Icon(Icons.person_add),
                        label: const Text('Follow'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Message user
                        },
                        icon: const Icon(Icons.message),
                        label: const Text('Message'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
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
            fontSize: 80,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.getColor(context, AppTheme.accentColor, AppTheme.darkAccentColor),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppTheme.getColor(context, AppTheme.accentColor, AppTheme.darkAccentColor),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBadgeChip(String badge) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark 
            ? AppTheme.darkAccentColor.withOpacity(0.2) 
            : AppTheme.accentColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        badge,
        style: TextStyle(
          color: isDark ? AppTheme.darkAccentColor : AppTheme.accentColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
} 