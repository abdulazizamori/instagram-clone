import 'package:flutter/material.dart';
import 'package:instaclone/data/models/posts-model.dart';
import '../../widgets/detailed-screen-widgets/detailed-app-bar-widget.dart';
import '../../widgets/explorer-widgets/detailed-explore-listview-widget.dart';

class DetailedExploreScreen extends StatelessWidget {
  final List<PostModel> postModel;
  final int initIndex;
  DetailedExploreScreen({super.key, required this.postModel, required this.initIndex});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              CustomDetailedAppBar(title: 'Explore',),
              Divider(),
              DetailedExploreListView(postModel: postModel, initIndex: initIndex,),

            ],
          ),
        ));
  }
}
