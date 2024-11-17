import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/main.dart';
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
    ProfileScreen(),
  ];
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
            icon: Image.asset(
              currentPage == 0
                  ? 'assets/icons/homescreen.png'
                  : 'assets/icons/home-not.png',
              width: 22.w,
              height: 22.h,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(Icons.search_outlined, size: 28),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Image.asset(
              currentPage == 2
                  ? 'assets/icons/add-nav.png'
                  : 'assets/icons/add-not.png',
              width: 24.w,
              height: 24.h,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Image.asset(
              'assets/icons/reels.png',
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Image.asset(
              currentPage == 4
                  ? 'assets/icons/profile-nav.png'
                  : 'assets/icons/profile-not1.png',
              width: 24.w,
              height: 24.h,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
