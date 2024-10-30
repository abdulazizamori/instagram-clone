import 'package:flutter/material.dart';
import 'package:instaclone/presentations/widgets/explorer-widgets/search-widget.dart';

import '../../widgets/explorer-widgets/gridview-posts-explorer-widget.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
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
