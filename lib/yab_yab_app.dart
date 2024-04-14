import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yabyab_app/controller/user_provider.dart';
import 'package:yabyab_app/screens/general_home_screen.dart';
import 'package:yabyab_app/screens/home/add_post_screen.dart';
import 'package:yabyab_app/screens/home/comment_screen.dart';
import 'package:yabyab_app/screens/initial_pages/on_boarding_screen.dart';
import 'package:yabyab_app/screens/initial_pages/splash_screen.dart';
import 'package:yabyab_app/screens/log_in_and_sign_up/general_enter_app.dart';
import 'package:yabyab_app/screens/log_in_and_sign_up/logIn_screen.dart';
import 'package:yabyab_app/screens/log_in_and_sign_up/signUp_screen.dart';

class YabYabApp extends StatelessWidget {
  const YabYabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return UserProvider();
          },
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
          OnBoardingScreen.routeName: (context) => const OnBoardingScreen(),
          GeneralHomeScreen.routeName: (context) => const GeneralHomeScreen(),
          GeneralEnterApp.routeName: (context) => const GeneralEnterApp(),
          LogInScreen.routeName: (context) => LogInScreen(),
          SignUpScreen.routeName: (context) => const SignUpScreen(),
          AddPostScreen.routeName: (context) => const AddPostScreen(),
          CommentScreen.routeName: (context) =>   CommentScreen(),
        },
      ),
    );
  }
}
