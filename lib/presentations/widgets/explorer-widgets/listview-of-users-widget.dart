import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';
import 'package:instaclone/main.dart';

class CustomListViewOfUsersWidget extends StatefulWidget {
  const CustomListViewOfUsersWidget({super.key});

  @override
  _CustomListViewOfUsersWidgetState createState() => _CustomListViewOfUsersWidgetState();
}

class _CustomListViewOfUsersWidgetState extends State<CustomListViewOfUsersWidget> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is FetchUsersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is FetchUsersLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FetchUsersSuccess) {
          final users = state.users;
          return SizedBox(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      child: ListTile(
                        leading: Container(
                          height: 50.h,
                          width: 50.w,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            users[index].profilePicture.toString(),
                            fit: BoxFit.fill,
                          ),
                        ),
                        title: Text(users[index].userName ?? ''),
                        subtitle: Text(users[index].name ?? ''),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        if (state is FetchUsersError) {
          return Center(
            child: Text(
              'Error loading users. Please try again.',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        return Container();
      },
    );
  }
}
