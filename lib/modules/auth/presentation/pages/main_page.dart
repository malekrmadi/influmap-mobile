import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/core/theme/app_theme.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth/modules/auth/presentation/bloc/auth_event.dart';
import 'dashboard_page.dart';
import 'feed_page.dart';
import 'map_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isDarkMode = false;
  late TabController _tabController;

  final List<Widget> _pages = [
    const DashboardPage(),
    const FeedPage(),
    const MapPage(),
  ];

  final List<String> _titles = ['Dashboard', 'Feed', 'Map'];
  final List<IconData> _icons = [Icons.dashboard, Icons.feed, Icons.map];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          title: Text(_titles[_selectedIndex]),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: _toggleTheme,
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: List.generate(3, (index) {
              return Tab(
                icon: Icon(_icons[index]),
                text: _titles[index],
              );
            }),
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _pages,
        ),
      ),
    );
  }
} 