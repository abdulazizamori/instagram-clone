import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instaclone/logic/posts-cubit/posts_cubit.dart';
import 'package:instaclone/main.dart';
import '../../widgets/explorer-screen-widgets/gridview-posts-explorer-widget.dart';
import '../../widgets/explorer-screen-widgets/search-widget.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  @override
  void initState(){
    super.initState();
    context.read<PostsCubit>().fetchAllPosts();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          children: [
            CustomSearchBar(onTap: () {
              Navigator.pushNamed(context, 'searchUserScreen');
            },),
            SizedBox(height: 5,),
            Expanded(child: ExplorerGridViewWidget()),
          ],
        ),
      ),
    ));
  }

}
