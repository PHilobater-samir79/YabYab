import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yabyab_app/controller/user_provider.dart';
import 'package:yabyab_app/core/remote_data/firestore.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/app_strings.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/general_widgets/bottom.dart';
import 'package:yabyab_app/screens/home/story_view_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;
  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List following;
  late bool inFollow;
  bool isLoad = false;
  late int postsCount;

  void fetchCurrentUser() async {
    setState(() {
      isLoad = true;
    });
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    var snap = await FirebaseFirestore.instance
        .collection('userPosts')
        .where('userId', isEqualTo: widget.userId)
        .get();
    postsCount = snap.docs.length;
    following = snapshot.data()!['following'];
    setState(() {
      inFollow = following.contains(widget.userId);
      isLoad = false;
    });
  }

  @override
  void initState() {
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.getUserData!.stories.forEach((element) {
      FirestoreMethods().deleteStoryAfter24h(story: element);
    });
    provider.fetchUserData(userId: widget.userId);
    fetchCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: AppColors.whiteColor,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: widget.userId != FirebaseAuth.instance.currentUser!.uid ?
      //       const Text('Profile',style: AppTextStyle.styleRegularGreen16,)
      //       : const SizedBox(),
      //   leading:widget.userId != FirebaseAuth.instance.currentUser!.uid
      //       ? Align(
      //     alignment: Alignment.topLeft,
      //     child: Padding(
      //       padding: const EdgeInsets.only(left: 15.0),
      //       child: IconButton(
      //           onPressed: () {
      //             Navigator.pop(context);
      //           },
      //           icon: const Icon(Icons.arrow_back_ios,color: AppColors.darkGreenColor,)),
      //     ),
      //   )
      //       : const SizedBox(),
      // ),
      body: isLoad == true
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.darkGreenColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * .05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .2,
                        child: GestureDetector(
                          onTap: () {
                            if (provider.usersData!.stories.isEmpty) {
                              return;
                            } else {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return StoryViewScreen(
                                    stories: provider.getUserData!.stories,
                                  );
                                },
                              ));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 2,
                                    color: provider.usersData!.stories.isEmpty
                                        ? Colors.black
                                        : AppColors.darkGreenColor)),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  provider.getUserData!.userProfileImage),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .56,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                const Text(
                                  AppStrings.posts,
                                  style: AppTextStyle.styleRegularBlack16,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  postsCount.toString(),
                                  style: AppTextStyle.styleRegularGreen16,
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                const Text(
                                  AppStrings.follower,
                                  style: AppTextStyle.styleRegularBlack16,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${provider.usersData!.followers.length}',
                                  style: AppTextStyle.styleRegularGreen16,
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                const Text(
                                  AppStrings.following,
                                  style: AppTextStyle.styleRegularBlack16,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${provider.usersData!.following.length}',
                                  style: AppTextStyle.styleRegularGreen16,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    provider.usersData!.userName,
                    style: AppTextStyle.styleRegularBlack16,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  widget.userId == FirebaseAuth.instance.currentUser!.uid
                      ? CustomButton(
                          text: AppStrings.editProfile,
                          color: Colors.transparent,
                          onTap: () {},
                        )
                      : CustomButton(
                          text: inFollow == true ? 'Unfollow' : 'Follow',
                          color: inFollow == true
                              ? Colors.transparent
                              : AppColors.darkGreenColor,
                          onTap: () {
                            if (inFollow == true) {
                              setState(() {
                                inFollow = false;
                                provider.decreaseFollowers();
                              });
                              FirestoreMethods()
                                  .unFollowUsers(userId: widget.userId);
                            } else {
                              setState(() {
                                inFollow = true;
                                provider.increaseFollowers();
                              });
                              FirestoreMethods()
                                  .followUsers(userId: widget.userId);
                            }
                          },
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  // .orderBy('date',descending:true)
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('userPosts')
                        .where('userId', isEqualTo: widget.userId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: AppColors.darkGreenColor,
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'We have error please try again later',
                            style: AppTextStyle.styleRegularGreen16,
                          ),
                        );
                      }
                      if (snapshot.data == null) {
                        return const Center(
                          child: Text(
                            'Go home now and upload some photo\nto share with yous friends',
                            style: AppTextStyle.styleRegularGreen16,
                          ),
                        );
                      }
                      return Expanded(
                        child: GridView.builder(
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 1,
                            childAspectRatio: 3.5 / 3,
                          ),
                          itemBuilder: (context, index) {
                            return Image.network(
                              snapshot.data!.docs[index]['userPost'],
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 90,
                  ),
                ],
              ),
            ),
    );
  }
}
