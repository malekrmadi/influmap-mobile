import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/core/theme/app_theme.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_event.dart';
import 'dashboard_page.dart';
import 'feed_page.dart';
import 'map_page.dart';
import 'my_profile_page.dart';
import 'notifications_page.dart';
import 'explore_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  final List<Widget> _pages = [
    const FeedPage(),
    const ExplorePage(),
    const MapPage(),
    const NotificationsPage(),
    const MyProfilePage(),
  ];

  final List<String> _titles = ['Feed', 'Explore', 'Map', 'Notifications', 'My Profile'];
  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.explore_rounded,
    Icons.map_rounded,
    Icons.notifications_rounded,
    Icons.person_rounded,
  ];

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _logout() {
    context.read<AuthBloc>().add(LogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.getThemeData(_isDarkMode),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_selectedIndex],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
              onPressed: _toggleTheme,
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: _logout,
            ),
          ],
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: List.generate(_icons.length, (index) {
              return BottomNavigationBarItem(
                icon: Icon(_icons[index]),
                label: _titles[index],
              );
            }),
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppTheme.getColor(context, Colors.white, Colors.grey.shade900),
            elevation: 8,
          ),
        ),
      ),
    );
  }
} 