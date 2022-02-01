import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rider_app/core/auth_provider/auth_provider.dart';
import 'package:rider_app/core/auth_provider/auth_states.dart';
import 'package:rider_app/helper/constants.dart';
import 'package:rider_app/view/screens/auth/login_screen.dart';
import 'package:rider_app/view/widgets/custom_text.dart';
import 'package:rider_app/view/widgets/custom_text_form_field.dart';

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  static const String screenId = "/RegistrationScreen";
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("rebuilt registration screen");
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
      child: BlocConsumer<AuthProvider, AuthStates>(
        listener: (context, authState) {},
        builder: (context, authState) {
          AuthProvider authProvider = BlocProvider.of<AuthProvider>(context);
          return Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(_focusNode);
              },
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0.w),
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage("assets/images/logo.png"),
                          height: 200.0.h,
                          width: 200.0.w,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20.0.h),
                        CustomText(
                          text: "Register as a rider",
                          fontSize: 24.0.sp,
                          fontFamily: "Bolt_semibold",
                          alignment: Alignment.center,
                        ),
                        SizedBox(height: 20.0.h),
                        CustomTextFormField(
                          controller: nameController,
                          labelText: "Name",
                          hintText: "Enter your name",
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 4) {
                              return "Name must be 4 characters at least";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 20.0.h),
                        CustomTextFormField(
                          controller: emailController,
                          labelText: "E-Mail",
                          hintText: "Enter your email address",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains(".com") ||
                                !value.contains("@")) {
                              return "Please enter a valid Email address";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 20.0.h),
                        CustomTextFormField(
                          controller: phoneController,
                          labelText: "Phone",
                          hintText: "Enter your phone number",
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length != 11) {
                              return "Please enter a valid phone number";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 20.0.h),
                        CustomTextFormField(
                          controller: passwordController,
                          labelText: "Password",
                          hintText: "Enter your password",
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 6) {
                              return "Please enter a password with minimum of 6 characters";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 40.0.h),
                        authState is AuthLoadingState
                            ? const CircularProgressIndicator()
                            : MaterialButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    authProvider.register(
                                      context,
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      phone: phoneController.text.trim(),
                                      password: passwordController.text.trim(),
                                    );
                                  }
                                },
                                elevation: 0.0,
                                color: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0.w),
                                  child: CustomText(
                                    text: "Create Account",
                                    fontSize: 20.0.sp,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                        SizedBox(height: 40.0.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Already have an account?",
                              fontSize: 16.0.sp,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  LoginScreen.screenId,
                                  (route) => false,
                                );
                              },
                              child: CustomText(
                                text: "Login",
                                fontSize: 18.0.sp,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
