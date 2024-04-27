import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/app_assets.dart';
import 'package:yabyab_app/core/utils/app_strings.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/general_home_screen.dart';
import 'package:yabyab_app/screens/general_widgets/bottom.dart';
import 'package:yabyab_app/screens/log_in_and_sign_up/logIn_screen.dart';
import 'package:yabyab_app/screens/log_in_and_sign_up/signUp_screen.dart';

class GeneralEnterApp extends StatelessWidget {
  const GeneralEnterApp({super.key});
  static const String routeName = 'GeneralEnterApp';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: AppColors.darkGreenColor,
              );
            }
            if (snapshot.hasError) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    title: Text(
                      'Something went wrong',
                      style: AppTextStyle.styleRegularBlack16,
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .08,
                        child: CustomButton(
                          color: AppColors.darkGreenColor,
                          text: "Try again",
                          onTap: () {
                            Navigator.pushNamed(
                                context, GeneralEnterApp.routeName);
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            if (snapshot.data == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.appIcon,
                    height: 60,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.appNameShort,
                        style: AppTextStyle.styleRegularBlack30,
                      ),
                      Text(
                        AppStrings.appNameShort,
                        style: AppTextStyle.styleRegularGreen30,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    color: AppColors.darkGreenColor,
                    text: AppStrings.logIn,
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, LogInScreen.routeName);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    color: Colors.transparent,
                    text: AppStrings.signUp,
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, SignUpScreen.routeName);
                    },
                  ),
                ],
              );
            }
            if (snapshot.hasData) {
              return const GeneralHomeScreen();
            }
            return const Text('Wrong');
          },
        ),
      ),
    );
  }
}
