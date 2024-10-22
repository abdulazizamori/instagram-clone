import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/main.dart';

class CustomListViewHighLights extends StatefulWidget {
  const CustomListViewHighLights({super.key});

  @override
  State<CustomListViewHighLights> createState() =>
      _CustomListViewHighLightsState();
}

class _CustomListViewHighLightsState extends State<CustomListViewHighLights> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86.h,
      width: MediaQuery.of(context).size.width.w,
      child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {},
                child: Column(
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Ensures the container is circular
                          border: Border.all(
                              color: Colors.grey,
                              width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              // Clips the image in a circular shape
                              child: Image.asset(
                                'assets/images/dog.png',
                                fit: BoxFit
                                    .fill, // Ensures the image covers the circular container
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Text('text here')
                    ],
                  ),
                ),

            );
          }),
    );
  }
}
