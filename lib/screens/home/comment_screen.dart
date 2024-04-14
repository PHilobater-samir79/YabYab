import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yabyab_app/controller/user_provider.dart';
import 'package:yabyab_app/core/remote_data/firestore.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/general_home_screen.dart';

class CommentScreen extends StatefulWidget {
  static const String routeName = 'CommentScreen';

  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    var userPosts =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            onPressed: () {
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
          'Comment',
          style: AppTextStyle.styleRegularGreen30.copyWith(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("userPosts")
                  .doc(userPosts['postId'])
                  .collection("comments")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: AppColors.darkGreenColor,
                      ),
                    ),
                  );
                }
                if (snapshot.data == null) {
                  return const Center(
                      child: Text(
                    'No comments yet',
                    style: AppTextStyle.styleRegularBlack20,
                  ));
                }
                if (snapshot.hasError) {
                  return const Text('wa have error');
                }
                if (snapshot.hasData) {
                  return Expanded(
                      child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> commentsMap =
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                      return ListTile(
                          title: Text(
                            commentsMap['userName'],
                            style: AppTextStyle.styleRegularGreen16
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          subtitle: Text(
                            commentsMap['comment'],
                            maxLines: 1,
                            style: AppTextStyle.styleRegularBlack16
                                .copyWith(fontSize: 18),
                          ),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                NetworkImage(commentsMap['userImage']),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              FirestoreMethods().addLikeOnComment(
                                  userId: commentsMap['userId'],
                                  commentMap: commentsMap,
                                  commentId: commentsMap['commentId'],
                                  postId: userPosts['postId']);
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width*.15,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Iconsax.heart,
                                      color: commentsMap['commentLikes'].contains(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          ? Colors.red
                                          : Colors.black),
                                  Text(
                                    '${commentsMap['commentLikes'].length} Likes',
                                    style: AppTextStyle.styleRegularBlack16,
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  ));
                }
                return const Text('');
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage:
                      NetworkImage(provider.usersData!.userProfileImage),
                ),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .78,
                  child: TextField(
                    cursorColor: AppColors.darkGreenColor,
                    controller: commentController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Iconsax.send1,
                          size: 35,
                          color: AppColors.darkGreenColor,
                        ),
                        onPressed: () {
                          if (commentController.text != "") {
                            FirestoreMethods().addComment(
                                userName: provider.usersData!.userName,
                                comment: commentController.text,
                                userImage: provider.usersData!.userProfileImage,
                                postId: userPosts['postId'],
                                userId: provider.usersData!.uid);
                            commentController.clear();
                          }
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: AppColors.darkGreenColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: AppColors.darkGreenColor)),
                      hintText: 'Write your comment ',
                      hintStyle: const TextStyle(
                          color: AppColors.darkGreenColor, fontSize: 17),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
