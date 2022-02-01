import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rider_app/helper/constants.dart';

AppBarTheme _appBarTheme = AppBarTheme(
  elevation: 0.0,
  titleTextStyle: TextStyle(
    fontSize: 18.0.sp,
    fontFamily: "Bolt_semibold",
  ),
  systemOverlayStyle: const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ),
);

ProgressIndicatorThemeData _progressIndicatorThemeData =
    const ProgressIndicatorThemeData(
  color: primaryColor,
);

ThemeData lightTheme() {
  return ThemeData(
    appBarTheme: _appBarTheme,
    fontFamily: "Bolt_regular",
    canvasColor: canvasColor,
    progressIndicatorTheme: _progressIndicatorThemeData,
    scaffoldBackgroundColor: canvasColor,
  );
}
