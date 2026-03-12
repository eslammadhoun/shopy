import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopy/core/errors/failures.dart';

abstract class GeolocatorRepository {

  // Get the user current location -> to add new delivery address
  Future<Either<Failure, LatLng>> getUserLocation();
}