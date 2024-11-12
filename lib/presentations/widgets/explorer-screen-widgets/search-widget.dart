import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchBar extends StatelessWidget {
  final void Function() onTap;

  const CustomSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                  SizedBox(width: 10,),
                  Icon(Icons.search_outlined,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black.withOpacity(0.4)
                          : Colors.white.withOpacity(0.5)),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    'Search',
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withOpacity(0.4)
                            : Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
