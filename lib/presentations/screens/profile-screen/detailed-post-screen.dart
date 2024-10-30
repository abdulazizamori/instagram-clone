import 'package:flutter/material.dart';
import 'package:instaclone/data/models/posts-model.dart';
import '../../widgets/detailed-screen-widgets/detailed-app-bar-widget.dart';
import '../../widgets/detailed-screen-widgets/detailed-listview-widget.dart';

class DetailedPostScreen extends StatelessWidget {
  final List<PostModel> postModel;
  final int initIndex;
   DetailedPostScreen({super.key, required this.postModel, required this.initIndex});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          CustomDetailedAppBar(title: 'Posts',),
          Divider(),
          DetailedListView(postModel: postModel, initIndex: initIndex,),

        ],
      ),
    ));
  }
}
