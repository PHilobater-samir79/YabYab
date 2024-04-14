import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:yabyab_app/core/remote_data/firestore.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/general_widgets/bottom.dart';
import 'package:yabyab_app/screens/home/comment_screen.dart';

class CustomPostWidget extends StatefulWidget {
  final Map<String, dynamic> userPostsMap;

  const CustomPostWidget({super.key, required this.userPostsMap});

  @override
  State<CustomPostWidget> createState() => _CustomPostWidgetState();
}

class _CustomPostWidgetState extends State<CustomPostWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage(widget.userPostsMap['userProfileImage']),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userPostsMap['userName'],
                    style: AppTextStyle.styleRegularBlack20
                        .copyWith(fontWeight: FontWeight.w400,fontSize: 18),
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    DateFormat.jm()
                        .format(widget.userPostsMap['date'].toDate()),
                    style:
                        AppTextStyle.styleRegularGreen16.copyWith(fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          title: const Text(
                            'Are you want to delete post ?',
                            style: AppTextStyle.styleRegularBlack16,
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .08,
                              width: MediaQuery.of(context).size.width * .35,
                              child: CustomButton(
                                color: AppColors.darkGreenColor,
                                text: "No",
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .08,
                              width: MediaQuery.of(context).size.width * .35,
                              child: CustomButton(
                                color: AppColors.darkGreenColor,
                                text: "Sure",
                                onTap: () {
                                  FirestoreMethods().deletePostFromPosts(
                                      userPostMap: widget.userPostsMap);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: FirebaseAuth.instance.currentUser!.uid ==
                      widget.userPostsMap['userId']
                      ? const Icon(Iconsax.menu)
                      : const SizedBox(),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            widget.userPostsMap['desc'],
            style: AppTextStyle.styleRegularBlack16,
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(child: Image.network(widget.userPostsMap['userPost'])),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.blackColor),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () async {
                      FirestoreMethods()
                          .addLikeOnPost(userPostMap: widget.userPostsMap);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.heart,
                            color: widget.userPostsMap['likes'].contains(
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? Colors.red
                                : Colors.black),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${widget.userPostsMap['likes'].length} Likes',
                          style: AppTextStyle.styleRegularBlack16,
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, CommentScreen.routeName,
                          arguments: widget.userPostsMap);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Iconsax.message),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'comment',
                          style: AppTextStyle.styleRegularBlack16,
                        )
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
