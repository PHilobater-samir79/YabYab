import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';
import 'package:yabyab_app/core/models/chat_group_model.dart';
import 'package:yabyab_app/core/models/chat_room_model.dart';
import 'package:yabyab_app/core/models/message_model.dart';

class FirebaseDatabase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String myId = FirebaseAuth.instance.currentUser!.uid;

  Future creatRoom(String email) async {
    QuerySnapshot userEmail = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (userEmail.docs.isNotEmpty) {
      String otherMembareId = userEmail.docs.first.id;
      List<String> members = [myId, otherMembareId]..sort(
          (a, b) => a.compareTo(b),
        );
      QuerySnapshot roomExist = await firestore
          .collection('rooms')
          .where('members', isEqualTo: members)
          .get();

      if (roomExist.docs.isEmpty) {
        ChatRooomModel chatRooomModel = ChatRooomModel(
            chatRoomId: members.toString(),
            createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
            lastMessage: '',
            lastMessageTime: DateTime.now().millisecondsSinceEpoch.toString(),
            members: members);
        await firestore
            .collection('rooms')
            .doc(members.toString())
            .set(chatRooomModel.toJson());
      }
    }
  }

  Future sendMessage(String receiverId, String message, String roomId,
      {String? type}) async {
    String messageId = const Uuid().v4();
    MessageModel messageModel = MessageModel(
        message: message,
        messageId: messageId,
        senderId: myId,
        receiverId: receiverId,
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type ?? 'text',
        readAt: '');
    await firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(messageId)
        .set(messageModel.toJson());
    firestore.collection('rooms').doc(roomId).update({
      'lastMessage': type ?? message,
      'lastMessageTime': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  Future readMessage(String roomId, String messageId) async {
    await firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(messageId)
        .update({'readAt': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  Future deleteMessages(String roomId, List<String> selectedMessages) async {
    for (var element in selectedMessages) {
      await firestore
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .doc(element)
          .delete();
    }
  }

  Future creatGroupRoom(
    String groupName,
    List members,
  ) async {
    String groupId = const Uuid().v4();
    members.add(myId);
    ChatGroupModel chatGroupModel = ChatGroupModel(
        groupId: groupId,
        groupName: groupName,
        members: members,
        groupImage: '',
        admins: [myId],
        lastMessage: '',
        lastMessageTime: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now().millisecondsSinceEpoch.toString());
    await firestore
        .collection('groups')
        .doc(groupId)
        .set(chatGroupModel.toJson());
  }
}
