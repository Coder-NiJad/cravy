// main.dart// login_screen.dart
// main.dart
import 'package:cravy/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'login_screen.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(
  //   webProvider: ReCaptchaEnterpriseProvider(
  //     '6LcuTe4qAAAAADqrlpL2c2zjLVlytoC6GejgDcBu',
  //   ),
  //
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
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
                color: Colors.black.withOpacity(0.55),
                colorBlendMode: BlendMode.overlay,
              ),
            ),
            Center(
              child: SizedBox(
                height: 700,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Image(image: AssetImage('assets/images/cravybglogo.png')), //logo
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
                                fontSize: 18

                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          }),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
