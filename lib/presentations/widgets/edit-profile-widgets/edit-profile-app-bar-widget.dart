import 'package:flutter/material.dart';

class CustomEditProfileAppBar extends StatelessWidget {
  final void Function()? onTap;
  const CustomEditProfileAppBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(onTap: () {
          Navigator.pop(context);
        }, child: Text('Cancel')),
        Text('Edit Profile',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
        GestureDetector(
            onTap: onTap,
            child: Text(
              'Done',
              style: TextStyle(color: Colors.blue),
            )),
      ],
    );
  }
}
