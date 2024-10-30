import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/authCubit/auth_cubit.dart';

class CustomDetailsAppBar extends StatefulWidget {
  const CustomDetailsAppBar({super.key});

  @override
  State<CustomDetailsAppBar> createState() => _CustomDetailsAppBarState();
}

class _CustomDetailsAppBarState extends State<CustomDetailsAppBar> {
  @override
  void initState() {
    super.initState();
    // Fetch user info when the screen loads
    context.read<AuthCubit>().fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();

          return state is UserInfoLoaded
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      state.userInfo.userName.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        //     ? Colors.black
                        //     : Colors.white
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(70)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                        ),
                        child: Text(
                          '10+',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'createPost');
                        },
                        icon: Image.asset(
                          'assets/icons/profile-add.png',
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                        )),
                    IconButton(
                        onPressed: () {
                          modalBottomSheetMenu();
                        },
                        icon: Image.asset(
                          'assets/icons/more.png',
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                        )),
                  ],
                )
              : SizedBox();
        },
        listener: (context, state) {});
  }

void modalBottomSheetMenu() {
  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
            height: 50.h,
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
            child: new Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
              child: GestureDetector(
                onTap: (){
                  Navigator.pushReplacementNamed(context, 'login');
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      Text('Log out')
                    ],
                  ),
                ),
              ),
            )));
      });
}
}
