import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shopy/core/constants/app_routes.dart';
import 'package:shopy/core/constants/cubit_providers.dart';
import 'package:shopy/core/di/service_locator.dart';
import 'package:shopy/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopy/features/welcome/presentation/screen/splash_page.dart';
import 'package:shopy/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 100),
      minimumFetchInterval: const Duration(seconds: 0),
    ),
  );

  await remoteConfig.fetchAndActivate();
  final String stripePublishableKey = remoteConfig.getString(
    'stripe_publishable_key',
  );
  if (stripePublishableKey.isEmpty) {
    throw Exception('Stripe publishable key is empty');
  }
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();
  await setupDI();
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: cubitProviders,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
        routes: appRotes,
      ),
    );
  }
}
