// lib/features/home/view/home_view.dart
import 'package:flutter/material.dart';
import 'package:veto/features/account/account.dart';
import 'package:veto/features/news/news.dart';
import 'package:veto/features/settings/settings.dart';
import 'package:veto/features/vote/vote.dart';
// If you create a nested widget folder or a distinct dashboard feature, import it here:
// import 'package:veto/features/dashboard/dashboard.dart'; 

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  // Cache the views so they are not re-instantiated on build passes
  late final List<Widget> _tabs = [
    const Center(child: Text('Dashboard Content')), // TODO(Aaron): Swap with a dedicated DashboardPage()
    const VotePage(),
    const NewsPage(),
    const AccountPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.how_to_vote), label: 'Vote'),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
