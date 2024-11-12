import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final String textButton;
  final void Function()? onpressed;

  const CustomTextButton(
      {super.key,
      required this.text,
      required this.onpressed,
      required this.textButton});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$text',
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white),
        ),
        SizedBox(width: 5,),
        GestureDetector(
            onTap: onpressed,
            child: Text(
              '$textButton',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ))
      ],
    );
  }
}
