import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12)),
              height: 25.h,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (query) {
                    context.read<AuthCubit>().searchUsers(query);
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_outlined,
                          color: Theme.of(context).brightness ==
                              Brightness.light
                              ? Colors.black.withOpacity(0.4)
                              : Colors.white.withOpacity(0.5)),
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Theme.of(context).brightness ==
                            Brightness.light
                            ? Colors.black.withOpacity(0.4)
                            : Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ))
        ],
      ),
    );
  }
}
