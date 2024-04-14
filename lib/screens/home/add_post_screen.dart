import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:yabyab_app/controller/user_provider.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/general_home_screen.dart';
import 'package:yabyab_app/screens/general_widgets/bottom.dart';

class AddPostScreen extends StatefulWidget {
  static const String routeName = 'AddPostScreen';

  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? pickedImage;

  void selectImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    var selectedImage = File(image!.path);
    setState(() {
      pickedImage = selectedImage;
    });
  }

  TextEditingController decsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      decsController.clear();
      pickedImage == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    void uploadPost() async {
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
      final id = Uuid().v4();
      final saveImage = FirebaseStorage.instance
          .ref()
          .child('usersPostImage')
          .child(id + 'jpg');
      await saveImage.putFile(pickedImage!);
      final imageUrl = await saveImage.getDownloadURL();
      try {
        FirebaseFirestore.instance.collection('userPosts').doc(id).set({
          'userName': provider.usersData!.userName,
          'desc': decsController.text,
          'userProfileImage': provider.usersData!.userProfileImage,
          'userPost': imageUrl,
          'userId': provider.usersData!.uid,
          'postId': id,
          'likes': [],
          'date': Timestamp.now()
        });
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: Text(
                'Post added successfully',
                style: AppTextStyle.styleRegularBlack16,
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * .08,
                child: CustomButton(
                  color: AppColors.darkGreenColor,
                  text: "Let's see",
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, GeneralHomeScreen.routeName);
                  },
                ),
              ),
            );
          },
        );
      } on FirebaseException catch (e) {
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            onPressed: () {
              setState(() {
                pickedImage == null;
                decsController.clear();
              });
              Navigator.pushNamed(context, GeneralHomeScreen.routeName);
            },
            icon: const Icon(
              Iconsax.close_circle,
              color: AppColors.darkGreenColor,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'New post',
          style: AppTextStyle.styleRegularGreen30.copyWith(fontSize: 20),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 15.0, top: 15),
              child: InkWell(
                onTap: () {
                  uploadPost();
                },
                child: Text(
                  'Send',
                  style:
                      AppTextStyle.styleRegularGreen30.copyWith(fontSize: 20),
                ),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: decsController,
              cursorColor: AppColors.blackColor,
              decoration: InputDecoration(
                suffixIcon: const Icon(
                  Iconsax.note,
                  color: AppColors.greyColor,
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.blackColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.blackColor)),
                labelText: 'Add new Description',
                labelStyle: const TextStyle(
                    color: AppColors.darkGreenColor, fontSize: 17),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            pickedImage == null
                ? Container(
                    height: MediaQuery.of(context).size.height * .4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: AppColors.darkGreenColor, width: 2)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Are you want to upload photo ? ',
                          style: AppTextStyle.styleRegularBlack16,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * .7,
                            child: CustomButton(
                              text: 'Upload photo',
                              color: AppColors.darkGreenColor,
                              onTap: () {
                                selectImage();
                              },
                            ))
                      ],
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * .4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.file(
                      pickedImage!,
                      fit: BoxFit.contain,
                      height: MediaQuery.of(context).size.height * .4,
                      width: MediaQuery.of(context).size.width,
                    )),
          ],
        ),
      ),
    );
  }
}
