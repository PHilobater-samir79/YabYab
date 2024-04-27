import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/app_strings.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/general_home_screen.dart';
import 'package:yabyab_app/screens/general_widgets/bottom.dart';
import 'package:yabyab_app/screens/log_in_and_sign_up/signUp_screen.dart';

class LogInScreen extends StatefulWidget {
  static const String routeName = 'LogInScreen';

  LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();
  bool obscurePassword = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController forgetPassController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    forgetPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * .15,
            ),
            Center(
                child: Text(
              AppStrings.welcomeBack,
              style: AppTextStyle.styleRegularBlack20.copyWith(fontSize: 25),
              textAlign: TextAlign.center,
            )),
            SizedBox(
              height: height * .05,
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please Enter your Email ';
                        }
                        var emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!emailValid) {
                          return 'Please enter your real email address';
                        }
                        return null;
                      },
                      cursorColor: AppColors.blackColor,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Iconsax.personalcard,
                          color: AppColors.greyColor,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: AppColors.blackColor)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: AppColors.blackColor)),
                        labelText: AppStrings.emailAddress,
                        labelStyle: const TextStyle(
                            color: AppColors.darkGreenColor, fontSize: 17),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passController,
                      validator: (value) {
                        if (value!.length < 8) {
                          return 'Password must be longer than 8 characters';
                        }
                        return null;
                      },
                      obscureText: obscurePassword,
                      cursorColor: AppColors.blackColor,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: obscurePassword == true
                              ? const Icon(
                                  Iconsax.eye_slash,
                                  color: AppColors.greyColor,
                                )
                              : const Icon(
                                  Iconsax.eye,
                                  color: AppColors.greyColor,
                                ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: AppColors.blackColor)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: AppColors.blackColor)),
                        labelText: AppStrings.password,
                        labelStyle: const TextStyle(
                            color: AppColors.darkGreenColor, fontSize: 17),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )),
            Row(
              children: [
                const Spacer(),
                TextButton(
                    onPressed: () {
                      showForgetPassword();
                    },
                    child: const Text(
                      AppStrings.forgetPassword,
                      style: AppTextStyle.styleRegularBlack16,
                    )),
              ],
            ),
            SizedBox(
              height: height * .02,
            ),
            CustomButton(
              text: AppStrings.logIn,
              color: AppColors.darkGreenColor,
              onTap: () {
                formKey.currentState!.save();
                validator();
              },
            ),
            SizedBox(
              height: height * .03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  AppStrings.doNotHaveAcc,
                  style: AppTextStyle.styleRegularBlack16,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, SignUpScreen.routeName);
                  },
                  child: Text(
                    AppStrings.signUpNow,
                    style: AppTextStyle.styleRegularBlack16
                        .copyWith(color: AppColors.darkGreenColor),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }

  void validator() async {
    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Loading....',
                  style: AppTextStyle.styleRegularBlack16,
                  textAlign: TextAlign.center,
                ),
                CircularProgressIndicator(
                  color: AppColors.darkGreenColor,
                )
              ],
            ),
          );
        },
      );

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passController.text);
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: Text(
                'Log in successfully',
                style: AppTextStyle.styleRegularBlack16,
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * .08,
                child: CustomButton(
                  color: AppColors.darkGreenColor,
                  text: "Let's start",
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, GeneralHomeScreen.routeName);
                  },
                ),
              ),
            );
          },
        );
      } on FirebaseAuthException catch (e) {
        print(e.toString());
        Navigator.pop(context);
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
              content: const Text(
                'Please Enter your email and password again',
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
                      emailController.clear();
                      passController.clear();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void showForgetPassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * .3,
            decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0, left: 15, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.forgetPassword,
                    style: AppTextStyle.styleRegularBlack20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: forgetPassController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please Enter your Email ';
                      }
                      var emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (!emailValid) {
                        return 'Please enter your real email address';
                      }
                      return null;
                    },
                    cursorColor: AppColors.blackColor,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Iconsax.personalcard,
                        color: AppColors.greyColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.blackColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.blackColor)),
                      labelText: 'Please Enter Your Email',
                      labelStyle: const TextStyle(
                          color: AppColors.darkGreenColor, fontSize: 17),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: CustomButton(
                    text: 'Send Email verification ',
                    color: AppColors.darkGreenColor,
                    onTap: () {
                      forgetPassFirebase();
                      Navigator.pop(context);
                    },
                  ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future forgetPassFirebase() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: forgetPassController.text);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              'Please check your email',
              style: AppTextStyle.styleRegularBlack16,
              textAlign: TextAlign.center,
            ),
            content: const Text(
              'We sent you email to reset password',
              style: AppTextStyle.styleRegularBlack16,
              textAlign: TextAlign.center,
            ),
            actions: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .08,
                child: CustomButton(
                  color: AppColors.darkGreenColor,
                  text: "Okay",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              'Something went wrong',
              style: AppTextStyle.styleRegularBlack16,
              textAlign: TextAlign.center,
            ),
            content: Text(
              e.message.toString(),
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
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
