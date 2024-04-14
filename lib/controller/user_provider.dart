import 'package:flutter/material.dart';
import 'package:yabyab_app/core/models/user_model.dart';
import 'package:yabyab_app/core/remote_data/firestore.dart';

class UserProvider with ChangeNotifier {
  UsersModel ? usersData ;
  UsersModel ? get getUserData {
    return usersData ;
  }

  void fetchUserData ({required userId}) async {
    UsersModel user = await FirestoreMethods().fetchUserDetailsFromFirestore(userId: userId);
    usersData = user ;
    notifyListeners();
  }

  void increaseFollowers () {
    getUserData!.followers.length++;
    notifyListeners();
  }

  void decreaseFollowers () {
    getUserData!.followers.length--;
    notifyListeners();
  }

  void deleteStoryFromProvider ({required Map story}){
    usersData!.stories.removeWhere((element) {
      return element == story ;
    });
    notifyListeners();
  }

}