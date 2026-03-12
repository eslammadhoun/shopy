import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopy/core/errors/exceptions.dart';

class GeolocatorDatasource {
  Future<LatLng?> getUserLocation() async {
    try {
      final bool isGpsServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isGpsServiceEnabled) {
        throw GeolocatorCustomException(
          message: 'Location services are disabled',
        );
      }
      LocationPermission locationPermission =
          await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
      }

      if (locationPermission == LocationPermission.denied ||
          locationPermission == LocationPermission.deniedForever) {
        throw GeolocatorCustomException(
          message: 'You Need to enable required location permission',
        );
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      throw GeolocatorCustomException(message: e.toString());
    }
  }
}
