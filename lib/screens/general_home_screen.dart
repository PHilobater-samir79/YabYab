import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/chat/chat_screen.dart';
import 'package:yabyab_app/screens/home/home_screen.dart';
import 'package:yabyab_app/screens/profile/profile_screen.dart';
import 'package:yabyab_app/screens/search/search_screen.dart';

class GeneralHomeScreen extends StatefulWidget {
  const GeneralHomeScreen({super.key});
  static const String routeName = 'GeneralHomeScreen';

  @override
  State<GeneralHomeScreen> createState() => _GeneralHomeScreenState();
}

class _GeneralHomeScreenState extends State<GeneralHomeScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          tabs[selectedIndex],
          Positioned(
            bottom: 1,
            right: 10,
            left: 10,
            child: Container(
              margin: const EdgeInsets.all(20),
              height: size.width * .15,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.15),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
                borderRadius: BorderRadius.circular(50),
              ),
              child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(right: 5, left: 8),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    setState(
                      () {
                        selectedIndex = index;
                      },
                    );
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: size.width * .03),
                      Icon(
                        listOfIcons[index],
                        size: size.width * .076,
                        color: index == selectedIndex
                            ? AppColors.darkGreenColor
                            : AppColors.blackColor,
                      ),
                      RotatedBox(
                        quarterTurns: 2,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 1500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          margin: EdgeInsets.only(
                            bottom:
                                index == selectedIndex ? 0 : size.width * .029,
                            right: size.width * .0422,
                            left: size.width * .0422,
                          ),
                          width: size.width * .120,
                          height:
                              index == selectedIndex ? size.width * .014 : 0,
                          decoration: const BoxDecoration(
                            color: AppColors.darkGreenColor,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> tabs = [
    const HomeScreen(),
    const ChatScreen(),
    SearchScreen(),
    ProfileScreen(
      userId: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  List<IconData> listOfIcons = [
    Iconsax.home,
    Iconsax.message,
    Iconsax.search_normal,
    Iconsax.user,
  ];
}
