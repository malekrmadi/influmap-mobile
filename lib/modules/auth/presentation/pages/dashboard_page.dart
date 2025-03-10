import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/services.dart';
import 'login_page.dart';

// Theme class to manage colors
class AppTheme {
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color accentColor = Color(0xFF03DAC6);
  static const Color cardColor = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFBDBDBD);
  
  // Dark theme colors
  static const Color darkPrimaryColor = Color(0xFF8267BE);
  static const Color darkCardColor = Color(0xFF2D2D2D);
  static const Color darkTextPrimary = Color(0xFFE1E1E1);
  static const Color darkTextSecondary = Color(0xFFAAAAAA);
  
  // Returns color based on brightness
  static Color getColor(BuildContext context, Color lightColor, Color darkColor) {
    return Theme.of(context).brightness == Brightness.light ? lightColor : darkColor;
  }
  
  // Get text theme based on brightness
  static TextTheme getTextTheme(BuildContext context) {
    return Theme.of(context).textTheme.apply(
      bodyColor: getColor(context, textPrimary, darkTextPrimary),
      displayColor: getColor(context, textPrimary, darkTextPrimary),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  String selectedCategory = "Restaurant";
  late AnimationController _animationController;
  int _hoveredCardIndex = -1;
  int _hoveredProfileIndex = -1;
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
    final brightness = _isDarkMode ? Brightness.dark : Brightness.light;
    final backgroundColor = _isDarkMode ? Colors.grey[900]! : Colors.white;
    final cardColor = _isDarkMode ? AppTheme.darkCardColor : AppTheme.cardColor;
    
    return Theme(
      data: ThemeData(
        brightness: brightness,
        primaryColor: _isDarkMode ? AppTheme.darkPrimaryColor : AppTheme.primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppTheme.accentColor,
          brightness: brightness,
        ),
        cardColor: cardColor,
        appBarTheme: AppBarTheme(
          backgroundColor: _isDarkMode ? Colors.grey[850] : AppTheme.primaryColor,
          elevation: 0,
          systemOverlayStyle: brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
        ),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: _buildAppBar(context),
        body: _buildBody(context, cardColor),
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

  Widget _buildBody(BuildContext context, Color cardColor) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Stats Section
          _buildProfileStats(context),
          
          // Carousel of Profiles
          _buildProfileCarousel(context),
          
          // Category Selection
          _buildCategorySelection(context),
          
          // Category Grid
          _buildCategoryGrid(context, cardColor),
        ],
      ),
    );
  }

  Widget _buildProfileStats(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryColor = isLight ? AppTheme.primaryColor : AppTheme.darkPrimaryColor;
    final statsCardColor = isLight ? Colors.white : Colors.grey[850]!;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statsCardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatColumn('120', 'Abonnés', context),
            Hero(
              tag: 'user_avatar',
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, AppTheme.accentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            _buildStatColumn('98', 'Abonnements', context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCarousel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: Text(
            "Personnes à suivre",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              return MouseRegion(
                onEnter: (_) => setState(() => _hoveredProfileIndex = index),
                onExit: (_) => setState(() => _hoveredProfileIndex = -1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  transform: Matrix4.identity()
                    ..translate(0.0, _hoveredProfileIndex == index ? -8.0 : 0.0),
                  child: _buildProfileItem(profiles[index], context, index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem(Map<String, dynamic> profile, BuildContext context, int index) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryColor = isLight ? AppTheme.primaryColor : AppTheme.darkPrimaryColor;
    final isHovered = _hoveredProfileIndex == index;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuint,
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: isHovered ? primaryColor : (isLight ? Colors.white : Colors.grey[800]),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(isHovered ? 0.4 : 0.1),
                blurRadius: isHovered ? 12 : 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            profile["image"],
            size: 35,
            color: isHovered ? Colors.white : primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          profile["name"],
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          profile["tag"],
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              "Catégories",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ["Restaurant", "Café", "Bar"].map((category) {
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutQuint,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                          HapticFeedback.lightImpact();
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutQuint,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppTheme.getColor(context, AppTheme.primaryColor, AppTheme.darkPrimaryColor)
                                : AppTheme.getColor(context, Colors.grey[200]!, Colors.grey[800]!),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppTheme.getColor(
                                        context, 
                                        AppTheme.primaryColor.withOpacity(0.3), 
                                        AppTheme.darkPrimaryColor.withOpacity(0.3)
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, Color cardColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories[selectedCategory]!.length,
        itemBuilder: (context, index) {
          final place = categories[selectedCategory]![index];
          return MouseRegion(
            onEnter: (_) => setState(() => _hoveredCardIndex = index),
            onExit: (_) => setState(() => _hoveredCardIndex = -1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuint,
              transform: Matrix4.identity()
                ..translate(0.0, _hoveredCardIndex == index ? -5.0 : 0.0),
              child: _buildPlaceCard(place, context, index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, String> place, BuildContext context, int index) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isHovered = _hoveredCardIndex == index;
    
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getColor(context, Colors.white, Colors.grey[850]!),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isHovered
                ? AppTheme.getColor(
                    context, 
                    AppTheme.primaryColor.withOpacity(0.3), 
                    AppTheme.darkPrimaryColor.withOpacity(0.3)
                  )
                : AppTheme.getColor(
                    context, 
                    Colors.black.withOpacity(0.1), 
                    Colors.black.withOpacity(0.2)
                  ),
            blurRadius: isHovered ? 12 : 6,
            offset: Offset(0, isHovered ? 4 : 2),
            spreadRadius: isHovered ? 2 : 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: place["image"] != null
                        ? Image.asset(
                            place["image"]!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: isLight ? Colors.grey[300] : Colors.grey[700],
                            child: const Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: isLight ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${(3.5 + index % 1.5).toStringAsFixed(1)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: isLight ? Colors.black : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place["address"]!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      place["description"]!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isLight ? Colors.grey[200] : Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            selectedCategory,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutQuint,
                          decoration: BoxDecoration(
                            color: isHovered
                                ? AppTheme.getColor(context, AppTheme.primaryColor, AppTheme.darkPrimaryColor)
                                : AppTheme.getColor(context, Colors.grey[200]!, Colors.grey[800]!),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: isHovered
                                ? Colors.white
                                : AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}