import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yabyab_app/core/models/chat_room_model.dart';
import 'package:yabyab_app/core/models/chat_user_model.dart';
import 'package:yabyab_app/core/models/message_model.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';
import 'package:yabyab_app/screens/chat/messages_screen.dart';

import '../../../core/utils/Text_style/app_text_style.dart';

class MyChats extends StatefulWidget {
  final ChatRooomModel items;
  const MyChats({
    super.key,
    required this.items,
  });

  @override
  State<MyChats> createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chatUsersDate')
          .doc(widget.items.members!
              .where((element) =>
                  element != FirebaseAuth.instance.currentUser!.uid)
              .toList()
              .first)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        }
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Text('we have error');
        }
        ChatUserModel chatUserModel =
            ChatUserModel.fromJson(snapshot.data!.data()!);
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return MessagesScreen(
                  chatUserModel: chatUserModel,
                  roomId: widget.items.chatRoomId!,
                );
              },
            ));
          },
          child: ListTile(
            title: Text(
              chatUserModel.userName,
              style: AppTextStyle.styleRegularBlack16,
            ),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(chatUserModel.userProfileImage),
            ),
            trailing: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('rooms')
                  .doc(widget.items.chatRoomId)
                  .collection('messages')
                  .snapshots(),
              builder: (context, snapshot) {
                final unReadList = snapshot.data?.docs
                        .map((e) => MessageModel.fromJson(e.data()))
                        .where((element) => element.readAt == '')
                        .where((element) =>
                            element.senderId !=
                            FirebaseAuth.instance.currentUser!.uid) ??
                    [];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat.jm()
                          .format(DateTime.fromMillisecondsSinceEpoch(
                              int.parse(widget.items.lastMessageTime!)))
                          .toString(),
                      style: AppTextStyle.styleRegularBlack16,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    unReadList.isEmpty
                        ? const SizedBox()
                        : CircleAvatar(
                            backgroundColor: AppColors.whiteColor,
                            radius: 10,
                            child: Text(
                              '${unReadList.length}',
                              style: AppTextStyle.styleRegularGreen16,
                            ),
                          )
                  ],
                );
              },
            ),
            subtitle: Text(
              widget.items.lastMessage! == ''
                  ? chatUserModel.about
                  : widget.items.lastMessage!,
              style: AppTextStyle.styleRegularGrey20.copyWith(fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
