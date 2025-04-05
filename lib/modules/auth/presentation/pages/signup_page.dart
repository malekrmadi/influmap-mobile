import 'package:auth/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_event.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/core/theme/app_theme.dart';
import 'dashboard_page.dart';
import 'login_page.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> with SingleTickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController avatarController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  
  int selectedLevel = 1; // Niveau par défaut
  List<String> selectedBadges = []; // Liste des badges sélectionnés
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> availableBadges = [
    "Débutant", "Intermédiaire", "Expert", "Master", "Légendaire"
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    avatarController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() {
              isLoading = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
          
          if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<AuthBloc>(),
                  child: DashboardPage(),
                ),
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppTheme.errorColor,
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppTheme.accentColor.withOpacity(0.2),
                    AppTheme.primaryColor.withOpacity(0.1),
                  ],
                ),
              ),
            ),
            // Background pattern
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: CustomPaint(
                  painter: BackgroundPatternPainter(AppTheme.accentColor),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      // Back button and title
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.getColor(
                                  context,
                                  Colors.white,
                                  AppTheme.darkCardColor.withOpacity(0.7),
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: 18,
                                  color: AppTheme.primaryColor,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            SizedBox(width: 16),
                            Text(
                              "Créer un compte",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()..shader = LinearGradient(
                                  colors: [
                                    AppTheme.primaryColor,
                                    AppTheme.accentColor,
                                  ],
                                ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      // Logo or App icon
                      Center(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.accentColor,
                                  AppTheme.primaryColor,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person_add_alt_1_rounded,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      // Welcome text
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Rejoignez-nous",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()..shader = LinearGradient(
                                    colors: [
                                      AppTheme.primaryColor,
                                      AppTheme.accentColor,
                                    ],
                                  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Créez votre profil pour commencer",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.getColor(context, AppTheme.textSecondary, AppTheme.darkTextSecondary),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      // Form fields with animations
                      // Username
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildTextField(
                          controller: usernameController,
                          hintText: "Nom d'utilisateur",
                          icon: Icons.person_outline,
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Email
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildTextField(
                          controller: emailController,
                          hintText: "Email",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Password
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildTextField(
                          controller: passwordController,
                          hintText: "Mot de passe",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppTheme.primaryColor.withOpacity(0.7),
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Confirm Password
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildTextField(
                          controller: confirmPasswordController,
                          hintText: "Confirmer le mot de passe",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isConfirmPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppTheme.primaryColor.withOpacity(0.7),
                            ),
                            onPressed: () {
                              setState(() {
                                isConfirmPasswordVisible = !isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      
                      // Level selector with modern design
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                              child: Text(
                                "Votre niveau",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.getColor(
                                  context,
                                  Colors.white.withOpacity(0.9),
                                  AppTheme.darkCardColor.withOpacity(0.7),
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 15,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Niveau ${selectedLevel}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
                                        ),
                                      ),
                                      Row(
                                        children: List.generate(
                                          5,
                                          (index) => Icon(
                                            Icons.star,
                                            size: 20,
                                            color: index < selectedLevel
                                                ? AppTheme.primaryColor
                                                : AppTheme.getColor(
                                                    context,
                                                    Colors.grey.shade300,
                                                    Colors.grey.shade700,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  SliderTheme(
                                    data: SliderThemeData(
                                      trackHeight: 6,
                                      activeTrackColor: AppTheme.primaryColor,
                                      inactiveTrackColor: AppTheme.getColor(
                                        context,
                                        Colors.grey.shade200,
                                        Colors.grey.shade800,
                                      ),
                                      thumbColor: AppTheme.accentColor,
                                      overlayColor: AppTheme.primaryColor.withOpacity(0.2),
                                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                                      overlayShape: RoundSliderOverlayShape(overlayRadius: 24),
                                    ),
                                    child: Slider(
                                      value: selectedLevel.toDouble(),
                                      min: 1,
                                      max: 5,
                                      divisions: 4,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedLevel = value.toInt();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      
                      // Badges selector with modern design
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                              child: Text(
                                "Vos badges",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.getColor(
                                  context,
                                  Colors.white.withOpacity(0.9),
                                  AppTheme.darkCardColor.withOpacity(0.7),
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 15,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 12,
                                children: availableBadges.map((badge) {
                                  final isSelected = selectedBadges.contains(badge);
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          selectedBadges.remove(badge);
                                        } else {
                                          selectedBadges.add(badge);
                                        }
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: isSelected
                                            ? LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  AppTheme.primaryColor,
                                                  AppTheme.accentColor,
                                                ],
                                              )
                                            : null,
                                        color: isSelected
                                            ? null
                                            : AppTheme.getColor(
                                                context,
                                                Colors.grey.shade200,
                                                Colors.grey.shade800,
                                              ),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 4),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Text(
                                        badge,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : AppTheme.getColor(
                                                  context,
                                                  AppTheme.textSecondary,
                                                  AppTheme.darkTextSecondary,
                                                ),
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      // Signup button
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppTheme.accentColor,
                                AppTheme.primaryColor,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (usernameController.text.trim().isEmpty ||
                                        emailController.text.trim().isEmpty ||
                                        passwordController.text.isEmpty ||
                                        confirmPasswordController.text.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Veuillez remplir tous les champs requis'),
                                          backgroundColor: AppTheme.errorColor,
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    
                                    if (passwordController.text != confirmPasswordController.text) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Les mots de passe ne correspondent pas'),
                                          backgroundColor: AppTheme.errorColor,
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    
                                    context.read<AuthBloc>().add(
                                          SignupRequested(
                                            usernameController.text,
                                            emailController.text,
                                            passwordController.text,
                                            avatarController.text,
                                            bioController.text,
                                            selectedLevel,
                                            selectedBadges,
                                          ),
                                        );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              disabledBackgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: isLoading
                                ? SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Créer mon compte",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.getColor(
          context,
          Colors.white.withOpacity(0.9),
          AppTheme.darkCardColor.withOpacity(0.7),
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && (isPassword == true && !isPasswordVisible && icon == Icons.lock_outline || 
                    isPassword == true && !isConfirmPasswordVisible && hintText == "Confirmer le mot de passe"),
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 16,
          color: AppTheme.getColor(context, AppTheme.textPrimary, AppTheme.darkTextPrimary),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppTheme.getColor(
              context,
              AppTheme.textSecondary.withOpacity(0.7),
              AppTheme.darkTextSecondary.withOpacity(0.7),
            ),
          ),
          prefixIcon: Icon(
            icon,
            color: AppTheme.primaryColor.withOpacity(0.7),
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }
}