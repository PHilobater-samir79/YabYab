import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:yabyab_app/core/remote_data/firebase_database.dart';

class FireStorage {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  uploadImageInChat(File file, String roomId, String receiverId) async {
    final saveImage = FirebaseStorage.instance
        .ref()
        .child('chatImages')
        .child('image/$roomId/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await saveImage.putFile(file);
    final imageUrl = await saveImage.getDownloadURL();
    FirebaseDatabase().sendMessage(receiverId, imageUrl, roomId, type: 'image');
  }
}
