import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPostsListview extends StatefulWidget {
  const CustomPostsListview({super.key});

  @override
  State<CustomPostsListview> createState() => _CustomPostsListviewState();
}

class _CustomPostsListviewState extends State<CustomPostsListview> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 40,),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 12, bottom: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 36.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // Ensures the container is circular
                            border: Border.all(color: Colors.grey, width: 2),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [Text('Ruffles'), Text('Sponsored')],
                        ),
                        Spacer(),
                        Icon(Icons.more_horiz)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    height: 390.h,
                    width: 390.w,
                    child: Image.asset(
                      'assets/images/dog.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0,right: 12,top: 12,bottom: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 40,
                        ),
                        SizedBox(width: 10.w,),
                        Container(
                          width: 20.w,
                          height: 20.h,
                          child: Image.asset(
                            'assets/icons/comment.png',
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(width: 10.w,),
                        Container(
                          width: 20.w,
                          height: 20.h,
                          child: Image.asset(
                            'assets/icons/send.png',
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 20.w,
                          height: 20.h,
                          child: Image.asset(
                            'assets/icons/save.png',
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fit: BoxFit.fill,
                          ),
                        )


                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18,left: 18,top: 10,bottom: 10),
                    child: Row(
                      children: [
                        Text('100',style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(width: 5.w,),
                        Text('Likes',style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18,left: 18,top: 10,bottom: 10),
                    child: Row(
                      children: [
                        Text('Username',style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(width: 5.w,),
                        Text('lorem jdasu mdaudab asdabda sdad dsadaw3gbvc')
                      ],
                    ),
                  )

                ],
              ),
            ),
          );
        });
  }
}
