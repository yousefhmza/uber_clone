import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final String fontFamily;
  final Color color;
  final AlignmentGeometry alignment;

  const CustomText({
    Key? key,
    required this.text,
    required this.fontSize,
    this.fontFamily = "Bolt_regular",
    this.color = Colors.black,
    this.alignment = AlignmentDirectional.topStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: fontFamily,
          color: color,
        ),
      ),
    );
  }
}
