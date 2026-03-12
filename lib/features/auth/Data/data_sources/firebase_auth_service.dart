import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shopy/core/errors/exceptions.dart';
import 'package:shopy/core/utils/otp_hasher.dart';
import 'package:shopy/features/auth/Data/models/user_model.dart';

class FirebaseAuthService {
  final FirebaseFunctions cloudFunctions;
  const FirebaseAuthService({required this.cloudFunctions});

  static const _usersCollection = 'Shopy_Users';

  Future<void> saveUserToDatabase({
    required String uid,
    required String name,
    required String email,
    required String provider,
  }) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userDocument =
          await FirebaseFirestore.instance
              .collection(_usersCollection)
              .doc(uid)
              .get();

      if (userDocument.exists) {
        return;
      } else {
        await FirebaseFirestore.instance
            .collection(_usersCollection)
            .doc(uid)
            .set({
              'uid': uid,
              'user_name': name,
              'user_email': email,
              'createdAt': FieldValue.serverTimestamp(),
              'provider': provider,
            });
      }
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<UserModel> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = credential.user;

      if (user == null) {
        throw AuthException(message: 'Faild To Create User');
      }
      // save user to Database
      await saveUserToDatabase(
        uid: user.uid,
        name: name,
        email: email,
        provider: 'email-password',
      );
      return UserModel(name: name, email: email, id: user.uid);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw AuthException(message: 'Email Already in use try another one');
        case 'weak-password':
          throw AuthException(
            message: 'Weak password! Please enter Stronge One',
          );
        case 'invalid-email':
          throw AuthException(message: 'Invalid email address');
        default:
          throw AuthException(message: e.message ?? 'Authentication error');
      }
    } catch (e) {
      throw AuthException(
        message: 'Unexpected error occurred, try again later',
      );
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user;
      if (user == null) throw AuthException(message: 'Faild to login');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          throw AuthException(message: 'Password Incorrect');
        case 'user-not-found':
          throw AuthException(message: 'This email does not exist.');
        case 'invalid-email':
          throw AuthException(message: 'The email format is invalid.');
        default:
          throw AuthException(message: e.message ?? 'Authentication error');
      }
    } catch (e) {
      throw AuthException(
        message: 'Unexpected error occurred, try again later',
      );
    }
  }

  // auth with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();

      if (googleUser == null) {
        throw AuthException(message: 'Google sign-in cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final User user = userCredential.user!;

      await saveUserToDatabase(
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',

        provider: 'Google',
      );

      // Once signed in, return the UserCredential
      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw AuthException(
            message: 'This Google Account Exists with different credential',
          );
        case 'network-request-failed':
          throw AuthException(
            message: 'Network Request Faild, Please try again later',
          );
        case 'user-disabled':
          throw AuthException(message: 'This User Account Disabled');
        default:
          throw AuthException(message: e.message ?? 'Authentication error');
      }
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw AuthException(message: 'Canceled');
      } else {
        throw AuthException(message: e.description ?? 'Authentication error');
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'network_error':
          throw const AuthException(message: 'Network Error');
        default:
          throw AuthException(message: e.message ?? 'Authentication error');
      }
    }
  }

  Future<UserCredential> signinWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );
      if (loginResult.accessToken == null) {
        throw AuthException(message: 'User Canceld');
      }
      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken.toString());

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      // facebook user
      final User facebookUser = userCredential.user!;

      // save the user to the data base
      await saveUserToDatabase(
        uid: facebookUser.uid,
        name: facebookUser.displayName ?? '',
        email: facebookUser.email ?? '',
        provider: 'Facebook',
      );

      // Once signed in, return the UserCredential
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<bool> verifyOtp({
    required String inputOtp,
    required String userEmail,
  }) async {
    try {
      final userQuery = await FirebaseFirestore.instance
          .collection('Shopy_Users')
          .where('user_email', isEqualTo: userEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw AuthException(message: 'Invalid email or OTP');
      }

      final userId = userQuery.docs.first.id;

      final otpQuery = await FirebaseFirestore.instance
          .collection('Shopy_Users')
          .doc(userId)
          .collection('Otps')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (otpQuery.docs.isEmpty) {
        throw AuthException(message: 'Invalid email or OTP');
      }

      final otpDoc = otpQuery.docs.first;
      final otpData = otpDoc.data();

      final expiresAt = (otpData['expiresAt'] as Timestamp).toDate();

      if (DateTime.now().isAfter(expiresAt)) {
        await otpDoc.reference.delete();
        throw AuthException(message: 'Invalid or expired OTP');
      }

      final salt = otpData['salt'];
      final storedHash = otpData['otpHash'];
      final inputHash = OtpHasher.hashOtp(otp: inputOtp, salt: salt);

      final isValid = storedHash == inputHash;

      if (isValid) {
        await otpDoc.reference.delete();
      }

      return isValid;
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<void> changePassword({required String newPassword, required String userEmail}) async {
    try {
      await cloudFunctions.httpsCallable('changePassword').call({
        'newPassword': newPassword,
        'email': userEmail
      });
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'unauthenticated') {
        print("User not logged in");
        throw FirebaseCustomException(message: e.message ?? e.toString());
      }
      throw FirebaseCustomException(message: e.message ?? e.toString());
    } catch (e) {
      throw FirebaseCustomException(message: e.toString());
    }
  }
}
