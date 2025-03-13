import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cravy/token_provider.dart';
import 'package:cravy/home_screen.dart';

import 'main.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnAuth();
  }

  Future<void> _navigateBasedOnAuth() async {
    await Future.delayed(const Duration(seconds: 4)); // Keep splash delay

    FirebaseAuth.instance.authStateChanges().first.then((user) async {
      if (user != null) {
        await _fetchUserToken(ref, user.uid);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const StillScreen()),
          );
        }
      }
    }).catchError((error) {
      print("❌ Auth state error: $error");
    });
  }


  /// Fetch latest token for the authenticated user
  Future<void> _fetchUserToken(WidgetRef ref, String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('tokens')
          .doc(userId)
          .get()
          .timeout(const Duration(seconds: 5)); // Prevents indefinite hang

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        ref.read(tokenProvider.notifier).updateToken(data['tokenNumber']);
      }
    } catch (e) {
      print("❌ Firestore error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/cravybglogo.png'),
      ),
    );
  }
}
