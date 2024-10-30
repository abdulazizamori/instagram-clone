import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/data/models/user-model.dart';
import 'package:instaclone/main.dart';

import '../../../data/models/posts-model.dart';
import '../../../logic/authCubit/auth_cubit.dart';

class CustomDetailedAppBar extends StatefulWidget {
  final String title;

   CustomDetailedAppBar({super.key, required this.title});

  @override
  State<CustomDetailedAppBar> createState() => _CustomDetailedAppBarState();
}

class _CustomDetailedAppBarState extends State<CustomDetailedAppBar> {
  @override
  void initState(){
    super.initState();
    // Fetch user info when the screen loads
    context.read<AuthCubit>().fetchUserInfo();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthState>(builder: (context,state){
      return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_rounded)),
              Spacer(),
                 Column(
                  children: [
                    Text(widget.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp),)
                  ],
                ),
              Spacer(),
            ],
          ),
        ),
      );

    }, listener: (context,state){});
  }
}
