import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorizedAnimatedText extends StatelessWidget {
  ColorizedAnimatedText({Key? key}) : super(key: key);

  final colorizeColors = [
    Colors.yellow,
    Colors.blue,
    Colors.yellowAccent,
    Colors.red,
  ];

  final colorizeTextStyle = TextStyle(
    fontSize: 50.0.sp,
    fontFamily: 'Signatra',
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AnimatedTextKit(
        animatedTexts: [
          ColorizeAnimatedText(
            "Requesting a ride...",
            textStyle: colorizeTextStyle,
            colors: colorizeColors,
            textAlign: TextAlign.center,
          ),
          ColorizeAnimatedText(
            "Please wait...",
            textStyle: colorizeTextStyle,
            colors: colorizeColors,
            textAlign: TextAlign.center,
          ),
          ColorizeAnimatedText(
            "Finding a driver...",
            textStyle: colorizeTextStyle,
            colors: colorizeColors,
            textAlign: TextAlign.center,
          ),
        ],
        isRepeatingAnimation: true,
      ),
    );
  }
}
