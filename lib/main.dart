import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yabyab_app/core/local_data/catch_helper.dart';
import 'package:yabyab_app/core/services/services_locator.dart';
import 'package:yabyab_app/yab_yab_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  await getIt<CacheHelper>().cacheInit();
  await Firebase.initializeApp();
  runApp(const YabYabApp());
}

