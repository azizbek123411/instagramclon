
import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  double h;
  double w;
  double r;
  Color color;
  String title;
  void Function() onTap;

   Buttons({
    super.key,
    required this.color,
    required this.h,
    required this.w,
    required this.title,
    required this.r,
     required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(r),
          color: color,
        ),
        child: Center(
          child: Text(title,style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
        ),
      ),
    );
  }
}
