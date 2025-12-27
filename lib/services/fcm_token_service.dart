import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmTokenService {
  final FirebaseMessaging messaging;
  final FirebaseFirestore firestore;

  FcmTokenService(this.messaging, this.firestore);

  /*Future<void> requestNotificationPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }*/

  Future<void> saveToken(String userId) async {
    if(Platform.isIOS){
      String? apnsToken;
      apnsToken = await messaging.getAPNSToken();

      if(apnsToken == null){
        return;
      }
    }
    final token = await messaging.getToken();
    if (token == null) return;

    await firestore.collection('users').doc(userId).update({
      'fcmToken': token,
    });
  }

  void listenTokenRefresh(String userId) {
    messaging.onTokenRefresh.listen((newToken) async {
      await firestore.collection('users').doc(userId).update({
        'fcmToken': newToken,
      });
    });
  }

  Future<void> clearToken(String userId) async {
    await firestore.collection('users').doc(userId).update({
      'fcmToken': FieldValue.delete(),
    });
  }
}
