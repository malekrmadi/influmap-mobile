import 'package:auth/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_page.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau de bord"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Déclencher l'événement de déconnexion
              context.read<AuthBloc>().add(LogoutRequested());
              
              // Retourner à la page de connexion
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<AuthBloc>(),
                    child: LoginForm(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bienvenue sur votre tableau de bord",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Icon(
              Icons.verified_user,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              "Vous êtes maintenant connecté",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
