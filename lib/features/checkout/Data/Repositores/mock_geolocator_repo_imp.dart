import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/checkout/Domain/repositores/geolocator_repository.dart';

class MockgeoLocatorRepoImp implements GeolocatorRepository {
  @override
  Future<Either<Failure, LatLng>> getUserLocation() async {
    return Right(LatLng(31.52702, 34.46));
  }
}