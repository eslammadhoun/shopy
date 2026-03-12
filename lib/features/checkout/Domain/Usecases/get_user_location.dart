import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/checkout/Domain/repositores/geolocator_repository.dart';

class GetUserLocation {
  final GeolocatorRepository geolocatorRepository;
  const GetUserLocation({required this.geolocatorRepository});

  // get user location use case -> to add new delivery address
  Future<Either<Failure, LatLng>> call() async {
    return await geolocatorRepository.getUserLocation();
  }
}