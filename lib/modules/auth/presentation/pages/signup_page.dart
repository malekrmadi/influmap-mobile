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

  final List<String> availableBadges = [
    "Débutant", "Intermédiaire", "Expert", "Master", "Légendaire"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un compte")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Nom d'utilisateur"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Mot de passe"),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: "Confirmer le mot de passe"),
              obscureText: true,
            ),
            TextField(
              controller: avatarController,
              decoration: InputDecoration(labelText: "URL de l'avatar"),
            ),
            TextField(
              controller: bioController,
              decoration: InputDecoration(labelText: "Bio"),
              maxLines: 2,
            ),
            
            // Sélection du niveau
            DropdownButtonFormField<int>(
              value: selectedLevel,
              decoration: InputDecoration(labelText: "Niveau"),
              items: List.generate(5, (index) => index + 1)
                  .map((level) => DropdownMenuItem(
                        value: level,
                        child: Text("Niveau $level"),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedLevel = value!;
                });
              },
            ),

            // Sélection des badges
            Wrap(
              spacing: 8.0,
              children: availableBadges.map((badge) {
                final isSelected = selectedBadges.contains(badge);
                return ChoiceChip(
                  label: Text(badge),
                  selected: isSelected,
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

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Les mots de passe ne correspondent pas")),
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
              child: Text("S'inscrire"),
            ),

            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
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
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
