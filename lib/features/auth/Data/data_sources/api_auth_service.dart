import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:shopy/core/errors/exceptions.dart';
import 'package:shopy/core/utils/otp_hasher.dart';

// API SERVICE PROVIDER
class ApiAuthService {
  Future<void> sendOtpCode(String email, int otpCode) async {
    try {
      // find out if the user in the database
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Shopy_Users')
              .where('user_email', isEqualTo: email)
              .get();
      if (querySnapshot.docs.isEmpty) {
        throw Exception('User Is Not Registred in our database');
      }

      // get user id
      final Map<String, dynamic> userData = querySnapshot.docs.first.data();
      final userId = userData['uid'];

      // if the user exsist => send the otp code to the user email
      final postResponse = await http.post(
        Uri.parse('https://api.resend.com/emails'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer re_Ck6KCrSA_HRdgUqZUaHHHRt3Fu8HgNbcV',
        },
        body: json.encode({
          'from': 'Shopy <onboarding@resend.dev>',
          'to': email,
          'subject': 'Your verification code',
          'html': '<h2>Your OTP code</h2><p><b>$otpCode</b></p>',
        }),
      );
      if (postResponse.statusCode != 200 && postResponse.statusCode != 202) {
        throw Exception(
          'Faield to send the otp code to this email, please try again later.',
        );
      }
      // get the otp email id
      final Map<String, dynamic> postResponseData = jsonDecode(
        postResponse.body,
      );
      final String otpEmailId = postResponseData['id'];

      // encrypt the otp code
      final salt = OtpHasher.generateSalt();
      final otpHash = OtpHasher.hashOtp(otp: otpCode.toString(), salt: salt);

      // store the otp code in the firestore database
      await FirebaseFirestore.instance
          .collection('Shopy_Users')
          .doc(userId)
          .collection('Otps')
          .doc(otpEmailId)
          .set({
            'salt': salt,
            'otpHash': otpHash,
            'createdAt': FieldValue.serverTimestamp(),
            'expiresAt': Timestamp.fromDate(
              DateTime.now().add(const Duration(minutes: 10)),
            ),
          });
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}
