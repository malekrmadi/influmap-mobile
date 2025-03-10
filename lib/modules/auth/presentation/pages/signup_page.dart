import 'package:auth/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_event.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_page.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
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

  final List<String> availableBadges = [
    "Débutant", "Intermédiaire", "Expert", "Master", "Légendaire"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                backgroundColor: Colors.redAccent,
                margin: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 24),
                  // Back button and title
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Créer un compte",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  // Logo or App icon
                  Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_add_outlined,
                        size: 50,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Welcome text
                  Text(
                    "Rejoignez-nous",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Créez votre profil pour commencer",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  
                  // Form fields
                  // Username
                  buildTextField(
                    controller: usernameController,
                    label: "Nom d'utilisateur",
                    hint: "Entrez votre nom d'utilisateur",
                    icon: Icons.person_outline,
                  ),
                  SizedBox(height: 16),
                  
                  // Email
                  buildTextField(
                    controller: emailController,
                    label: "Email",
                    hint: "Entrez votre email",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  
                  // Password
                  TextFormField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: "Mot de passe",
                      hintText: "Entrez votre mot de passe",
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Confirm Password
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: !isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: "Confirmer le mot de passe",
                      hintText: "Confirmez votre mot de passe",
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible = !isConfirmPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Avatar URL
                  buildTextField(
                    controller: avatarController,
                    label: "URL de l'avatar",
                    hint: "Entrez l'URL de votre avatar",
                    icon: Icons.image_outlined,
                  ),
                  SizedBox(height: 16),
                  
                  // Bio
                  TextFormField(
                    controller: bioController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Bio",
                      hintText: "Parlez-nous de vous",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 45),
                        child: Icon(Icons.article_outlined),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Dropdown for level selection
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButtonFormField<int>(
                        value: selectedLevel,
                        decoration: InputDecoration(
                          labelText: "Niveau",
                          prefixIcon: Icon(Icons.trending_up_outlined),
                          border: InputBorder.none,
                        ),
                        icon: Icon(Icons.arrow_drop_down_circle_outlined),
                        elevation: 2,
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        items: List.generate(5, (index) => index + 1)
                            .map((level) => DropdownMenuItem(
                                  value: level,
                                  child: Text(
                                    "Niveau $level",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: level == selectedLevel
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLevel = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Badge selection label
                  Text(
                    "Choisissez vos badges",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Badge selection chips
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: availableBadges.map((badge) {
                      final isSelected = selectedBadges.contains(badge);
                      return ChoiceChip(
                        label: Text(
                          badge,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: Theme.of(context).primaryColor,
                        backgroundColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        elevation: isSelected ? 2 : 0,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedBadges.add(badge);
                            } else {
                              selectedBadges.remove(badge);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 32),
                  
                  // Signup button
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            // Form validation
                            if (usernameController.text.trim().isEmpty ||
                                emailController.text.trim().isEmpty ||
                                passwordController.text.isEmpty ||
                                confirmPasswordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Veuillez remplir tous les champs obligatoires"),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.redAccent,
                                  margin: EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                              return;
                            }
                            
                            if (passwordController.text != confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Les mots de passe ne correspondent pas"),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.redAccent,
                                  margin: EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
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
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                            "S'inscrire",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create consistent text fields
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.all(20),
      ),
    );
  }
}