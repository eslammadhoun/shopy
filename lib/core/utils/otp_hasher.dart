import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class OtpHasher {
  static String generateSalt([int length = 16]) {
    final rand = Random.secure();
    final values = List<int>.generate(length, (_) => rand.nextInt(256));
    return base64UrlEncode(values);
  }

  static String hashOtp({
    required String otp,
    required String salt,
  }) {
    final bytes = utf8.encode('$otp$salt');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
