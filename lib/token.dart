import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cravy/token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenManager {

  static const int maxTokensPerDay = 5000;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _tokenRef = _firestore.collection('tokens');

  /// Generates a new token for an order after successful payment.
  static Future<int?> generateToken(String orderId, String userId, WidgetRef ref) async {
    try {
      DocumentReference tokenDoc = _tokenRef.doc('current');
      DocumentSnapshot tokenSnapshot = await tokenDoc.get();

      int currentToken = 0;

      if (tokenSnapshot.exists) {
        currentToken = (tokenSnapshot['lastToken'] ?? 0) + 1;
      }

      if (currentToken > maxTokensPerDay) {
        return null; // No more tokens available for today
      }

      // Store token in Firestore
      await tokenDoc.set({'lastToken': currentToken}, SetOptions(merge: true));
      // Store the token under the user’s ID
      await _tokenRef.doc(userId).set({
        'tokenNumber': currentToken,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': userId,
      });

      await _tokenRef.doc(orderId).set({
        'orderId': orderId,
        'tokenNumber': currentToken,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ref.read(tokenProvider.notifier).updateToken(currentToken);

      return currentToken;
    } catch (e) {
      print("Error generating token: $e");
      return null;
    }
  }

  /// Retrieves a user's token based on their order ID.
  static Future<int?> getUserToken(String orderId) async {
    try {
      DocumentSnapshot tokenDoc = await _tokenRef.doc(orderId).get();
      return tokenDoc.exists ? tokenDoc['tokenNumber'] as int? : null;
    } catch (e) {
      print("Error fetching token: $e");
      return null;
    }
  }

  /// Resets tokens globally at midnight.
  static Future<void> resetTokens() async {
    try {
      await _tokenRef.doc('current').set({'lastToken': 0});
      print("Tokens reset successfully at midnight.");
    } catch (e) {
      print("Error resetting tokens: $e");
    }
  }

  /// Schedules an automatic reset using Firestore's timestamp check.
  static Future<void> checkAndResetTokens() async {
    try {
      DocumentReference resetDoc = _tokenRef.doc('resetTime');
      DocumentSnapshot resetSnapshot = await resetDoc.get();

      DateTime lastReset = resetSnapshot.exists
          ? (resetSnapshot['lastReset'] as Timestamp).toDate()
          : DateTime(2000); // Default old date

      DateTime now = DateTime.now();

      if (now.difference(lastReset).inDays >= 1) {
        await resetTokens();
        await resetDoc.set({'lastReset': Timestamp.now()});
      }
    } catch (e) {
      print("Error checking/resetting tokens: $e");
    }
  }
}
