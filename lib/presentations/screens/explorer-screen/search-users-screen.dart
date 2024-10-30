import 'package:flutter/material.dart';
import 'package:instaclone/presentations/widgets/explorer-widgets/search-widget.dart';

import '../../../main-screen.dart';
import '../../widgets/explorer-widgets/listview-of-users-widget.dart';
import '../../widgets/explorer-widgets/search-bar-field-widget.dart';

class SearchUsersScreen extends StatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          children: [
            SearchFieldWidget(),
            SizedBox(height: 5,),
            Divider(),
            Expanded(child: CustomListViewOfUsersWidget())

          ],
        ),
      ),
    ));
  }
}