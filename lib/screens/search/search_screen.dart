import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/app_strings.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/profile/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                onChanged: (value){
                  setState(() {

                  });
                },
                controller: searchController,
                cursorColor: AppColors.darkGreenColor,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Iconsax.search_normal,
                    color: AppColors.darkGreenColor,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColors.darkGreenColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColors.blackColor)),
                  hintText: AppStrings.search,
                  hintStyle: const TextStyle(
                      color: AppColors.darkGreenColor, fontSize: 17),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('userName', isEqualTo: searchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                      child: const Center(
                          child: CircularProgressIndicator(
                        color: AppColors.darkGreenColor,
                      )),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text(
                      'We have error please try again later',
                      style: AppTextStyle.styleRegularGreen16,
                    );
                  }
                  return Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ProfileScreen(
                                    userId: snapshot.data!.docs[index]['uid'],
                                  );
                                },
                              ));
                            },
                            title: Text(
                              snapshot.data!.docs[index]['userName'],
                              style: AppTextStyle.styleRegularBlack16,
                            ),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(snapshot
                                  .data!.docs[index]['userProfileImage']),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10),
                            child: Divider(
                              height: 1,
                              color: AppColors.greyColor,
                              thickness: .5,
                            ),
                          );
                        },
                        itemCount: snapshot.data!.docs.length),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
