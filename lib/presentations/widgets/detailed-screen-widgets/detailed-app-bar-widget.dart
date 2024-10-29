import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instaclone/data/models/user-model.dart';

import '../../../data/models/posts-model.dart';
import '../../../logic/authCubit/auth_cubit.dart';

class CustomDetailedAppBar extends StatefulWidget {

   CustomDetailedAppBar({super.key});

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
                    state is UserInfoLoaded
                    ?Text(state.userInfo.userName.toString(),style: TextStyle(fontWeight: FontWeight.w800,color:Colors.grey,fontSize:16 ,letterSpacing: 1),):SizedBox(),
                    Text('Posts',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
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
