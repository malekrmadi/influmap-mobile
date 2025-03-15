import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/services.dart';
import 'login_page.dart';

// Import the extracted widgets and theme
import '../../../../core/theme/app_theme.dart';
import '../widgets/index.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  String selectedCategory = "Restaurant";
  late AnimationController _animationController;
  bool _isDarkMode = false;

  final List<Map<String, dynamic>> profiles = List.generate(10, (index) => {
    "name": "Personne $index",
    "tag": "Tag $index",
    "image": Icons.person,
  });

  final Map<String, List<Map<String, String>>> categories = {
    "Restaurant": List.generate(6, (index) => {
      "image": "assets/images/restaurant.png",
      "address": "Restaurant $index",
      "description": "Cuisine délicieuse et ambiance chaleureuse",
    }),
    "Café": List.generate(6, (index) => {
      "image": "assets/images/cafe.png",
      "address": "Café $index",
      "description": "Ambiance cosy et bon café",
    }),
    "Bar": List.generate(6, (index) => {
      "image": "assets/images/bar.png",
      "address": "Bar $index",
      "description": "Cocktails et bonne musique",
    }),
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.getThemeData(_isDarkMode),
      child: Scaffold(
        backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Tableau de bord",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
          tooltip: _isDarkMode ? "Mode clair" : "Mode sombre",
          onPressed: _toggleTheme,
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return IconButton(
              icon: Transform.rotate(
                angle: _animationController.value * 2.0 * 3.14159,
                child: Icon(Icons.logout),
              ),
              tooltip: "Déconnexion",
              onPressed: () {
                _animationController.forward(from: 0.0).then((_) {
                  context.read<AuthBloc>().add(LogoutRequested());
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          BlocProvider.value(
                        value: context.read<AuthBloc>(),
                        child: LoginForm(),
                      ),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOutCubic;
                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                });
              },
            );
          },
        ),
      ],
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Stats Section
          ProfileStats(
            followersCount: '120',
            followingCount: '98',
          ),
          
          // Carousel of Profiles
          ProfileCarousel(profiles: profiles),
          
          // Category Selection
          CategorySelection(
            categories: ["Restaurant", "Café", "Bar"],
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
              });
            },
          ),
          
          // Category Grid
          CategoryGrid(
            categories: categories,
            selectedCategory: selectedCategory,
          ),
        ],
      ),
    );
  }
}