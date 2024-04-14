import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:yabyab_app/core/models/user_model.dart';

class FirestoreMethods {
  Future<UsersModel> fetchUserDetailsFromFirestore({required userId}) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return UsersModel.convertSnapToModel(snapshot);
  }

  void addLikeOnPost({required Map userPostMap}) async {
    if (userPostMap['likes'].contains(FirebaseAuth.instance.currentUser!.uid)) {
      await FirebaseFirestore.instance
          .collection('userPosts')
          .doc(userPostMap['postId'])
          .update({
        'likes':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('userPosts')
          .doc(userPostMap['postId'])
          .update({
        'likes':
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });
    }
  }

  void addLikeOnComment(
      {required Map commentMap,
      required postId,
      required userId,
      required commentId}) async {
    if (commentMap['commentLikes']
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      await FirebaseFirestore.instance
          .collection('userPosts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({
        'commentLikes':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('userPosts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({
        'commentLikes':
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });
    }
  }

  void deletePostFromPosts({required Map userPostMap}) async {
    if (FirebaseAuth.instance.currentUser!.uid == userPostMap['userId']) {
      await FirebaseFirestore.instance
          .collection('userPosts')
          .doc(userPostMap['postId'])
          .delete();
    }
  }

  void addComment(
      {required comment,
      required userImage,
      required postId,
      required userId,
      required userName}) async {
    final commentId = const Uuid().v4();
    await FirebaseFirestore.instance
        .collection('userPosts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .set({
      'comment': comment,
      'userImage': userImage,
      'userId': userId,
      'postId': postId,
      'commentId': commentId,
      'commentLikes': [],
      'userName': userName
    });
  }

  void followUsers({required userId}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'following': FieldValue.arrayUnion([userId])
    });
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'followers':
          FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });
  }

  void unFollowUsers({required userId}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'following': FieldValue.arrayRemove([userId])
    });
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'followers':
          FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
    });
  }

  void deleteStory({required Map story}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(story['userId'])
        .update({
      'stories': FieldValue.arrayRemove([story])
    });
  }

  void deleteStoryAfter24h({required Map story}) {
    Duration different = DateTime.now().difference(story['date'].toDate());
    if (different.inHours > 24) {
      deleteStory(story: story);
    }
  }
}
