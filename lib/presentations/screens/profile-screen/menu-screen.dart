import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';
import 'package:instaclone/presentations/screens/profile-screen/saved-screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthState>(builder: (context,state){
      return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                'Settings and activity',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white.withOpacity(0.5)
                    : Colors.white.withOpacity(0.1),),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.grey.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12)),
                      width: MediaQuery.of(context).size.width,
                      height: 30.h,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.search_outlined,
                                color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black.withOpacity(0.4)
                                    : Colors.white.withOpacity(0.5)),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              'Search',
                              style: TextStyle(
                                  color:
                                  Theme.of(context).brightness == Brightness.light
                                      ? Colors.black.withOpacity(0.4)
                                      : Colors.white.withOpacity(0.5),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      Text(
                        'How you use Instagram',
                        style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white.withOpacity(0.4),
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp),
                      ),
                      Spacer(),
                      Image.asset(
                        'assets/icons/meta.png',
                        width: 15.w,
                        height: 15.h,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white.withOpacity(0.4),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        'Meta',
                        style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SavedScreen()));
                  },
                  child: ListTile(
                    leading: Image.asset(
                      'assets/icons/save.png',
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white.withOpacity(0.6),
                      width: 15.w,
                      height: 15.h,
                    ),
                    title: Text(
                      'Saved',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white.withOpacity(0.6)),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
                Divider(
                  thickness: 5,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white.withOpacity(0.5)
                      : Colors.white.withOpacity(0.1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    'Your app and media',
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white.withOpacity(0.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: ListTile(
                    leading: Icon(
                      Icons.language_outlined,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white.withOpacity(0.6),
                    ),
                    title: Text(
                      'Language',
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white.withOpacity(0.6)),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
                Divider(
                  thickness: 5,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.white.withOpacity(0.5)
                      : Colors.white.withOpacity(0.1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white.withOpacity(0.4),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                  child: Text(
                    'Add account',
                    style: TextStyle(
                        color: Colors.blueAccent.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: GestureDetector(
                    onTap: (){
                      context.read<AuthCubit>().signOut();
                    },
                    child: Text(
                      'Log out',
                      style: TextStyle(
                          color: Colors.red.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp),
                    ),
                  ),
                ),




              ],
            ),
          ));


    }, listener: (context,state){
      if(state is SignOut){
        Navigator.pushReplacementNamed(context, 'login');
      }
    });
  }
}
