import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';
import 'package:yabyab_app/controller/user_provider.dart';
import 'package:yabyab_app/core/remote_data/firestore.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/general_home_screen.dart';
import 'package:yabyab_app/screens/general_widgets/bottom.dart';

class StoryViewScreen extends StatefulWidget {
  final List stories;
  const StoryViewScreen({super.key, required this.stories});

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  Map detailsStory = {};
  final StoryController storyController = StoryController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          StoryView(
              storyItems: widget.stories.map((story) {
                detailsStory = story;
                if (story['type'] == 'image') {
                  return StoryItem.pageImage(
                      url: story['content'], controller: storyController);
                }
                if (story['type'] == 'video') {
                  return StoryItem.pageVideo(story['content'],
                      controller: storyController);
                }
              }).toList(),
              repeat: false,
              onComplete: () {
                Navigator.pop(context);
              },
              controller: storyController),
          Positioned(
            top: 60,
            left: 10,
            right: 10,
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage("${detailsStory['userImage']}"),
              ),
              title: Text(
                "${detailsStory['userName']}",
                style: AppTextStyle.styleRegularGreen16
                    .copyWith(fontWeight: FontWeight.w400, fontSize: 18,color: AppColors.whiteColor),
              ),
              trailing: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          title: const Text(
                            'Are you want to delete story ?',
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
                                  if (detailsStory['userId'] == FirebaseAuth.instance.currentUser!.uid) {
                                    FirestoreMethods()
                                        .deleteStory(story: detailsStory);
                                    provider.deleteStoryFromProvider(
                                        story: detailsStory);
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return const GeneralHomeScreen();
                                      },
                                    ));
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: detailsStory['userId'] == FirebaseAuth.instance.currentUser!.uid ? const Icon(
                    Iconsax.menu,
                    color: AppColors.whiteColor,
                  ):const SizedBox(),
            )),
          )
        ],
      ),
    );
  }
}
