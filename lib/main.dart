import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'setup_locator.dart'; // Ensure this is your GetIt setup
import 'modules/auth/presentation/bloc/auth_bloc.dart'; // AuthBloc
import 'modules/auth/presentation/pages/login_page.dart'; // LoginPage

void main() {
  // Initialize GetIt (dependency injection setup)
  setupLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => sl<AuthBloc>(), // Use GetIt to fetch the AuthBloc
        child: LoginForm(), // Your login form
      ),
    );
  }
}
