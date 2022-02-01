import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rider_app/helper/constants.dart';
import 'package:rider_app/view/screens/auth/login_screen.dart';
import 'package:rider_app/view/widgets/custom_text.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: canvasColor,
      width: 255.0.w,
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(16.0.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36.0.r,
                    backgroundColor: canvasColor,
                    backgroundImage:
                        const AssetImage("assets/images/user_icon.png"),
                  ),
                  SizedBox(width: 12.0.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Profile Name",
                        fontSize: 16.0.sp,
                      ),
                      SizedBox(height: 8.0.h),
                      CustomText(
                        text: "Visit Profile",
                        fontSize: 14.0.sp,
                        color: Colors.grey,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 12.0.h),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.history,
                size: 24.0.sp,
              ),
              title: CustomText(
                text: "History",
                fontSize: 16.0.sp,
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.person,
                size: 24.0.sp,
              ),
              title: CustomText(
                text: "Visit Profile",
                fontSize: 16.0.sp,
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.info,
                size: 24.0.sp,
              ),
              title: CustomText(
                text: "About",
                fontSize: 16.0.sp,
              ),
            ),
            ListTile(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginScreen.screenId,
                  (route) => false,
                );
              },
              leading: Icon(
                Icons.logout,
                size: 24.0.sp,
              ),
              title: CustomText(
                text: "Logout",
                fontSize: 16.0.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
