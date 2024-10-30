import 'package:flutter/material.dart';
import 'package:instaclone/presentations/screens/explorer-screen/explorer-screen.dart';
import 'package:instaclone/presentations/screens/explorer-screen/search-users-screen.dart';
import 'package:instaclone/presentations/screens/home-screen/home-screen.dart';
import 'package:instaclone/presentations/screens/profile-screen/addpost.dart';
import 'package:instaclone/presentations/screens/profile-screen/profile-screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> pages = [
    HomeScreen(),
    ExplorerScreen(),
    CreatePostScreen(),
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
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(currentPage == 0 ?Icons.home:Icons.home_outlined , size: 28),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.search_outlined, size: 28),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.add)),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(currentPage==3?Icons.person: Icons.person_outline, size: 28),
          ),
        ],
      ),
    );
  }
}

