import 'package:challenge_one_project/screens/matches.dart';
import 'package:challenge_one_project/screens/overview.dart';
import 'package:challenge_one_project/screens/settings.dart';
import 'package:challenge_one_project/screens/teams.dart';
import 'package:challenge_one_project/screens/training.dart';
import 'package:challenge_one_project/screens/users.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 1;

  final List<Widget> screens = [
    const OverviewScreen(),
    const UsersScreen(),
    const TeamsScreen(),
    const TrainingScreen(),
    const MatchesScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            indicatorColor: Colors.transparent,
            backgroundColor: const Color(0xFF6A1B9A),
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            
            labelType: NavigationRailLabelType.all,
            leading: const Icon(Icons.menu),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined, color: Colors.black, size: 30),
                selectedIcon: Icon(Icons.home_outlined, color: Colors.white, size: 30),
                label: Text('Overzicht'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.account_circle_outlined, color: Colors.black, size: 30),
                selectedIcon: Icon(Icons.account_circle_outlined, color: Colors.white, size: 30),
                label: Text('Gebruikers'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.group, color: Colors.black, size: 30,),
                selectedIcon: Icon(Icons.group, color: Colors.white, size: 30),
                label: Text('Teams'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.fitness_center, color: Colors.black, size: 30),
                selectedIcon: Icon(Icons.fitness_center, color: Colors.white, size: 30),
                label: Text('Trainings'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.games_outlined, color: Colors.black, size: 30),
                selectedIcon: Icon(Icons.games_outlined, color: Colors.white, size: 30),
                label: Text('Wedstrijden'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings, color: Colors.black, size: 30),
                selectedIcon: Icon(Icons.settings, color: Colors.white, size: 30),
                label: Text('Settings'),
              ),
            ],
          ),
          Expanded(
            child: screens[selectedIndex],
          ),
        ],
      ),
    );
  }
}