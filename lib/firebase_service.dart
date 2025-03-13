import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initialize() async {
    await _requestPermissions();
    _setupFCMListeners();  //
    await _saveFCMToken();

    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print("User denied notifications.");
      return;
    }

    _getToken(); // Get initial token
    _listenForTokenRefresh(); //
  }

  void _setupFCMListeners() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Foreground Notification: ${message.notification?.title}");
      _showNotification(message);
    });

    // Handle background messages when user taps the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📩 App Opened from Background: ${message.notification?.title}");
    });
  }

  void _listenForTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print("FCM Token Refreshed: $newToken");
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('users').doc(userId).update({'fcmToken': newToken});
      }
    });
  }

  Future<void> _getToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      print("FCM Token: $token");
    } else {
      print("Failed to retrieve FCM token.");
    }
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission for notifications.");
    } else {
      print("User denied notification permissions.");
    }
  }

  Future<void> _saveFCMToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      print("FCM Token: $token");
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('users').doc(userId).update({'fcmToken': token});
      }
    }
  }

  void _showNotification(RemoteMessage message) {
    print("Notification Received: ${message.notification?.title}");
    // You can add a Snackbar or Custom Dialog here
  }
}
