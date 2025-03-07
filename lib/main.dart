import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'setup_locator.dart';
import 'modules/auth/presentation/bloc/auth_bloc.dart';
import 'modules/auth/presentation/pages/login_page.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(), // Fournir AuthBloc à toute l'application
      child: MaterialApp(
        title: 'Auth App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginForm(),
      ),
    );
  }
}
