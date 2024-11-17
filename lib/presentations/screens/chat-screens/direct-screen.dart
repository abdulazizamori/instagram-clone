import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/logic/chat-cubit/chat_cubit.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';
import 'package:instaclone/data/models/message-model.dart';
import '../../widgets/direct-screen-widgets/app-bar-widget.dart';
import '../../widgets/direct-screen-widgets/listview-users-widget.dart';
import '../../widgets/explorer-screen-widgets/search-widget.dart';
import 'chat-screen.dart';

class DirectScreen extends StatefulWidget {
  @override
  State<DirectScreen> createState() => _DirectScreenState();
}

class _DirectScreenState extends State<DirectScreen> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Padding(
                padding: const EdgeInsets.only(top: 40.0,left: 12,right: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DirectAppBarWidget(),
                    SizedBox(height: 10.h,),
                    CustomSearchBar(onTap: () {
                      Navigator.pushNamed(context, 'searchUserScreen');
                    },),
                    Expanded(
                      child: Container(
                          child: ListOfUsersWidget()),
                    )
                  ],
                ),
              )

      );
  }
}
