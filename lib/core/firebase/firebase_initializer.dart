import 'package:firebase_core/firebase_core.dart';
import 'package:shopy/firebase_options.dart';

class FirebaseInitializer {
  static Future<void> firebaseInit() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  }
}