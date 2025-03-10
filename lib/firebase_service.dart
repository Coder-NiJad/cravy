import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  //final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print("User denied notifications.");
      return;
    }

    // Get and log the initial token
    _getToken();

    // Listen for token updates
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("Token updated: $newToken");
    });

    // Handle foreground notifications
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print("Foreground notification received: ${message.notification?.title}");
    //   _showNotification(message);
    // });

    // Handle notification taps when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("User tapped on notification: ${message.notification?.title}");
    });
  }

  Future<void> _getToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      print("FCM Token: $token");
      // Send this token to your backend server if needed
    } else {
      print("Failed to retrieve FCM token.");
    }
  }

  // void _showNotification(RemoteMessage message) {
  //   var androidDetails = AndroidNotificationDetails(
  //     'channel_id', 'channel_name',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );
  //
  //   var notificationDetails = NotificationDetails(android: androidDetails);
  //
  //   _localNotificationsPlugin.show(
  //     0,
  //     message.notification?.title,
  //     message.notification?.body,
  //     notificationDetails,
  //   );
  // }
}
