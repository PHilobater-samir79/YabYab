import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:yabyab_app/controller/user_provider.dart';
import 'package:yabyab_app/core/remote_data/firestore.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/app_strings.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/chat/chat_screen.dart';
import 'package:yabyab_app/screens/general_home_screen.dart';
import 'package:yabyab_app/screens/general_widgets/bottom.dart';
import 'package:yabyab_app/screens/home/add_post_screen.dart';
import 'package:yabyab_app/screens/home/custom_post_widget.dart';
import 'package:yabyab_app/screens/home/story_screen.dart';
import 'package:yabyab_app/screens/home/story_view_screen.dart';
import 'package:yabyab_app/screens/log_in_and_sign_up/general_enter_app.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void downloadUserDate() {
    final provider = Provider.of<UserProvider>(context, listen: false);
    if (provider.usersData?.stories?.isNotEmpty == true) {
      provider.getUserData?.stories?.forEach((element) {
        FirestoreMethods().deleteStoryAfter24h(story: element);
      });
    }
    provider.fetchUserData(userId: FirebaseAuth.instance.currentUser?.uid);
  }

  @override
  void initState() {
    downloadUserDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final provider = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.whiteColor,
          elevation: 0,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AddPostScreen.routeName);
                  },
                  icon: const Icon(
                    Iconsax.additem,
                    color: AppColors.darkGreenColor,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const ChatScreen();
                      },
                    ));
                  },
                  icon: const Icon(
                    Iconsax.message,
                    color: AppColors.darkGreenColor,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const GeneralEnterApp();
                    }));
                  },
                  icon: const Icon(
                    Iconsax.logout,
                    color: AppColors.darkGreenColor,
                  )),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15),
          child: Column(
            children: [
              SizedBox(
                height: height * .12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .19,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return provider.usersData?.stories?.isEmpty ==
                                      true
                                  ? const StoryScreen()
                                  : StoryViewScreen(
                                      stories: provider.getUserData!.stories,
                                    );
                            },
                          ));
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 80,
                              height: height * .1,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: provider.usersData?.stories
                                                  ?.isEmpty ==
                                              true
                                          ? Colors.black
                                          : AppColors.darkGreenColor,
                                      width: 3),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        provider.usersData?.userProfileImage ??
                                            "",
                                      ))),
                            ),
                            Positioned(
                              bottom: 5,
                              right: -5,
                              child: CircleAvatar(
                                  radius: 13,
                                  backgroundColor: AppColors.whiteColor,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return const StoryScreen();
                                        },
                                      ));
                                    },
                                    child: const Icon(
                                      Iconsax.add_circle,
                                      color: AppColors.darkGreenColor,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('stories', isNotEqualTo: [])
                          .where('followers',
                              arrayContains:
                                  FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.darkGreenColor,
                              ),
                            ),
                          );
                        }
                        return Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> storyMap =
                                  snapshot.data!.docs[index].data();
                              FirestoreMethods().deleteStoryAfter24h(
                                  story: storyMap['stories'][index]);
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return StoryViewScreen(
                                            stories: storyMap['stories'],
                                          );
                                        },
                                      ));
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Container(
                                        width: 80,
                                        height: height * .1,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: AppColors.darkGreenColor,
                                                width: 3),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  "${storyMap['userImage']}",
                                                ))),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${storyMap['userName']}',
                                    style: AppTextStyle.styleRegularBlack16
                                        .copyWith(fontSize: 12),
                                  )
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("userPosts")
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.darkGreenColor,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    return Expanded(
                        child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> userPostsMap =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                        return CustomPostWidget(
                          userPostsMap: userPostsMap,
                        );
                      },
                    ));
                  }
                  if (snapshot.hasError) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      title: const Text(
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
                                  context, GeneralHomeScreen.routeName);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Expanded(
                      child: Center(
                          child: Text(
                        'search new friends now ',
                        style: AppTextStyle.styleRegularBlack16,
                      )),
                    );
                  }
                  return const Text('wrong');
                },
              ),
              const SizedBox(
                height: 90,
              )
            ],
          ),
        ),
      ),
    );
  }
}
