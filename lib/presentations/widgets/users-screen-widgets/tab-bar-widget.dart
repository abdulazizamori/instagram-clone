import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/presentations/widgets/users-screen-widgets/posts-gridview-widget.dart';

class CustomUserTabBarWidget extends StatefulWidget {
  final String userId;
  const CustomUserTabBarWidget({super.key, required this.userId});

  @override
  State<CustomUserTabBarWidget> createState() => _CustomUserTabBarWidgetState();
}

class _CustomUserTabBarWidgetState extends State<CustomUserTabBarWidget> {
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
                insets: EdgeInsets.symmetric(
                    horizontal: 40.0), // Extend or shrink the indicator
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
          Expanded(
            // Use Expanded here to take the remaining space
            child: TabBarView(
              children: [
                UserPostsGridView(userId: widget.userId,),
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
