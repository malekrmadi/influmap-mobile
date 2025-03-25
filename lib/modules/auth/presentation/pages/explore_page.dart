import 'package:flutter/material.dart';
import 'package:auth/core/theme/app_theme.dart';
import 'package:auth/setup_locator.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/place_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/place_repository.dart';
import '../widgets/user_card.dart';
import '../widgets/place_card.dart';
import 'user_details_page.dart';
import 'place_details_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late final UserRepository _userRepository;
  late final PlaceRepository _placeRepository;
  
  List<User> _users = [];
  List<Place> _places = [];
  String _searchQuery = '';
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
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
      final users = await _userRepository.getAllUsers();
      final places = await _placeRepository.getAllPlaces();
      
      setState(() {
        _users = users;
        _places = places;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement des données: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToUserDetails(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsPage(
          userId: user.id,
          user: user,
        ),
      ),
    );
  }

  void _navigateToPlaceDetails(Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceDetailsPage(
          placeId: place.id,
          place: place,
        ),
      ),
    );
  }

  void _filterData(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  List<User> get _filteredUsers {
    if (_searchQuery.isEmpty) {
      return _users;
    }
    return _users.where((user) => 
      user.username.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      (user.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
    ).toList();
  }

  List<Place> get _filteredPlaces {
    if (_searchQuery.isEmpty) {
      return _places;
    }
    return _places.where((place) => 
      place.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      place.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      place.description.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage.isNotEmpty
              ? _buildErrorState()
              : _buildExploreContent(),
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

  Widget _buildExploreContent() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadData,
            color: AppTheme.primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section des utilisateurs
                  _buildSectionHeader('Utilisateurs à découvrir', _filteredUsers.length),
                  _buildUsersList(),
                  
                  // Divider
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Divider(),
                  ),
                  
                  // Section des lieux
                  _buildSectionHeader('Lieux populaires', _filteredPlaces.length),
                  _buildPlacesList(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.getColor(
          context,
          Colors.grey.shade100,
          Colors.grey.shade900,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        onChanged: _filterData,
        decoration: InputDecoration(
          hintText: 'Rechercher des utilisateurs ou des lieux...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _filterData('');
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          filled: true,
          fillColor: AppTheme.getColor(
            context,
            Colors.white,
            Colors.grey.shade800,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
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

  Widget _buildUsersList() {
    if (_filteredUsers.isEmpty) {
      return _buildEmptyListMessage('Aucun utilisateur ne correspond à votre recherche.');
    }

    return Container(
      height: 220,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filteredUsers.length,
        itemBuilder: (context, index) {
          final user = _filteredUsers[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 16),
            child: UserCard(
              user: user,
              isHovered: false,
              onViewDetails: () => _navigateToUserDetails(user),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlacesList() {
    if (_filteredPlaces.isEmpty) {
      return _buildEmptyListMessage('Aucun lieu ne correspond à votre recherche.');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _filteredPlaces.length,
        itemBuilder: (context, index) {
          final place = _filteredPlaces[index];
          return PlaceCard(
            place: place,
            isHovered: false,
            onViewDetails: () => _navigateToPlaceDetails(place),
          );
        },
      ),
    );
  }

  Widget _buildEmptyListMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
            ),
          ),
        ],
      ),
    );
  }
} 