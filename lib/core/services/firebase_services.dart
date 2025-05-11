import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_bake/core/app_keys.dart';
import 'package:home_bake/core/services/local_notification_services.dart';
import 'package:home_bake/firebase_options.dart';

class FirebaseServices {
  static final FirebaseServices _instance = FirebaseServices._internal();
  final storageBox = GetStorage();
  factory FirebaseServices() {
    return _instance;
  }

  FirebaseServices._internal();

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get fireStore => FirebaseFirestore.instance;
  FirebaseMessaging get messaging => FirebaseMessaging.instance;

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await LocalNotificationServices.instance.initialize(); // Initialize notifications
  }

}
