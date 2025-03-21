import 'package:flutter/material.dart';
//import 'package:carousel_slider/carousel_slider.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:auth/modules/auth/presentation/bloc/auth_bloc.dart';
//import 'package:auth/modules/auth/presentation/bloc/auth_event.dart';
//import 'package:flutter/services.dart';
import 'package:auth/setup_locator.dart';
//import 'login_page.dart';
import 'place_details_page.dart';
import 'user_details_page.dart';

// Import the extracted widgets and theme
import '../../../../core/theme/app_theme.dart';
import '../widgets/index.dart';
import '../../domain/models/place_model.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/place_repository.dart';
import '../../domain/repositories/user_repository.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  late final UserRepository _userRepository;
  late final PlaceRepository _placeRepository;
  late Future<List<User>> _usersFuture;
  late Future<List<Place>> _placesFuture;
  String _selectedCategory = 'Restaurant';
  late TabController _tabController;
  late AnimationController _animationController;
  bool _isDarkMode = false;
  bool _isLoading = true;
  String _errorMessage = '';
  
  List<Place> _places = [];
  List<User> _users = [];
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _userRepository = sl<UserRepository>();
    _placeRepository = sl<PlaceRepository>();
    _usersFuture = _userRepository.getAllUsers();
    _placesFuture = _placeRepository.getAllPlaces();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final places = await _placesFuture;
      final users = await _usersFuture;
      
      // For demo purposes, set the first user as current user
      final currentUser = users.isNotEmpty ? users.first : null;
      
      setState(() {
        _places = places;
        _users = users;
        _currentUser = currentUser;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement des données: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading 
          ? _buildLoadingState() 
          : _errorMessage.isNotEmpty 
              ? _buildErrorState() 
              : _buildBody(context),
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
            'Chargement des données...',
            style: TextStyle(
              color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
            ),
          ),
        ],
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
            'Erreur',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Tab Bar
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Places'),
                  Tab(text: 'Users'),
                ],
                labelColor: AppTheme.getColor(context, AppTheme.primaryColor, AppTheme.darkPrimaryColor),
                unselectedLabelColor: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                indicatorColor: AppTheme.getColor(context, AppTheme.primaryColor, AppTheme.darkPrimaryColor),
              ),
            ),
            
            // Profile Stats Section
            ProfileStats(
              currentUser: _currentUser,
              followersCount: _currentUser?.followersCount.toString() ?? '0',
              followingCount: _currentUser?.followingCount.toString() ?? '0',
            ),
            
            // Carousel of Profiles
            ProfileCarousel(
              users: _users,
              onUserSelected: _navigateToUserDetails,
            ),
            
            // Tab Content
            SizedBox(
              height: 600, // Fixed height for tab content
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Places Tab
                  Column(
                    children: [
                      // Category Selection
                      CategorySelection(
                        categories: ["Restaurant", "Café", "Bar"],
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                      
                      // Category Grid
                      CategoryGrid(
                        places: _places,
                        selectedCategory: _selectedCategory,
                        onPlaceSelected: _navigateToPlaceDetails,
                      ),
                    ],
                  ),
                  
                  // Users Tab
                  UserGrid(
                    users: _users,
                    onUserSelected: _navigateToUserDetails,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}