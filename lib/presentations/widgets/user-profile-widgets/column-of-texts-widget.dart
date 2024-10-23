import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';

class CustomColumnOfText extends StatefulWidget {
  const CustomColumnOfText({super.key});

  @override
  State<CustomColumnOfText> createState() => _CustomColumnOfTextState();
}

class _CustomColumnOfTextState extends State<CustomColumnOfText> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().fetchUserInfo(); // Fetch user info on init
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is UserInfoLoaded) {
          final userinfo = state.userInfo;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userinfo.name ?? ''),
              SizedBox(height: 5,),
              Text(userinfo.userName ?? ''),
              SizedBox(height: 5,),
              Text(userinfo.bio ?? '', maxLines: 3),
            ],
          );
        } else if (state is UserInfoLoading) {
          return Center(child: CircularProgressIndicator()); // Show loading indicator
        } else if (state is UserInfoLoadError) {
          return Center(child: Text('Error loading user information.')); // Display error message
        } else {
          return Center(child: Text('No user information available.')); // Default message
        }
      },
      listener: (context, state) {
      },
    );
  }
}
