import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cravy/splash_screen.dart';
import 'package:cravy/token_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'firebase_service.dart';
import 'login_screen.dart';
import 'notification_service.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void handleNotificationTap(RemoteMessage message) {
  if (message.data.isNotEmpty) {
    String? screen =
        message.data['screen']; // The screen name from notification data

    if (screen != null) {
      navigatorKey.currentState?.pushNamed(screen);
    }
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.initialize(); // Initialize FCM

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseService firebaseService = FirebaseService();
  await firebaseService.initialize();
  await FirebaseMessaging.instance.requestPermission();

  Future<void> setupFirebaseMessaging() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print("📲 FCM Token: $token");

      RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
      if (message != null) {
        handleNotificationTap(message);
      }

      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        handleNotificationTap(message);
      });
    } catch (e) {
      print("❌ Error setting up Firebase Messaging: $e");
    }
  }

  // await FirebaseAppCheck.instance.activate(
  //   webProvider: ReCaptchaEnterpriseProvider(
  //     '6LcuTe4qAAAAADqrlpL2c2zjLVlytoC6GejgDcBu',
  //   ),
  //
  // );
  await setupFirebaseMessaging();
  runApp(ProviderScope(child: MyApp()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message: ${message.notification?.title}");
      // Handle notification UI or logic
    });

    return Consumer(
      builder: (context, ref, child) {
        final token = ref.watch(tokenProvider);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}

class StillScreen extends StatelessWidget {
  const StillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.jpg', //bg image
              fit: BoxFit.cover,
              color: Colors.black.withValues(
                red: 0,
                green: 0,
                blue: 0,
                alpha: 0.55 * 255,
              ),
              colorBlendMode: BlendMode.overlay,
            ),
          ),
          Center(
            child: SizedBox(
              height: 700,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('assets/images/cravybglogo.png'),
                  ), //logo
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: FloatingActionButton(
                      backgroundColor: Colors.red[600],
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
