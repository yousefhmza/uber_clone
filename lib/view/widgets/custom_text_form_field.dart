import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rider_app/helper/constants.dart';
import 'package:rider_app/view/widgets/custom_text.dart';

class CustomTextFormField extends StatelessWidget {
  final bool obscureText;
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final TextInputType? keyboardType;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: primaryColor,
      style: TextStyle(
        color: Colors.black,
        fontSize: 14.0.sp,
        fontFamily: "Bolt_regular",
      ),
      decoration: InputDecoration(
        label: CustomText(
          text: labelText,
          fontSize: 18.0.sp,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14.0.sp,
          fontFamily: "Bolt_regular",
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
