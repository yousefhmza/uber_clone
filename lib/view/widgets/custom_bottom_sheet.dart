import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomBottomSheet extends StatelessWidget {
  final List<Widget> children;

  const CustomBottomSheet({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Custom Bottom Shaeete build");
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Container(
        height: 325.0.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0.r),
            topRight: Radius.circular(16.0.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 16.0.r,
              spreadRadius: 6.0,
              offset: Offset(0.0, 0.7.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: SingleChildScrollView(
            child: Column(
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
