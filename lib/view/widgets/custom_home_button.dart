import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rider_app/helper/constants.dart';

class CustomHomeButton extends StatelessWidget {
  final double topMargin;
  final IconData icon;
  final Function() onTap;

  const CustomHomeButton({
    Key? key,
    required this.topMargin,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16.0.w,
      top: topMargin,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12.0.w),
          decoration: const BoxDecoration(
            color: canvasColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 28.0.sp,
          ),
        ),
      ),
    );
  }
}
