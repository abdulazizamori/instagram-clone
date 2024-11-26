import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/saved-screen-widgets/saved-gridview-widget.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'All posts',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 22,
                )),
          ),
      body: Column(
        children: [
          Divider(),
          Expanded(
              child: Container(child: SavedGridView()))

        ],
      ),
    ));
  }
}
