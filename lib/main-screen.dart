import 'package:flutter/material.dart';
import 'package:instaclone/presentations/screens/home-screen/home-screen.dart';
import 'package:instaclone/presentations/screens/profile-screen/profile-screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> pages = [
    HomeScreen(),
    ProfileScreen(),
  ];
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        currentIndex: currentPage,
        selectedItemColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white,
        unselectedItemColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        showSelectedLabels: false,
        // Hide selected labels
        showUnselectedLabels: false,
        // Hide unselected labels
        items: const [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.home_filled, size: 28),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.person, size: 28),
          ),
        ],
      ),
    );
  }
}
