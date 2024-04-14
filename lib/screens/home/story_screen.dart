import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:yabyab_app/controller/user_provider.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/general_home_screen.dart';
import 'package:yabyab_app/screens/general_widgets/bottom.dart';
import 'package:yabyab_app/screens/profile/profile_screen.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  File? pickedImage;
  File? pickedVideo;
  late VideoPlayerController videoPlayerController;

  void selectImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    var selectedImage = File(image!.path);
    setState(() {
      pickedImage = selectedImage;
      pickedVideo = null;
      videoPlayerController.pause();
    });
  }

  void selectVideo() async {
    var video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    var selectedVideo = File(video!.path);
    setState(() {
      pickedVideo = selectedVideo;
      pickedImage = null;
      videoPlayerController = VideoPlayerController.file(pickedVideo!);
      videoPlayerController.initialize();
      videoPlayerController.play();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      pickedImage == null;
      pickedVideo == null;
    });
    videoPlayerController = VideoPlayerController.file(File(''));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
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
                pickedVideo == null;
              });
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return const GeneralHomeScreen();
                },
              ));
            },
            icon: const Icon(
              Iconsax.close_circle,
              color: AppColors.darkGreenColor,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'New story',
          style: AppTextStyle.styleRegularGreen30.copyWith(fontSize: 20),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 15.0, top: 15),
              child: InkWell(
                onTap: () async {
                  if (pickedImage != null || pickedVideo != null) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
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
                    String userId = FirebaseAuth.instance.currentUser!.uid;
                    String storyId = const Uuid().v4();
                    var media = pickedVideo ?? pickedImage;
                    final saveStory = FirebaseStorage.instance
                        .ref()
                        .child('userStories')
                        .child(storyId + 'jpg');
                    await saveStory.putFile(media!);
                    final content = await saveStory.getDownloadURL();
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .update({
                      'stories': FieldValue.arrayUnion([
                        {
                          'userId': userId,
                          'storyId': storyId,
                          'content': content,
                          'type': pickedVideo != null ? 'video' : 'image',
                          'date': Timestamp.now(),
                          'userImage':provider.usersData!.userProfileImage,
                          'userName':provider.usersData!.userName,
                          'views': []
                        }
                      ]),
                    });
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          title: const Text(
                            "Let's see your story",
                            style: AppTextStyle.styleRegularBlack16,
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                color: AppColors.darkGreenColor,
                                text: "Okay",
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const GeneralHomeScreen();
                                    },
                                  ));
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    setState(() {
                      pickedImage = null;
                      pickedVideo = null;
                    });
                    provider.fetchUserData(userId: userId);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          title: const Text(
                            'Please Add Something',
                            style: AppTextStyle.styleRegularBlack16,
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            SizedBox(
                              width: double.infinity,
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
                  }
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
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                        height: MediaQuery.of(context).size.height * .5,
                        width: MediaQuery.of(context).size.width,
                      )),
              const SizedBox(
                height: 20,
              ),
              pickedVideo == null
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
                            'Are you want to upload video ? ',
                            style: AppTextStyle.styleRegularBlack16,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .7,
                              child: CustomButton(
                                text: 'Upload video',
                                color: AppColors.darkGreenColor,
                                onTap: () {
                                  selectVideo();
                                },
                              ))
                        ],
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * .5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: VideoPlayer(videoPlayerController),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
