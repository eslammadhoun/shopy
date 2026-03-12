import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary900Color = Color(0xff1A1A1A);

  // Text
  static const Color primary800Color = Color(0xff333333);
  static const Color primary700Color = Color(0xff4D4D4D);
  static const Color primary600Color = Color(0xff666666);
  static const Color primary500Color = Color(0xff808080);
  static const Color primary400Color = Color(0xff999999);
  static const Color primary300Color = Color(0xffB3B3B3);
  static const Color primary200Color = Color(0xffCCCCCC);
  static const Color primary100Color = Color(0xffE6E6E6);

  // Background
  static const Color background = Color(0xffFFFFFF);

  // States
  static const Color success = Color(0xFF0C9409);
  static const Color error = Color(0xFFED1010);
  static const Color blue = Color(0xff1877F2);

  // map style
  static const String lightMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      { "color": "#f5f5f5" }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      { "visibility": "off" }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#616161" }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      { "color": "#f5f5f5" }
    ]
  },
  {
    "featureType": "poi",
    "stylers": [
      { "visibility": "off" }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      { "color": "#ffffff" }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#757575" }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      { "color": "#e9e9e9" }
    ]
  }
]
''';
}
