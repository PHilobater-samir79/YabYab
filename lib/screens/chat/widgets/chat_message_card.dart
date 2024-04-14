import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:yabyab_app/core/models/message_model.dart';
import 'package:yabyab_app/core/remote_data/firebase_database.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';

class ChatMessageCard extends StatefulWidget {
  final int index;
  final MessageModel messageModel;
  final String roomId;
  final bool isSelected;
  const ChatMessageCard({
    required this.isSelected,
    required this.roomId,
    required this.index,
    required this.messageModel,
    super.key,
  });

  @override
  State<ChatMessageCard> createState() => _ChatMessageCardState();
}

class _ChatMessageCardState extends State<ChatMessageCard> {
  @override
  void initState() {
    super.initState();
    if (widget.messageModel.receiverId ==
        FirebaseAuth.instance.currentUser!.uid) {
      FirebaseDatabase()
          .readMessage(widget.roomId, widget.messageModel.messageId);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMe =
        widget.messageModel.senderId == FirebaseAuth.instance.currentUser!.uid;
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          color: widget.isSelected == true
              ? AppColors.greyColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 1),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            isMe
                ? IconButton(
                    onPressed: () {}, icon: const Icon(Iconsax.message_edit))
                : const SizedBox(),
            Card(
              color: isMe ? Colors.black87 : AppColors.darkGreenColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomRight: Radius.circular(isMe ? 0 : 12),
                  bottomLeft: Radius.circular(isMe ? 12 : 0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * .7),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      widget.messageModel.type == 'image'
                          ? CachedNetworkImage(
                              imageUrl: widget.messageModel.message,
                              placeholder: (context, url) {
                                return const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Loading...',
                                      style: AppTextStyle.styleRegularGreen16,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CircularProgressIndicator(
                                      color: AppColors.darkGreenColor,
                                    ),
                                  ],
                                );
                              },
                            )
                          : Text(
                              widget.messageModel.message,
                              style: AppTextStyle.styleRegularBlack20.copyWith(
                                  color: AppColors.whiteColor, fontSize: 18),
                            ),
                      const SizedBox(
                        height: 7,
                      ),
                      isMe
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat.jm()
                                      .format(DateTime
                                          .fromMillisecondsSinceEpoch(int.parse(
                                              widget.messageModel.createdAt)))
                                      .toString(),
                                  style: AppTextStyle.styleRegularBlack16
                                      .copyWith(
                                          fontSize: 10,
                                          color: AppColors.whiteColor),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  color: widget.messageModel.readAt == ''
                                      ? AppColors.whiteColor
                                      : AppColors.darkGreenColor,
                                  Iconsax.tick_circle,
                                  size: 15,
                                )
                              ],
                            )
                          : Text(
                              DateFormat.jm()
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(widget.messageModel.createdAt)))
                                  .toString(),
                              style: AppTextStyle.styleRegularBlack16.copyWith(
                                  fontSize: 10, color: AppColors.whiteColor),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
