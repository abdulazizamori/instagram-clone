import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'posts-gridview-widget.dart'; // Ensure this import is correct

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.transparent, // Optional styling
            child: TabBar(
              unselectedLabelColor: Colors.grey, // Color for unselected icons
              labelColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white, // Color for selected icons
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    width: 3.0,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white), // Custom thickness and color
                insets: EdgeInsets.symmetric(horizontal: 40.0), // Extend or shrink the indicator
              ),
              tabs: [
                Tab(
                  icon: Image.asset(
                    'assets/icons/posts.png',
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                Tab(
                  icon: Image.asset(
                    'assets/icons/reels.png',
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                Tab(
                  icon: Image.asset(
                    'assets/icons/tagged.png',
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded( // Use Expanded here to take the remaining space
            child: TabBarView(
              children: [
                PostsListView(), // Your posts list view widget
                Container(
                  color: Colors.red,
                  child: Icon(Icons.add),
                ),
                Container(
                  color: Colors.red,
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
