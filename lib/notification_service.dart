import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission();

    // Get FCM token for debugging
    String? token = await _firebaseMessaging.getToken();
    debugPrint("FCM Token: $token");

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Foreground Notification Received: ${message.notification?.title}");
      // You can implement additional logic to handle UI updates or alerts.
    });

    // Handle when a notification is tapped and app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("User tapped on notification: ${message.data}");
      // Handle navigation or other logic here
    });
  }
}
