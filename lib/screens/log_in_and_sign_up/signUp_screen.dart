import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:yabyab_app/core/models/chat_user_model.dart';
import 'package:yabyab_app/core/models/user_model.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/app_assets.dart';
import 'package:yabyab_app/core/utils/app_strings.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/general_home_screen.dart';
import 'package:yabyab_app/screens/general_widgets/bottom.dart';
import 'package:yabyab_app/screens/log_in_and_sign_up/logIn_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = 'SignUpScreen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool obscurePassword = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  File? pickedImage;

  void selectImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    var selectedImage = File(image!.path);
    setState(() {
      pickedImage = selectedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * .1,
              ),
              Center(
                  child: Text(
                AppStrings.welcomeDearGuest,
                style: AppTextStyle.styleRegularBlack20.copyWith(fontSize: 25),
                textAlign: TextAlign.center,
              )),
              SizedBox(
                height: height * .02,
              ),
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    pickedImage == null
                        ? CircleAvatar(
                            radius: 60,
                            child: Image.asset(AppAssets.unKnowPerson),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(pickedImage!),
                          ),
                    Positioned(
                      bottom: 0,
                      right: -3,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.darkGreenColor,
                        child: IconButton(
                            onPressed: () {
                              selectImage();
                            },
                            icon: const Icon(
                              Iconsax.gallery,
                              color: AppColors.blackColor,
                            )),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * .03,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please write your name';
                          }
                          return null;
                        },
                        cursorColor: AppColors.blackColor,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.person,
                            color: AppColors.greyColor,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppColors.blackColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppColors.blackColor)),
                          labelText: AppStrings.name,
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
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please Enter your Email ';
                          }
                          var emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
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
                              borderSide: const BorderSide(
                                  color: AppColors.blackColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppColors.blackColor)),
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
                              borderSide: const BorderSide(
                                  color: AppColors.blackColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppColors.blackColor)),
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
              SizedBox(
                height: height * .03,
              ),
              CustomButton(
                text: AppStrings.signUp,
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
                    AppStrings.haveAcc,
                    style: AppTextStyle.styleRegularBlack16,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, LogInScreen.routeName);
                    },
                    child: Text(
                      AppStrings.logInNow,
                      style: AppTextStyle.styleRegularBlack16
                          .copyWith(color: AppColors.darkGreenColor),
                    ),
                  )
                ],
              )
            ],
          ),
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
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passController.text);

        final imageId = Uuid().v4();
        final saveImage = FirebaseStorage.instance
            .ref()
            .child('usersProfileImages')
            .child(imageId + 'jpg');
        await saveImage.putFile(pickedImage!);
        final imageUrl = await saveImage.getDownloadURL();

        UsersModel usersModel = UsersModel(
            password: passController.text,
            email: emailController.text,
            userName: nameController.text,
            userProfileImage: imageUrl,
            uid: FirebaseAuth.instance.currentUser!.uid,
            followers: [],
            stories: [],
            following: []);

        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(usersModel.convertToMap());

        ChatUserModel chatUserModel = ChatUserModel(
            createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
            password: passController.text,
            email: emailController.text,
            userName: nameController.text,
            userProfileImage: imageUrl,
            uid: FirebaseAuth.instance.currentUser!.uid,
            lastActivated: DateTime.now().millisecondsSinceEpoch.toString(),
            pushToken: '',
            about: 'Hello Iam ${nameController.text}',
            online: true);

        FirebaseFirestore.instance
            .collection('chatUsersDate')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(chatUserModel.toJson());

        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: Text(
                'sign up successfully',
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
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: const Text(
                'Something went wrong',
                style: AppTextStyle.styleRegularBlack16,
                textAlign: TextAlign.center,
              ),
              content: const Text(
                'Please Enter new email and password again',
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
                      nameController.clear();
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
}
