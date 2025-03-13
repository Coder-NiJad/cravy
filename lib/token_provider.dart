import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final tokenProvider = StateNotifierProvider<TokenNotifier, int?>((ref) {
  return TokenNotifier();
});

class TokenNotifier extends StateNotifier<int?> {
  TokenNotifier() : super(null) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = prefs.getInt('latestToken'); // Fetch latest token
  }

  Future<void> updateToken(int newToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('latestToken', newToken);
    state = newToken;
  }

  Future<void> resetToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('dailyToken');
    state = null;
  }

  void setToken(int token) {
    state = token;
  }
}
