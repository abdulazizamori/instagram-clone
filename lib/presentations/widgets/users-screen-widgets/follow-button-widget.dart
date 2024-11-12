import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/core/theme/app_colors.dart';
import 'package:instaclone/main.dart';

class FollowButtonWidget extends StatefulWidget {
  final String targetUserId;
  final bool isFollowing;
  final VoidCallback onFollow;
  final VoidCallback onUnfollow;

  const FollowButtonWidget({
    Key? key,
    required this.targetUserId,
    required this.isFollowing,
    required this.onFollow,
    required this.onUnfollow,
  }) : super(key: key);

  @override
  State<FollowButtonWidget> createState() => _FollowButtonWidgetState();
}

class _FollowButtonWidgetState extends State<FollowButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (widget.isFollowing) {
              widget.onUnfollow(); // Call unfollow when already following
            } else {
              widget.onFollow(); // Call follow when not following
            }
          });
        },
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width
              .w,
          height: 30.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: widget.isFollowing ? Theme
                .of(context)
                .brightness == Brightness.light
                ? Colors.grey.withOpacity(0.2)
                : Colors.grey.withOpacity(0.5) : AppColors.buttonBlue,
          ),
          child: Center(
            child: Text(
              widget.isFollowing ? 'Following' : 'Follow',
              style: TextStyle(color: widget.isFollowing ? Theme
                  .of(context)
                  .brightness == Brightness.light
                  ? Colors.black
                  : Colors.white : Colors.white,
                  fontWeight: FontWeight.w700, fontSize: 13.sp),
            ),
          ),
        ),
      ),
    );
  }
}
