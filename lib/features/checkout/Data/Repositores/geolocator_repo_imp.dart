import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shopy/core/errors/failures.dart';
import 'package:shopy/features/checkout/Data/Data_Sources/geolocator_datasource.dart';
import 'package:shopy/features/checkout/Domain/repositores/geolocator_repository.dart';

class GeolocatorRepoImp implements GeolocatorRepository {
  final GeolocatorDatasource geolocatorDatasource;
  const GeolocatorRepoImp({required this.geolocatorDatasource});

  // implement the get user location abstract function
  @override
  Future<Either<Failure, LatLng>> getUserLocation() async {
    try {
      final LatLng? latLng = await geolocatorDatasource.getUserLocation();
      return Right(latLng!);
    } catch (e) {
      return Left(GeolocatorFailure(e.toString()));
    }
  }
}