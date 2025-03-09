import 'package:cravy/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:"928895619267-59euofqvpbdtip0njth6vbt15cr75pnn.apps.googleusercontent.com",
  );

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled sign-in

      // Obtain the Google Sign-In authentication details
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in the user with Firebase
      UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // Navigate to home screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));

      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Failed ❌: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
