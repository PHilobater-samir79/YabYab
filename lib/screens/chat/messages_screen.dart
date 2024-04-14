import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:yabyab_app/core/models/chat_user_model.dart';
import 'package:yabyab_app/core/models/message_model.dart';
import 'package:yabyab_app/core/remote_data/firebase_database.dart';
import 'package:yabyab_app/core/remote_data/firebase_storage.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/chat/chat_screen.dart';
import 'package:yabyab_app/screens/chat/widgets/chat_message_card.dart';

class MessagesScreen extends StatefulWidget {
  final String roomId;
  final ChatUserModel chatUserModel;
  MessagesScreen(
      {super.key, required this.roomId, required this.chatUserModel});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  TextEditingController messageController = TextEditingController();
  List<String> selectedMessages = [];
  List<String> copiedMessages = [];
  @override
  void initState() {
    super.initState();
    selectedMessages.clear();
    copiedMessages.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .09,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.darkGreenColor,
                          AppColors.whiteColor,
                          AppColors.whiteColor,
                          AppColors.whiteColor,
                          AppColors.whiteColor,
                          AppColors.whiteColor,
                          AppColors.whiteColor,
                          AppColors.whiteColor,
                          AppColors.whiteColor,
                          AppColors.whiteColor,
                          AppColors.darkGreenColor,
                        ]),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 7),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return const ChatScreen();
                              },
                            ));
                          },
                          icon: const Icon(Icons.arrow_back_ios)),
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          widget.chatUserModel.userProfileImage,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.chatUserModel.userName,
                            style: AppTextStyle.styleRegularBlack16,
                          ),
                          Text(
                            DateFormat.jm()
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(
                                        widget.chatUserModel.lastActivated)))
                                .toString(),
                            style: AppTextStyle.styleRegularGreen16
                                .copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                      const Spacer(),
                      selectedMessages.isEmpty
                          ? const SizedBox()
                          : Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      FirebaseDatabase().deleteMessages(
                                          widget.roomId, selectedMessages);
                                      setState(() {
                                        selectedMessages.clear();
                                        copiedMessages.clear();
                                      });
                                    },
                                    icon: const Icon(Iconsax.trash)),
                                IconButton(
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text: copiedMessages.join('\n')));
                                      setState(() {
                                        copiedMessages.clear();
                                        selectedMessages.clear();
                                      });
                                    },
                                    icon: const Icon(Iconsax.copy)),
                              ],
                            )
                    ],
                  ),
                ),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('rooms')
                      .doc(widget.roomId)
                      .collection('messages')
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
                    List<MessageModel> messageItems = snapshot.data!.docs
                        .map((e) => MessageModel.fromJson(e.data()))
                        .toList()
                      ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

                    return messageItems.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              reverse: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedMessages.isNotEmpty
                                          ? selectedMessages.contains(
                                                  messageItems[index]
                                                      .messageId!)
                                              ? selectedMessages.remove(
                                                  messageItems[index]
                                                      .messageId!)
                                              : selectedMessages.add(
                                                  messageItems[index]
                                                      .messageId!)
                                          : null;
                                      copiedMessages.isNotEmpty
                                          ? messageItems[index].type == 'text'
                                              ? copiedMessages.contains(
                                                      messageItems[index]
                                                          .messageId!)
                                                  ? copiedMessages.remove(
                                                      messageItems[index]
                                                          .messageId!)
                                                  : copiedMessages.add(
                                                      messageItems[index]
                                                          .messageId!)
                                              : null
                                          : null;
                                    });
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      selectedMessages.contains(
                                              messageItems[index].messageId!)
                                          ? selectedMessages.remove(
                                              messageItems[index].messageId!)
                                          : selectedMessages.add(
                                              messageItems[index].messageId!);
                                      messageItems[index].type == 'text'
                                          ? copiedMessages.contains(
                                                  messageItems[index]
                                                      .messageId!)
                                              ? copiedMessages.remove(
                                                  messageItems[index]
                                                      .messageId!)
                                              : copiedMessages.add(
                                                  messageItems[index]
                                                      .messageId!)
                                          : null;
                                    });
                                  },
                                  child: ChatMessageCard(
                                    isSelected: selectedMessages.contains(
                                        messageItems[index].messageId!),
                                    roomId: widget.roomId,
                                    index: index,
                                    messageModel: messageItems[index],
                                  ),
                                );
                              },
                              itemCount: messageItems.length,
                            ),
                          )
                        : Center(
                            child: InkWell(
                            onTap: () => FirebaseDatabase().sendMessage(
                                widget.chatUserModel.uid,
                                'hello how are you 👋',
                                widget.roomId),
                            child: const Card(
                              color: AppColors.whiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '👋',
                                      style: TextStyle(fontSize: 50),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Say hello how are you',
                                      style: AppTextStyle.styleRegularBlack16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                  }),
              Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, right: 10, left: 7),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .8,
                        child: TextField(
                          controller: messageController,
                          autocorrect: true,
                          cursorColor: AppColors.darkGreenColor,
                          decoration: InputDecoration(
                            suffixIcon: SizedBox(
                              width: MediaQuery.sizeOf(context).width * .25,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Iconsax.emoji_normal,
                                        color: AppColors.darkGreenColor,
                                      )),
                                  IconButton(
                                      onPressed: () async {
                                        XFile? image = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        if (image != null) {
                                          FireStorage().uploadImageInChat(
                                              File(image.path),
                                              widget.roomId,
                                              widget.chatUserModel.uid);
                                        }
                                      },
                                      icon: const Icon(
                                        Iconsax.camera,
                                        color: AppColors.darkGreenColor,
                                      )),
                                ],
                              ),
                            ),
                            hintText: 'Send Message',
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.darkGreenColor,
                                ),
                                borderRadius: BorderRadius.circular(15)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.blackColor,
                                ),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CircleAvatar(
                        backgroundColor: AppColors.darkGreenColor,
                        radius: 25,
                        child: IconButton(
                            onPressed: () {
                              if (messageController.text.isNotEmpty) {
                                FirebaseDatabase()
                                    .sendMessage(widget.chatUserModel.uid,
                                        messageController.text, widget.roomId)
                                    .then((value) {
                                  setState(() {
                                    messageController.clear();
                                  });
                                });
                              }
                            },
                            icon: const Icon(
                              Iconsax.send1,
                              color: AppColors.whiteColor,
                            )),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
