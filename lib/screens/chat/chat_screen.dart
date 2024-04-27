import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yabyab_app/core/models/chat_room_model.dart';
import 'package:yabyab_app/core/remote_data/firebase_database.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/app_assets.dart';
import 'package:yabyab_app/core/utils/app_strings.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/chat/widgets/my_chats.dart';
import 'package:yabyab_app/screens/general_widgets/bottom.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  final emailController = TextEditingController();
  final groupNameController = TextEditingController();
  List<String> members = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'C',
                style: AppTextStyle.styleRegularBlack30,
              ),
              Text(
                'h',
                style: AppTextStyle.styleRegularGreen30,
              ),
              Text(
                'a',
                style: AppTextStyle.styleRegularBlack30,
              ),
              Text(
                't',
                style: AppTextStyle.styleRegularGreen30,
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Iconsax.search_normal,
                  color: AppColors.blackColor,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        title: const Text(
                          'Are you want to create chat ?',
                          style: AppTextStyle.styleRegularBlack16,
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .08,
                            width: MediaQuery.of(context).size.width * .35,
                            child: CustomButton(
                              color: AppColors.darkGreenColor,
                              text: "Chat",
                              onTap: () {
                                Navigator.pop(context);
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .3,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20,
                                            top: 20,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Enter friend Email',
                                                    style: AppTextStyle
                                                        .styleRegularBlack20,
                                                  ),
                                                  CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: AppColors
                                                          .darkGreenColor,
                                                      child: Icon(
                                                        Icons
                                                            .qr_code_scanner_outlined,
                                                        color: AppColors
                                                            .blackColor,
                                                      )),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              TextFormField(
                                                controller: emailController,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return 'Please Enter Membare Email ';
                                                  }
                                                  var emailValid = RegExp(
                                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                      .hasMatch(value);
                                                  if (!emailValid) {
                                                    return 'Please enter member real email address';
                                                  }
                                                  return null;
                                                },
                                                cursorColor:
                                                    AppColors.blackColor,
                                                decoration: InputDecoration(
                                                  suffixIcon: const Icon(
                                                    Iconsax.personalcard,
                                                    color: AppColors.greyColor,
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: AppColors
                                                                  .blackColor)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: AppColors
                                                                  .blackColor)),
                                                  labelText:
                                                      AppStrings.emailAddress,
                                                  labelStyle: const TextStyle(
                                                      color: AppColors
                                                          .darkGreenColor,
                                                      fontSize: 17),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              CustomButton(
                                                text: 'Create Room',
                                                color: AppColors.darkGreenColor,
                                                onTap: () {
                                                  if (emailController
                                                      .text.isNotEmpty) {
                                                    FirebaseDatabase()
                                                        .creatRoom(
                                                            emailController
                                                                .text)
                                                        .then((value) {
                                                      setState(() {
                                                        emailController.clear();
                                                        Navigator.pop(context);
                                                      });
                                                    });
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .08,
                            width: MediaQuery.of(context).size.width * .35,
                            child: CustomButton(
                              color: AppColors.darkGreenColor,
                              text: "Group",
                              onTap: () {
                                Navigator.pop(context);
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .9,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20,
                                            top: 20,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  // pickedImage == null
                                                  // ?
                                                  CircleAvatar(
                                                    radius: 50,
                                                    child: Image.asset(
                                                        AppAssets.unKnowPerson),
                                                  ),
                                                  // :
                                                  // CircleAvatar(
                                                  //     radius: 60,
                                                  //     backgroundImage: FileImage(pickedImage!),
                                                  //   ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: -5,
                                                    child: CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: AppColors
                                                          .darkGreenColor,
                                                      child: IconButton(
                                                          onPressed: () {
                                                            // selectImage();
                                                          },
                                                          icon: const Icon(
                                                            Iconsax.gallery,
                                                            color: AppColors
                                                                .blackColor,
                                                          )),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              TextFormField(
                                                controller: groupNameController,
                                                cursorColor:
                                                    AppColors.blackColor,
                                                decoration: InputDecoration(
                                                  suffixIcon: const Icon(
                                                    Icons.group_add,
                                                    color: AppColors.greyColor,
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: AppColors
                                                                  .blackColor)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: AppColors
                                                                  .blackColor)),
                                                  labelText: 'Group name',
                                                  labelStyle: const TextStyle(
                                                      color: AppColors
                                                          .darkGreenColor,
                                                      fontSize: 17),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                        color: AppColors
                                                            .greyColor)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    children: [
                                                      const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Members',
                                                            style: AppTextStyle
                                                                .styleRegularBlack16,
                                                          ),
                                                          Text(
                                                            '0',
                                                            style: AppTextStyle
                                                                .styleRegularGreen16,
                                                          )
                                                        ],
                                                      ),
                                                      const Divider(
                                                        color:
                                                            AppColors.greyColor,
                                                      ),
                                                      SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .13,
                                                          child:
                                                              ListView.builder(
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return RadioListTile(
                                                                  value: 1,
                                                                  groupValue: 1,
                                                                  title: Text(
                                                                    'Philosophers',
                                                                  ),
                                                                  activeColor:
                                                                      AppColors
                                                                          .darkGreenColor,
                                                                  onChanged:
                                                                      (value) {});
                                                            },
                                                            itemCount: 10,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              members.isEmpty
                                                  ? const SizedBox()
                                                  : CustomButton(
                                                      text: 'Create Group',
                                                      color: AppColors
                                                          .darkGreenColor,
                                                      onTap: () {
                                                        if (groupNameController
                                                            .text.isNotEmpty) {
                                                          FirebaseDatabase()
                                                              .creatGroupRoom(
                                                                  groupNameController
                                                                      .text,
                                                                  members)
                                                              .then((value) {
                                                            setState(() {
                                                              groupNameController
                                                                  .clear();
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          });
                                                        }
                                                      },
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Iconsax.menu,
                  color: AppColors.blackColor,
                )),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TabBar(
                  unselectedLabelColor: AppColors.blackColor,
                  labelColor: AppColors.blackColor,
                  indicatorColor: AppColors.darkGreenColor,
                  isScrollable: true,
                  tabs: const [
                    Tab(
                      child: Text(
                        AppStrings.myChats,
                        style: AppTextStyle.styleRegularBlack16,
                      ),
                    ),
                    Tab(
                      child: Text(
                        AppStrings.myGroups,
                        style: AppTextStyle.styleRegularBlack16,
                      ),
                    ),
                  ],
                  controller: tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('rooms')
                              .where('members',
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
                            if (!snapshot.hasData || snapshot.data == null) {
                              return const Expanded(
                                  child: Center(child: Text('we have error')));
                            }

                            List<ChatRooomModel> items = snapshot.data!.docs
                                .map((e) => ChatRooomModel.fromJson(e.data()))
                                .toList()
                              ..sort(
                                (a, b) => b.lastMessageTime!
                                    .compareTo(a.lastMessageTime!),
                              );

                            return Center(
                              child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return MyChats(items: items[index]);
                                },
                              ),
                            );
                          }),
                      Center(
                          child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: const Text(
                              'Philobater samir',
                              style: AppTextStyle.styleRegularBlack16,
                            ),
                            leading: const CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage(AppAssets.unKnowPerson),
                            ),
                            trailing: const Text(
                              '12:55 PM',
                              style: AppTextStyle.styleRegularGreen16,
                            ),
                            subtitle: Text(
                              'How are you',
                              style: AppTextStyle.styleRegularGrey20
                                  .copyWith(fontSize: 15),
                            ),
                          );
                        },
                      )),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
