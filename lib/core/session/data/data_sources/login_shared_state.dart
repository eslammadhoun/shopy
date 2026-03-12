import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopy/core/errors/exceptions.dart';

class LoginSharedState {
  final SharedPreferences prefs;
  const LoginSharedState(this.prefs);

  static const String _isLoggedInKey = 'is_logged_key';

  // Get The Login Status
  bool get isLoggedIn {
    try {
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  // Toggle Login Status
  Future<bool> setAuthState(bool newState) async {
    try {
      final bool result = await prefs.setBool(_isLoggedInKey, newState);
      if (result != newState) {
        throw CacheException(message: 'Faild to Switch Login Status');
      }
      return result;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
