// ignore_for_file: avoid_print, unused_local_variable

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseAPI {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    // print("Firebase Token: $fcmToken");
  }
}
