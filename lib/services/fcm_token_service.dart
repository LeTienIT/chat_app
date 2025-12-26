import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmTokenService {
  final FirebaseMessaging messaging;
  final FirebaseFirestore firestore;

  FcmTokenService(this.messaging, this.firestore);

  Future<void> saveToken(String userId) async {
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
