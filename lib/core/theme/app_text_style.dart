import 'package:flutter/material.dart';
import 'package:shopy/core/theme/app_colors.dart';

class AppTextStyle {
  AppTextStyle._();

  static const String _font = 'GeneralSans';

  //  Headers
  static const TextStyle h1SemiBold = TextStyle(
    fontSize: 64,
    fontFamily: _font,
    fontWeight: FontWeight.w600,
    letterSpacing: -5,
    height: 0.8,
  );

  static const TextStyle h2SemiBold = TextStyle(
    fontSize: 32,
    fontFamily: _font,
    fontWeight: FontWeight.w600,
    letterSpacing: -2,
    height: 1,
  );

  static const TextStyle h3SemiBold = TextStyle(
    fontSize: 24,
    fontFamily: _font,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.2,
  );

  static const TextStyle h4SemiBold = TextStyle(
    fontSize: 20,
    fontFamily: _font,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.2,
  );
  static const TextStyle h4Medium = TextStyle(
    fontSize: 20,
    fontFamily: _font,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.2,
  );

  //Body
  static const TextStyle b1Regular = TextStyle(
    fontSize: 16,
    fontFamily: _font,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle b1Medium = TextStyle(
    color: AppColors.primary900Color,
    fontSize: 16,
    fontFamily: _font,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4
  );

  static const TextStyle b1SemiBold = TextStyle(
    fontSize: 16,
    fontFamily: _font,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4
  );

  static const TextStyle b2Regular = TextStyle(
    fontSize: 14,
    fontFamily: _font,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle b2Medium = TextStyle(
    fontSize: 14,
    fontFamily: _font,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4
  );

  static const TextStyle b2SemiBold = TextStyle(
    fontSize: 14,
    fontFamily: _font,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4
  );

  static const TextStyle b3Regular = TextStyle(
    fontSize: 12,
    fontFamily: _font,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle b3Medium = TextStyle(
    fontSize: 12,
    fontFamily: _font,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4
  );

  static const TextStyle b3SemiBold = TextStyle(
    fontSize: 12,
    fontFamily: _font,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4
  );
}
