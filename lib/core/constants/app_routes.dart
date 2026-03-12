import 'package:flutter/material.dart';
import 'package:shopy/features/Order/presentation/screens/my_orders.dart';
import 'package:shopy/features/auth/presentation/screens/login_screen.dart';
import 'package:shopy/features/auth/presentation/screens/new_password.dart';
import 'package:shopy/features/auth/presentation/screens/reset_password.dart';
import 'package:shopy/features/auth/presentation/screens/signup_screen.dart';
import 'package:shopy/features/auth/presentation/screens/verification_code_page.dart';
import 'package:shopy/features/checkout/Presentation/Screens/checkout_page.dart';
import 'package:shopy/features/checkout/Presentation/Screens/delivery_address_page.dart';
import 'package:shopy/features/checkout/Presentation/Screens/new_address_page.dart';
import 'package:shopy/features/checkout/Presentation/Screens/new_card_page.dart';
import 'package:shopy/features/checkout/Presentation/Screens/payment_methods.dart';
import 'package:shopy/features/home/presentation/screens/faqs_page.dart';
import 'package:shopy/features/home/presentation/screens/main_page.dart';
import 'package:shopy/features/home/presentation/screens/my_details.dart';
import 'package:shopy/features/welcome/presentation/screen/on_boarding.dart';

Map<String, Widget Function(BuildContext)> appRotes = {
  '/onboarding' : (context) => OnBoarding(),
  '/signup' : (context) => SignupScreen(),
  '/login' : (context) => LoginScreen(),
  '/home' : (context) => MainPage(),
  '/reset_password' : (context) => ResetPassword(),
  '/verification_code' : (context) => VerificationCodePage(),
  '/new_password' : (context) => NewPasswordPage(),
  '/checkout' : (context) => CheckoutPage(),
  '/main_page': (context) => MainPage(),
  '/delivery_address_page': (context) => DeliveryAddressPage(),
  '/new_address_page': (context) => NewAddressPage(),
  '/payment_methods_page': (context) => PaymentMethods(),
  '/new_card_page': (context) => NewCardPage(),
  '/my_orders_page': (context) => MyOrders(),
  '/my_details_page': (context) => MyDetails(),
  'faqs_page': (context) => FaqsPage(),
  
};