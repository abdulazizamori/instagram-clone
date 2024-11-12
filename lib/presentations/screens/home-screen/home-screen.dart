import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/main.dart';

import '../../widgets/home-screen-widgets/app-bar-widget.dart';
import '../../widgets/home-screen-widgets/posts-listview-widget.dart';
import '../../widgets/home-screen-widgets/stories-widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
              child: Column(
                children: [
                  CustomHomeScreenAppBar(),
                  SizedBox(height: 30.h,),
                  StoriesWidget(),
                ],
              ),
            ),
            Divider(thickness: 2,),
             Column(
                children: [
                  CustomPostsListview(),
                ],
            )
          ],
        ),
      ),
    ));
  }
}
