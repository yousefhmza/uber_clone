import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rider_app/core/auth_provider/auth_provider.dart';
import 'package:rider_app/core/geo_provider/geo_provider.dart';
import 'package:rider_app/helper/bloc_observer.dart';
import 'package:rider_app/view/screens/auth/registration_screen.dart';
import 'package:rider_app/view/screens/auth/login_screen.dart';
import 'package:rider_app/view/screens/auth/splash_screen.dart';
import 'package:rider_app/view/screens/home_screen.dart';
import 'package:rider_app/view/screens/search_destnation_screen.dart';
import 'package:rider_app/view/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthProvider(),
        ),
        BlocProvider(
          create: (_) => GeoProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393.0, 760.0),
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            } else {
              if (snapShot.hasData) {
                return HomeScreen();
              } else {
                return LoginScreen();
              }
            }
          },
        ),
        routes: {
          LoginScreen.screenId: (context) => LoginScreen(),
          RegistrationScreen.screenId: (context) => RegistrationScreen(),
          HomeScreen.screenId: (context) => HomeScreen(),
          SearchDestinationScreen.screenId: (context) =>
              SearchDestinationScreen(),
        },
      ),
    );
  }
}
