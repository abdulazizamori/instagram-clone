import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instaclone/main.dart';

class StoriesWidget extends StatefulWidget {
  const StoriesWidget({super.key});

  @override
  State<StoriesWidget> createState() =>
      _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86.h,
      width: MediaQuery.of(context).size.width.w,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, // Ensures the container is circular
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
                      Positioned(
                        bottom: 12,
                        right: 1,
                        child: Container(
                          width: 20.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: Icon(Icons.add,color: Colors.white,),

                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Text('text here')
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 8,
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
          ],
        ),
      ),
    );
  }
}
